import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/core/enums/sorting_enum.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/customer_product_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerProductScreen extends ConsumerStatefulWidget {
  const CustomerProductScreen({super.key});

  @override
  ConsumerState<CustomerProductScreen> createState() {
    return _CustomerProductScreenState();
  }
}

class _CustomerProductScreenState extends ConsumerState<CustomerProductScreen> {
  String _search = "";
  ProductSorting _sorting = ProductSorting.newest;
  String? _category;
  ProductAvailability? _availability;
  List<String> _categories = [];

  void resetFilters() {
    setState(() {
      _search = "";
      _sorting = ProductSorting.newest;
      _category = null;
      _availability = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(customerProductProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: productState.when(
        data: (products) {
          final filtered = productSearchSortFilter(
            products: products,
            search: _search,
            sorting: _sorting,
            category: _category,
            availability: _availability,
            isActive: null,
          );

          _categories =
              products
                  .map((p) => p.category)
                  .toSet() // remove duplicates
                  .toList()
                ..sort();

          if (products.isEmpty) {
            return const Center(
              child: Text('No product found'),
            );
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SearchFilterSortHeader(
                    search: _search,
                    onSearchChanged: (v) => setState(() => _search = v),
                    onFilterPressed: _openFilterSheet,
                    onSortPressed: _openSortSheet,
                  ),
                ),

                filtered.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              'No product found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.6,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = filtered[index];

                              return InkWell(
                                onTap:
                                    (product.quantity != null &&
                                        product.quantity! <= 0)
                                    ? null
                                    : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CustomerProductDetailsScreen(
                                                productId: product.id,
                                              ),
                                        ),
                                      ),
                                child: CustomerProductListitem(
                                  product: product,
                                ),
                              );
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  //filter
  void _openFilterSheet() {
    final tempCategory = _category;
    final tempAvailability = _availability;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? sheetCategory = tempCategory;
        ProductAvailability? sheetAvailability = tempAvailability;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filter Products",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _categories.contains(sheetCategory)
                    ? sheetCategory
                    : null,
                decoration: const InputDecoration(labelText: "Category"),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  sheetCategory = v;
                },
              ),
              const SizedBox(height: 12),

              // AVAILABILITY
              DropdownButtonFormField<ProductAvailability>(
                initialValue: sheetAvailability,
                decoration: const InputDecoration(labelText: "Availability"),
                items: ProductAvailability.values
                    .map(
                      (availability) => DropdownMenuItem(
                        value: availability,
                        child: Text(availability.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  sheetAvailability = v;
                },
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        resetFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // apply selected filters
                        setState(() {
                          _category = sheetCategory;
                          _availability = sheetAvailability;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort By",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              RadioGroup<ProductSorting>(
                groupValue: _sorting,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sorting = value;
                    });
                  }

                  Navigator.pop(context);
                },
                child: Column(
                  children: ProductSorting.values.map((sorting) {
                    return RadioListTile<ProductSorting>(
                      title: Text(sorting.title),
                      value: sorting,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchFilterSortHeader extends SliverPersistentHeaderDelegate {
  final String search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;

  _SearchFilterSortHeader({
    required this.search,
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.onSortPressed,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onFilterPressed,
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: onSortPressed, icon: const Icon(Icons.sort)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
