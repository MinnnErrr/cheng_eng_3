import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/ui/screens/staff/booking/staff_booking_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/booking_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffBookingScreen extends ConsumerStatefulWidget {
  const StaffBookingScreen({super.key});

  @override
  ConsumerState<StaffBookingScreen> createState() => _StaffBookingScreenState();
}

class _StaffBookingScreenState extends ConsumerState<StaffBookingScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingRealTimeProvider);

    final bookingList = ref.watch(staffBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- 1. SEARCH BAR ---
            SearchBar(
              controller: _searchCtrl,
              hintText: "Search Plate No. (e.g., ABC1234)",

              leading: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
              trailing: _searchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = "");
                        },
                      ),
                    ]
                  : null,
            ),

            const SizedBox(height: 20),

            // --- 2. LIST CONTENT ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  return ref.refresh(staffBookingProvider.future);
                },
                child: bookingList.when(
                  data: (bookings) {
                    final filteredBookings = bookings.where((b) {
                      final q = _searchQuery.toLowerCase();
                      return b.vehicleRegNum.toLowerCase().contains(q) ||
                          b.vehicleModel.toLowerCase().contains(q);
                    }).toList();

                    if (filteredBookings.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: constraints.maxHeight,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 60,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'No booking record found'
                                          : 'No match for "$_searchQuery"',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredBookings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];

                        return BookingListitem(
                          booking: booking,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StaffBookingDetailsScreen(
                                booking: booking,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text('Error: ${error.toString()}'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
