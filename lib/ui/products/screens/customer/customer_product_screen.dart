import 'package:cheng_eng_3/ui/products/notifiers/customer_product_notifier.dart';
import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/ui/products/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/products/screens/customer/customer_product_details_screen.dart';
import 'package:cheng_eng_3/ui/products/widgets/customer_product_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerProductScreen extends ConsumerStatefulWidget {
  const CustomerProductScreen({super.key});

  @override
  ConsumerState<CustomerProductScreen> createState() =>
      _CustomerProductScreenState();
}

class _CustomerProductScreenState extends ConsumerState<CustomerProductScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String _search = "";
  ProductSorting _sorting = ProductSorting.newest;
  String? _category;
  ProductAvailability? _availability;
  List<String> _categories = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void resetFilters() {
    setState(() {
      _search = "";
      _searchCtrl.clear();
      _sorting = ProductSorting.newest;
      _category = null;
      _availability = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(customerProductProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          // 1. FIXED HEADER
          _buildSearchHeader(),

          // 2. SCROLLABLE CONTENT
          Expanded(
            child: productState.when(
              data: (products) {
                if (products.isEmpty) {
                  return _buildEmptyState('No products available');
                }

                final filtered = productSearchSortFilter(
                  products: products,
                  search: _search,
                  sorting: _sorting,
                  category: _category,
                  availability: _availability,
                  isActive: null,
                );

                _categories = products.map((p) => p.category).toSet().toList()
                  ..sort();

                if (filtered.isEmpty) {
                  return _buildEmptyState('No product found');
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(customerProductProvider.future),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7, 
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final isSoldOut =
                          product.quantity != null && product.quantity! <= 0;
                      return CustomerProductListitem(
                        product: product,
                        onTap: isSoldOut
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CustomerProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(customerProductProvider.future),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text(message, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: SearchBar(
              controller: _searchCtrl,
              hintText: "Search products...",
              onChanged: (v) => setState(() => _search = v),
              leading: const Icon(Icons.search),
              trailing: [
                if (_search.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _search = "");
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          SizedBox(
            height: 50, 
            width: 50,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _openFilterSheet,
              icon: const Icon(
                Icons.tune,
              ), 
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            height: 50,
            width: 50,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _openSortSheet,
              icon: const Icon(Icons.sort),
            ),
          ),
        ],
      ),
    );
  }

  // --- FILTER SHEET ---
  void _openFilterSheet() {
    String? sheetCategory = _category;
    ProductAvailability? sheetAvailability = _availability;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Products",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: _categories.contains(sheetCategory)
                        ? sheetCategory
                        : null,
                    decoration: InputDecoration(
                      labelText: "Category",
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setSheetState(() => sheetCategory = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProductAvailability>(
                    initialValue: sheetAvailability,
                    decoration: InputDecoration(
                      labelText: "Availability",
                    ),
                    items: ProductAvailability.values
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.dropDownOption)),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setSheetState(() => sheetAvailability = v),
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
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- SORT SHEET ---
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
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
