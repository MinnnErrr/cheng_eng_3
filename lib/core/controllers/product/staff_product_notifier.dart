import 'dart:io';

import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/core/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // void refresh() => ref.invalidateSelf();

  Future<bool> addProduct({
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
          return false;
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
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
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
    final previous = state.value ?? [];
    final currentProduct = previous.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );

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
        path = await _imageService.uploadImage(
          photoFile: photo,
          tableName: 'products',
          id: '$id/$photoId',
        );
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
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _productService.updateStatus(isActive, id);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> descreaseQuantity({
    required String id,
  }) async {
    try {
      final previous = state.value ?? [];
      final currentProduct = previous.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Product not found'),
      );

      late int newQty;

      if (currentProduct.quantity != null) {
        newQty = currentProduct.quantity! - 1;
      } else {
        return false;
      }

      await _productService.updateQuantity(newQty, id);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await _productService.delete(id);

      return true;
    } catch (e) {
      return false;
    }
  }
}

final staffProductByIdProvider = Provider.family<AsyncValue<Product>, String>((
  ref,
  productId,
) {
  final productList = ref.watch(staffProductProvider);

  return productList.when(
    data: (list) {
      final product = list.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );
      return AsyncValue.data(product);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, st) => AsyncValue.error(err, st),
  );
});
