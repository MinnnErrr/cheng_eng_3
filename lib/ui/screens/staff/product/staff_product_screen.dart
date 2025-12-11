import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/enums/sorting_enum.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/screens/staff/product/staff_product_create_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/product/staff_product_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/staff_product_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffProductScreen extends ConsumerStatefulWidget {
  const StaffProductScreen({super.key});

  @override
  ConsumerState<StaffProductScreen> createState() => _StaffProductScreenState();
}

class _StaffProductScreenState extends ConsumerState<StaffProductScreen> {
  String _search = "";
  ProductSorting _sorting = ProductSorting.newest;
  String? _category;
  ProductAvailability? _availability;
  bool? _isActive;
  List<String> _filterCategories = [];

  void resetFilters() {
    setState(() {
      _search = "";
      _sorting = ProductSorting.newest;
      _category = null;
      _availability = null;
      _isActive = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(staffProductProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) {
          _filterCategories = products.map((p) => p.category).toSet().toList()
            ..sort();

          final filtered = productSearchSortFilter(
            products: products,
            search: _search,
            sorting: _sorting,
            category: _category,
            availability: _availability,
            isActive: _isActive,
          );

          //statistics
          final outOfStock = products
              .where(
                (p) =>
                    p.availability == ProductAvailability.ready &&
                    (p.quantity ?? 0) <= 0,
              )
              .length;
          final readyStock = products
              .where(
                (p) =>
                    p.availability == ProductAvailability.ready &&
                    (p.quantity ?? 0) > 0,
              )
              .length;
          final preorder = products
              .where((p) => p.availability == ProductAvailability.preorder)
              .length;

          if (products.isEmpty) {
            return const Center(child: Text('No product found'));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // use SizedBox for spacing instead of a custom spacing param
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // statistics row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: _statBox(
                          context: context,
                          label: 'Out of Stock',
                          value: outOfStock,
                          light: Theme.of(context).colorScheme.errorContainer,
                          dark: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      Expanded(
                        child: _statBox(
                          context: context,
                          label: 'Ready Stock',
                          value: readyStock,
                          light: Theme.of(context).colorScheme.primaryContainer,
                          dark: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Expanded(
                        child: _statBox(
                          context: context,
                          label: 'Preorder',
                          value: preorder,
                          light: Theme.of(context).colorScheme.primaryContainer,
                          dark: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // search / filter / sort row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _search = v),
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
                        onPressed: () => _openFilterSheet(),
                        icon: const Icon(Icons.filter_alt_outlined),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _openSortSheet(),
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // product list
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text('No product found'),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final p = filtered[i];
                              return InkWell(
                                child: StaffProductListitem(product: p),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StaffProductDetailsScreen(
                                          productId: p.id,
                                        ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, i) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffProductCreateScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  //statistics
  Widget _statBox({
    required BuildContext context,
    required String label,
    required int value,
    required Color light,
    required Color dark,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: dark)),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  //filter
  void _openFilterSheet() {
    final tempCategory = _category;
    final tempAvailability = _availability;
    final tempIsActive = _isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? sheetCategory = tempCategory;
        ProductAvailability? sheetAvailability = tempAvailability;
        bool? sheetIsActive = tempIsActive;

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
                initialValue: _filterCategories.contains(sheetCategory)
                    ? sheetCategory
                    : null,
                decoration: const InputDecoration(labelText: "Category"),
                items: _filterCategories
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
              const SizedBox(height: 12),

              // STATUS
              DropdownButtonFormField<bool>(
                initialValue: sheetIsActive,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: true, child: Text("Active")),
                  DropdownMenuItem(value: false, child: Text("Inactive")),
                ],
                onChanged: (v) {
                  sheetIsActive = v;
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
                          _isActive = sheetIsActive;
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
