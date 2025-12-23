import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartEntry {
  final CartItem item;
  final Product? product;

  // Constructor
  const CartEntry({
    required this.item,
    required this.product,
  });

  // --- LOGIC (Previously in Extension) ---
  double get unitPrice => product?.price ?? 0.0;

  bool get hasInstallation =>
      product?.installation == true && item.installation == true;

  // Row Calculations
  double get priceTotal => unitPrice * item.quantity;

  double get installationTotal {
    if (hasInstallation && product?.installationFee != null) {
      return product!.installationFee! * item.quantity;
    }
    return 0.0;
  }

  double get rowTotal => priceTotal + installationTotal;

  // Validation
  bool get isProductExist {
    if (product == null) {
      return false;
    }
    return true;
  }

  bool get isSoldOut {
    if (product?.availability == ProductAvailability.ready &&
        (product?.quantity ?? 0) <= 0) {
      return true;
    }
    return false;
  }

  bool get isMaxStock {
    if (product?.availability == ProductAvailability.ready &&
        item.quantity >= (product?.quantity ?? 0)) {
      return true;
    }
    return false;
  }
}
