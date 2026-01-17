import 'package:cheng_eng_3/ui/maintenances/notifiers/maintenance_notifier.dart';
import 'package:cheng_eng_3/data/services/notification_service.dart';
import 'package:cheng_eng_3/utils/datepicker.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/custom_text_field.dart';
import 'package:cheng_eng_3/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceCreateScreen extends ConsumerStatefulWidget {
  const MaintenanceCreateScreen({
    super.key,
    required this.vehicleId,
  });

  final String vehicleId;

  @override
  ConsumerState<MaintenanceCreateScreen> createState() =>
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
    final bool granted = await notificationService.requestPermission();

    if (!granted && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "We need notification permissions to remind you about maintenance service.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                notificationService.openSettings();
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
    final maintenanceState = ref.watch(maintenanceProvider);
    final isLoading = maintenanceState.isLoading;
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      backgroundColor:
          theme.colorScheme.surface, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SECTION 1: BASIC INFO ---
                _buildSectionHeader("Service Details", theme),
                Column(
                  children: [
                    Customtextfield(
                      controller: _title,
                      label: 'Service Title (e.g. Oil Change)',
                      textCapitalization: TextCapitalization.sentences,
                      prefixIcon: const Icon(Icons.build_circle_outlined),
                      validator: Validators.maxLength(50),
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      controller: _desc,
                      label: 'Description',
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      isRequired: false,
                      textCapitalization: TextCapitalization.sentences,
                      validator: Validators.maxLength(200),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // --- SECTION 2: CURRENT STATUS ---
                _buildSectionHeader("Current Service", theme),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Customtextfield(
                        controller: _currentDateCtrl,
                        label: 'Date Done',
                        readOnly: true,
                        suffix: const Icon(Icons.calendar_today, size: 20),
                        onTap: () async {
                          final date = await datePicker(
                            _currentDate,
                            context,
                          );
                          if (date != null) {
                            setState(() {
                              _currentDate = date;
                              _currentDateCtrl.text = _dateFormatter.format(
                                date,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Customtextfield(
                        controller: _currentDist,
                        label: 'Mileage',
                        suffix: Text('km'), 
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        isRequired: false,
                        validator: Validators.isFloat
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // --- SECTION 3: NEXT SERVICE ---
                _buildSectionHeader("Next Service", theme),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Customtextfield(
                        controller: _nextDateCtrl,
                        label: 'Due Date',
                        readOnly: true,
                        suffix: const Icon(Icons.event, size: 20),
                        onTap: () async {
                          final initialDate = _currentDate ?? DateTime.now();
                          final date = await datePicker(
                            _nextDate ?? initialDate,
                            context,
                          );
                          if (date != null) {
                            setState(() {
                              _nextDate = date;
                              _nextDateCtrl.text = _dateFormatter.format(
                                date,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Customtextfield(
                        controller: _nextDist,
                        label: 'Due Mileage',
                        suffix: Text('km'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        isRequired: false,
                        validator: Validators.isFloat,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // --- REMARKS ---
                Customtextfield(
                  controller: _remarks,
                  label: 'Remarks / Notes',
                  minLines: 2,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  isRequired: false,
                  textCapitalization: TextCapitalization.sentences,
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  validator: Validators.maxLength(200),
                ),

                const SizedBox(height: 30),

                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          _requestPermission();

                          if (_currentDate == null || _nextDate == null) {
                            showAppSnackBar(
                              context: context,
                              content: 'Please select both service dates',
                              isError: true,
                            );
                            return;
                          }

                          FocusScope.of(context).unfocus();

                          final success = await maintenanceNotifier
                              .addMaintenance(
                                title: _title.text.trim(),
                                description: _desc.text.trim().isEmpty
                                    ? null
                                    : _desc.text.trim(),
                                currentServDate: _currentDate!,
                                currentServDistance:
                                    _currentDist.text.trim().isNotEmpty
                                    ? double.tryParse(_currentDist.text.trim())
                                    : null,
                                nextServDate: _nextDate!,
                                nextServDistance:
                                    _nextDist.text.trim().isNotEmpty
                                    ? double.tryParse(_nextDist.text.trim())
                                    : null,
                                remarks: _remarks.text.trim().isEmpty
                                    ? null
                                    : _remarks.text.trim(),
                                vehicleId: widget.vehicleId,
                              );

                          if (!context.mounted) return;

                          if (success) {
                            showAppSnackBar(
                              context: context,
                              content: 'Maintenance record added successfully',
                              isError: false,
                            );
                            Navigator.of(context).pop();
                          } else {
                            showAppSnackBar(
                              context: context,
                              content: 'Failed to add maintenance record',
                              isError: true,
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'SAVE RECORD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
