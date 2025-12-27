import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/services/notification_service.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceCreateScreen extends ConsumerStatefulWidget {
  const MaintenanceCreateScreen({
    super.key,
    required this.vehicleId, // FIX 1: Make this required to prevent crashes
  });

  final String vehicleId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaintenanceCreateScreenState();
}

class _MaintenanceCreateScreenState
    extends ConsumerState<MaintenanceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy');

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _currentDateCtrl = TextEditingController();
  final _currentDist = TextEditingController();
  final _nextDateCtrl = TextEditingController();
  final _nextDist = TextEditingController();
  final _remarks = TextEditingController();

  DateTime? _currentDate;
  DateTime? _nextDate;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _currentDateCtrl.dispose();
    _currentDist.dispose();
    _nextDateCtrl.dispose();
    _nextDist.dispose();
    _remarks.dispose();
    super.dispose();
  }

  void _requestPermission() async {
    final notificationService = ref.read(notificationServiceProvider);

    // 1. Call the Service
    final bool granted = await notificationService.requestPermission();

    if (!granted) {
      // 2. Handle the Rejection (Show Dialog)
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "We need notification permissions to remind you about maintenance service.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // User gives up
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                notificationService.openSettings(); // 👈 Redirect to Settings
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the specific AsyncValue to determine loading state
    final maintenanceState = ref.watch(maintenanceProvider);
    final isLoading = maintenanceState.isLoading;

    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Maintenance'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20, // Requires Flutter 3.27+
              children: [
                textFormField(
                  controller: _title,
                  label: 'Title',
                ),
                textFormField(
                  controller: _desc,
                  label: 'Description',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),

                // --- CURRENT SERVICE ---
                textFormField(
                  controller: _currentDateCtrl,
                  label: 'Current Service Date',
                  readOnly: true,
                  onTap: () async {
                    final date = await datePicker(_currentDate, context);
                    if (date != null) {
                      setState(() {
                        _currentDate = date;
                        _currentDateCtrl.text = _dateFormatter.format(date);
                      });
                    }
                  },
                  suffix: const Icon(Icons.calendar_month),
                ),
                textFormField(
                  controller: _currentDist,
                  label: 'Current Service Distance (KM)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),

                // --- NEXT SERVICE ---
                textFormField(
                  controller: _nextDateCtrl,
                  label: 'Next Service Date',
                  readOnly: true,
                  onTap: () async {
                    final date = await datePicker(_nextDate, context);
                    if (date != null) {
                      setState(() {
                        _nextDate = date;
                        _nextDateCtrl.text = _dateFormatter.format(date);
                      });
                    }
                  },
                  suffix: const Icon(Icons.calendar_month),
                ),
                textFormField(
                  controller: _nextDist,
                  label: 'Next Service Distance (KM)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),

                textFormField(
                  controller: _remarks,
                  label: 'Remarks',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),

                // --- SUBMIT BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // FIX 2: Disable button logic entirely when loading to prevent double-taps
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            _requestPermission();

                            if (_currentDate == null || _nextDate == null) {
                              showAppSnackBar(
                                context: context,
                                content: 'Please select service dates',
                                isError: true,
                              );
                              return;
                            }

                            // Close keyboard
                            FocusScope.of(context).unfocus();

                            final success = await maintenanceNotifier
                                .addMaintenance(
                                  title: _title.text.trim(),
                                  // FIX 3: Added missing description parameter
                                  description: _desc.text.trim().isEmpty
                                      ? null
                                      : _desc.text.trim(),
                                  currentServDate: _currentDate!,
                                  // Safer parsing
                                  currentServDistance:
                                      double.tryParse(
                                        _currentDist.text.trim(),
                                      ) ??
                                      0.0,
                                  nextServDate: _nextDate!,
                                  nextServDistance:
                                      double.tryParse(_nextDist.text.trim()) ??
                                      0.0,
                                  remarks: _remarks.text.trim().isEmpty
                                      ? null
                                      : _remarks.text.trim(),
                                  vehicleId:
                                      widget.vehicleId, // No ! needed anymore
                                );

                            if (!context.mounted) return;

                            showAppSnackBar(
                              context: context,
                              content: success
                                  ? 'Maintenance record added'
                                  : 'Failed to add maintenance record',
                              isError: !success,
                            );

                            if (success) Navigator.of(context).pop();
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Create Maintenance'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
