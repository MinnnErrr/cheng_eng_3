
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

    if(user == null){
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final orderList = ref.watch(customerOrdersProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orderList.when(
        data: (orders) {
          // FIX 2: Add RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerOrdersProvider(user.id).future),
            child: orders.isEmpty
                // FIX 3: Empty state must be scrollable to allow Refresh
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      const Center(child: Text('No order found')),
                    ],
                  )
                : SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
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
                  ),
          );
        },
        // Error handling with Retry button
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CustomerProductScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
