import 'package:cheng_eng_3/core/enums/sorting_enum.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';

List<Product> productSearchSortFilter({
  required List<Product> products,
  required String search,
  required ProductSorting sorting,
  String? category,
  ProductAvailability? availability,
  bool? isActive, //only for staff
}) {
  var list = products;

  // SEARCH
  if (search.trim().isNotEmpty) {
    final s = search.trim().toLowerCase();
    list = list.where((p) => p.name.toLowerCase().contains(s)).toList();
  }

  // CATEGORY
  if (category != null && category.isNotEmpty) {
    list = list.where((p) => p.category == category).toList();
  }

  // AVAILABILITY
  if (availability != null) {
    list = list.where((p) => p.availability == availability).toList();
  }

  // STATUS
  if (isActive != null) {
    list = list.where((p) => p.status == isActive).toList();
  }

  // SORT
  switch (sorting) {
    case ProductSorting.newest:
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case ProductSorting.oldest:
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case ProductSorting.highestPrice:
      list.sort((a, b) => b.price.compareTo(a.price));
      break;
    case ProductSorting.lowestPrice:
      list.sort((a, b) => a.price.compareTo(b.price));
      break;
  }

  return list;
}



List<RedeemedReward> searchRedeemedReward({
  required List<RedeemedReward> rewards,
  required String search,
}) {
  var list = rewards;

  if (search.trim().isNotEmpty) {
    final s = search.trim().toLowerCase();
    list = list.where((r) => r.code.toLowerCase().contains(s)).toList();
  }

  return list;
}
