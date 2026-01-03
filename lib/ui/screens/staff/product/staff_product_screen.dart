import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Product Inventory'),
      ),
      body: productsAsync.when(
        data: (products) {
          // 1. Extract Categories
          _filterCategories = products.map((p) => p.category).toSet().toList()
            ..sort();

          // 2. Filter List
          final filtered = productSearchSortFilter(
            products: products,
            search: _search,
            sorting: _sorting,
            category: _category,
            availability: _availability,
            isActive: _isActive,
          );

          // 3. Calc Stats
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
            return const Center(child: Text('No products found in database.'));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Column(
                children: [
                  // --- A. STATISTICS DASHBOARD ---
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: "No Stock",
                          value: outOfStock,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: "Ready Stock",
                          value: readyStock,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: _StatCard(
                          label: "Pre-order",
                          value: preorder,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  // --- B. SEARCH & FILTER ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBar(
                            hintText: "Search products...",
                            onChanged: (v) => setState(() => _search = v),

                            // 1. Icons
                            leading: const Icon(Icons.search),
                            // Optional: Add a clear button in the trailing list if text exists
                            trailing: _search.isNotEmpty
                                ? [
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        // If you have a controller, clear it here too
                                        setState(() => _search = "");
                                      },
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Filter Button
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onSecondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _openFilterSheet,
                            icon: const Icon(Icons.tune),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Sort Button
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onSecondaryContainer,
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
                  ),

                  // --- C. PRODUCT LIST ---
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                const Text('No products match your filters'),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (_, i) {
                              final p = filtered[i];
                              return StaffProductListitem(
                                product: p,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StaffProductDetailsScreen(product: p),
                                  ),
                                ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffProductCreateScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Add"), 
      ),
    );
  }

  // --- SUB-WIDGETS & SHEETS ---

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Filter Products",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: _filterCategories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setSheetState(() => _category = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProductAvailability>(
                    initialValue: _availability,
                    decoration: const InputDecoration(
                      labelText: "Availability",
                    ),
                    items: ProductAvailability.values
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.label)),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => _availability = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<bool>(
                    initialValue: _isActive,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Active")),
                      DropdownMenuItem(value: false, child: Text("Inactive")),
                    ],
                    onChanged: (v) => setSheetState(() => _isActive = v),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            onPressed: () {
                              resetFilters();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {}); // Trigger rebuild
                            Navigator.pop(context);
                          },
                          child: const Text("Apply Filters"),
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

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sort By",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
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

// --- STAT CARD WIDGET ---
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
