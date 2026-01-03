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
    final theme = Theme.of(context);
    final bookingState = ref.watch(bookingStateProvider);
    final selectedServices = bookingState.services ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Select Services'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Choose one or more services for your vehicle",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // --- GRID ---
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // Square cards
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
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14),
                                  ),
                                  child: Image.asset(
                                    type.picture, // Ensure extension exists
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    type.name, // Ensure extension exists
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Checkmark Icon
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM BAR ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton(
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

            child: Text(
              selectedServices.isEmpty
                  ? "Select at least one service"
                  : "NEXT (${selectedServices.length} Selected)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
