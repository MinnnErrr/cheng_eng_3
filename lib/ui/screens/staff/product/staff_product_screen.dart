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
          // Extract unique categories
          _filterCategories = products.map((p) => p.category).toSet().toList()
            ..sort();

          // Filter the list
          final filtered = productSearchSortFilter(
            products: products,
            search: _search,
            sorting: _sorting,
            category: _category,
            availability: _availability,
            isActive: _isActive,
          );

          // --- Statistics Calculation ---
          int outOfStock = 0;
          int readyStock = 0;
          int preorder = 0;

          for (var p in products) {
            if (p.availability == ProductAvailability.preorder) {
              preorder++;
            } else if (p.availability == ProductAvailability.ready) {
              if ((p.quantity ?? 0) > 0) {
                readyStock++;
              } else {
                outOfStock++;
              }
            }
          }

          if (products.isEmpty) {
            return const Center(child: Text('No product found'));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Statistics Row ---
                  Row(
                    // 'spacing' property in Row is available in Flutter 3.27+.
                    // If using older version, remove this line and use SizedBox between children.
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
                          light: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          dark: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Search & Action Bar ---
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _search = v),
                          decoration: InputDecoration(
                            hintText: "Search name...",
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: () => _openFilterSheet(),
                        icon: const Icon(Icons.filter_alt_outlined),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: () => _openSortSheet(),
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Product List ---
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text('No product found based on filters'),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final p = filtered[i];
                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StaffProductDetailsScreen(product: p),
                                  ),
                                ),
                                child: StaffProductListitem(product: p),
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

  // Statistics Widget
  Widget _statBox({
    required BuildContext context,
    required String label,
    required int value,
    required Color light,
    required Color dark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: dark, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  // Filter Sheet
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Use StatefulBuilder to update local sheet state (dropdowns)
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Filter Products",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Category
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items: _filterCategories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setSheetState(() => _category = v),
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  DropdownButtonFormField<ProductAvailability>(
                    initialValue: _availability,
                    decoration: const InputDecoration(
                      labelText: "Availability",
                      border: OutlineInputBorder(),
                    ),
                    items: ProductAvailability.values
                        .map(
                          (a) => DropdownMenuItem(
                            value: a,
                            child: Text(
                              a.label,
                            ), // Assuming enum extension or property
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => _availability = v),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<bool>(
                    initialValue: _isActive,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Active")),
                      DropdownMenuItem(value: false, child: Text("Inactive")),
                    ],
                    onChanged: (v) => setSheetState(() => _isActive = v),
                  ),
                  const SizedBox(height: 30),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            resetFilters(); // Resets parent state
                            Navigator.pop(context);
                          },
                          child: const Text("Reset Filters"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              // Variables are already updated via setSheetState
                              // triggering parent rebuild
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

  // Sort Sheet - FIXED
  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sort By",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              // Correct Implementation using RadioListTile directly
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
