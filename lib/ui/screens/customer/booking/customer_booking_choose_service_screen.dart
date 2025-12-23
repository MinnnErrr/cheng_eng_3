import 'package:cheng_eng_3/core/controllers/booking/booking_state_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_choose_datetime_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingChooseServiceScreen extends ConsumerStatefulWidget {
  const CustomerBookingChooseServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBookingChooseServiceScreenState();
}

class _CustomerBookingChooseServiceScreenState
    extends ConsumerState<CustomerBookingChooseServiceScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Watch the state
    final bookingState = ref.watch(bookingStateProvider);
    final selectedServices = bookingState.services ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Services'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Select one or more services",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: BookingServiceType.values.length,
                itemBuilder: (context, index) {
                  final type = BookingServiceType.values[index];
                  final isSelected = selectedServices.contains(type);

                  return InkWell(
                    onTap: () {
                      ref
                          .read(bookingStateProvider.notifier)
                          .selectService(type);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      // ClipRRect ensures the image doesn't spill out of the rounded corners
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .stretch, // 1. Stretch width
                              children: [
                                // 2. Image takes up most of the space (e.g., 75%)
                                Expanded(
                                  flex: 3,
                                  child: Image.asset(
                                    type.picture,
                                    fit: BoxFit
                                        .cover, // 3. Cover fills the space without distortion
                                    // Remove width: 80 and height: 80
                                  ),
                                ),
                                // 4. Text takes up the bottom area (e.g., 25%)
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : Colors
                                              .transparent, // Optional: background for text
                                    alignment: Alignment.center,
                                    child: Text(
                                      type.name,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Checkmark Overlay
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // 4. VALIDATION BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          // 5. THE LOGIC: If list is empty, return null (Disables button)
          onPressed: selectedServices.isEmpty
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CustomerBookingChooseDatetimeScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            selectedServices.isEmpty
                ? "Select a Service"
                : "Next (${selectedServices.length})",
          ),
        ),
      ),
    );
  }
}
