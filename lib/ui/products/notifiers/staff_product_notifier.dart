import 'dart:io';

import 'package:cheng_eng_3/domain/models/message_model.dart';
import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/data/services/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'staff_product_notifier.g.dart';

@riverpod
class StaffProductNotifier extends _$StaffProductNotifier {
  ProductService get _productService => ref.read(productServiceProvider);
  ImageService get _imageService => ref.read(imageServiceProvider);

  @override
  FutureOr<List<Product>> build() async {
    return await _productService.getAllProducts();
  }

  Future<Message> addProduct({
    required String name,
    required String category,
    required String brand,
    String? model,
    String? colour,
    required String description,
    required bool status,
    required ProductAvailability availability,
    int? quantity,
    required bool installation,
    double? installationFee,
    required double price,
    String? remarks,
    required List<File> photos,
  }) async {
    final productId = Uuid().v4();
    List<String> photoPaths = [];

    if (photos.isNotEmpty) {
      String photoId = Uuid().v4();

      for (File photo in photos) {
        try {
          final photoPath = await _imageService.uploadImage(
            photoFile: photo,
            tableName: 'products',
            id: '$productId/$photoId',
          );
          photoPaths.add(photoPath);
        } catch (e) {
          return Message(
            isSuccess: false,
            message: 'Failed to upload pictures',
          );
        }
      }
    }

    final product = Product(
      id: productId,
      createdAt: DateTime.now(),
      name: name,
      category: category,
      brand: brand,
      model: model,
      colour: colour,
      description: description,
      status: status,
      availability: availability,
      installation: installation,
      price: price,
      quantity: quantity,
      installationFee: installationFee,
      remarks: remarks,
      photoPaths: photoPaths,
    );

    try {
      await _productService.create(product);
      return Message(isSuccess: true, message: 'Product added');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to add product');
    }
  }

  Future<Message> updateProduct({
    required Product currentProduct,
    required String name,
    required String category,
    required String brand,
    String? model,
    String? colour,
    required String description,
    required ProductAvailability availability,
    int? quantity,
    required bool installation,
    double? installationFee,
    required double price,
    String? remarks,
    required List<dynamic> photos,
  }) async {
    String extractPathFromUrl(String url) {
      final uri = Uri.parse(url);
      final idx = uri.pathSegments.indexOf('images');
      if (idx == -1) return '';
      return uri.pathSegments.sublist(idx + 1).join('/');
    }

    //photo
    List<String> newPaths = [];

    for (final photo in photos) {
      late String path;
      if (photo is String) {
        path = extractPathFromUrl(photo);
      } else if (photo is File) {
        final photoId = Uuid().v4();
        try {
          path = await _imageService.uploadImage(
            photoFile: photo,
            tableName: 'products',
            id: '${currentProduct.id}/$photoId',
          );
        } catch (e) {
          return Message(
            isSuccess: false,
            message: 'Failed to upload pictures',
          );
        }
      } else {
        continue;
      }
      newPaths.add(path);
    }

    final product = currentProduct.copyWith(
      name: name,
      category: category,
      brand: brand,
      model: model,
      colour: colour,
      description: description,
      availability: availability,
      quantity: quantity,
      installation: installation,
      installationFee: installationFee,
      price: price,
      remarks: remarks,
      photoPaths: newPaths,
      updatedAt: DateTime.now(),
    );

    try {
      await _productService.update(product);
      return Message(isSuccess: true, message: 'Product updated');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to update product');
    }
  }

  Future<Message> updateStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _productService.updateStatus(isActive, id);

      return Message(isSuccess: true, message: 'Status updated');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to update status');
    }
  }

  Future<Message> decreaseQuantity({
    required Product product,
  }) async {
    try {
      if (product.quantity == null || product.quantity == 0) {
        return Message(
          isSuccess: false,
          message: 'Quantitiy is not set or quantity is 0',
        );
      }

      final newQty = product.quantity! - 1;

      await _productService.updateQuantity(newQty, product.id);

      return Message(isSuccess: true, message: 'Quantity updated');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to update quantity');
    }
  }

  Future<Message> deleteProduct(String id) async {
    try {
      await _productService.delete(id);

      return Message(isSuccess: true, message: 'Product deleted');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to delete product');
    }
  }
}
