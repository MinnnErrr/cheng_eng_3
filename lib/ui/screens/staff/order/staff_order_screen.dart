import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/ui/screens/staff/order/staff_order_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/order_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffOrderScreen extends ConsumerWidget {
  const StaffOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderList = ref.watch(staffOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
      ),
      body: orderList.when(
        data: (orders) {
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(staffOrdersProvider.future),
            child: orders.isEmpty
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
                          isStaff: true,
                          order: order,
                          tapAction: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StaffOrderDetailsScreen(
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
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
