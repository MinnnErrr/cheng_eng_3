import 'package:cheng_eng_3/core/models/cart_entry_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_state_model.freezed.dart';

@freezed
sealed class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    @Default([]) List<CartEntry> entries,
  }) = _CartState;

  double get subtotal {
    if (entries.isEmpty) return 0.0;
    return entries.fold(0, (sum, entry) => sum + entry.rowTotal);
  }

  bool get isValid {
    if (entries.isEmpty) return false;
    // Returns false if ANY entry has an issue
    return entries.every((e) => e.isProductExist && !e.isSoldOut);
  }

  int get itemCount {
    return entries.length;
  }
}
