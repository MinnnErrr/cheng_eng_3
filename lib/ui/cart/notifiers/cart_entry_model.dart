import '../../../domain/models/cart_item_model.dart';
import '../../../domain/models/product_model.dart';

class CartEntry {
  final CartItem item;
  final Product? product;

  const CartEntry({
    required this.item,
    required this.product,
  });

  double get unitPrice => product?.price ?? 0.0;

  bool get hasInstallation =>
      product?.installation == true && item.installation == true;

  double get priceTotal => unitPrice * item.quantity;

  double get installationTotal {
    if (hasInstallation && product?.installationFee != null) {
      return product!.installationFee! * item.quantity;
    }
    return 0.0;
  }

  double get rowTotal => priceTotal + installationTotal;

  bool get isProductExist {
    if (product == null) {
      return false;
    }
    return true;
  }

  bool get isProductActive {
    if (product != null && product!.status == false) {
      return false;
    }
    return true;
  }

  bool get isSoldOut {
    if (product != null &&
        product!.quantity != null &&
        product!.quantity! <= 0) {
      return true;
    }
    return false;
  }

  bool get isMaxStock {
    if (product != null &&
        product!.quantity != null &&
        product!.quantity! < item.quantity) {
      return true;
    }
    return false;
  }
}
