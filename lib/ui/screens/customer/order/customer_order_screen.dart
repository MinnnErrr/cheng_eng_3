import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/ui/screens/customer/order/customer_order_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/widgets/order_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerOrderScreen extends ConsumerWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final orderList = ref.watch(customerOrdersProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orderList.when(
        data: (orders) {
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerOrdersProvider(user.id).future),
            child: orders.isEmpty
                // ✅ FIX: Better Empty State Layout
                ? LayoutBuilder(
                    builder: (context, constraints) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height:
                              constraints.maxHeight *
                              0.8, // Centered vertically
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No orders found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderListitem(
                        isStaff: false,
                        order: order,
                        tapAction: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerOrderDetailsScreen(
                              order: order,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.refresh(customerOrdersProvider(user.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CustomerProductScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
