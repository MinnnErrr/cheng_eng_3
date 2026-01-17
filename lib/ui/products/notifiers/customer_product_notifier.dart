
import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/data/services/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_product_notifier.g.dart';

@riverpod
class CustomerProductNotifier extends _$CustomerProductNotifier {
  ProductService get _productService => ref.read(productServiceProvider);

  @override
  FutureOr<List<Product>> build() async {
    return await _productService.getActiveProducts();
  }

}
