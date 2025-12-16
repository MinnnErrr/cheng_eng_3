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
      appBar: AppBar(
        title: const Text('Products'),
      ),
      // NO CustomScrollView needed. Just a Column.
      body: Column(
        children: [
          // 1. FIXED HEADER (Search & Filter)
          // This stays at the top and never scrolls.
          _buildSearchHeader(),

          // 2. SCROLLABLE CONTENT
          // Expanded takes the rest of the screen space.
          Expanded(
            child: productState.when(
              data: (products) {
                if (products.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(customerProductProvider.future),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(child: Text('No products available')),
                      ],
                    ),
                  );
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
                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(customerProductProvider.future),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(child: Text('No product found')),
                      ],
                    ),
                  );
                }

                // Standard GridView inside RefreshIndicator
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(customerProductProvider.future),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final isSoldOut =
                          product.quantity != null && product.quantity! <= 0;

                      return InkWell(
                        onTap: isSoldOut
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CustomerProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              ),
                        child: Opacity(
                          opacity: isSoldOut ? 0.6 : 1.0,
                          child: CustomerProductListitem(
                            product: product,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  // Extracted Header Widget (No SliverDelegate needed!)
  Widget _buildSearchHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: "Search name...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _openSortSheet,
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
    );
  }

  // ... (Keep _openFilterSheet and _openSortSheet exactly as before) ...
  // --- FILTER SHEET ---
  void _openFilterSheet() {
    String? sheetCategory = _category;
    ProductAvailability? sheetAvailability = _availability;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                children: [
                  Text(
                    "Filter Products",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                    onChanged: (v) => setSheetState(() => sheetCategory = v),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<ProductAvailability>(
                    initialValue: sheetAvailability,
                    decoration: const InputDecoration(
                      labelText: "Availability",
                    ),
                    items: ProductAvailability.values
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.label)),
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
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
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
                  const SizedBox(height: 16),
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
