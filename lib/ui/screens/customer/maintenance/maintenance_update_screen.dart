import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceUpdateScreen extends ConsumerStatefulWidget {
  const MaintenanceUpdateScreen({
    super.key,
    required this.maintenance,
  });

  final Maintenance maintenance;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaintenanceUpdateScreenState();
}

class _MaintenanceUpdateScreenState
    extends ConsumerState<MaintenanceUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy');

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _currentDateCtrl = TextEditingController();
  final _currentDist = TextEditingController();
  final _nextDateCtrl = TextEditingController();
  final _nextDist = TextEditingController();
  final _remarks = TextEditingController();

  late DateTime _currentDate;
  late DateTime _nextDate;

  @override
  void initState() {
    super.initState();
    _loadMaintenance();
  }

  void _loadMaintenance() {
    _title.text = widget.maintenance.title;
    _desc.text = widget.maintenance.description ?? '';
    _currentDist.text = widget.maintenance.currentServDistance.toString();
    _nextDist.text = widget.maintenance.nextServDistance.toString();
    _remarks.text = widget.maintenance.remarks ?? '';

    _currentDate = widget.maintenance.currentServDate;
    _currentDateCtrl.text = _dateFormatter.format(
      widget.maintenance.currentServDate,
    );

    _nextDate = widget.maintenance.nextServDate;
    _nextDateCtrl.text = _dateFormatter.format(widget.maintenance.nextServDate);
  }

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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(maintenanceProvider).isLoading;
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Update Maintenance')),
      backgroundColor: theme.colorScheme.surface,
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
                    textFormField(
                      controller: _title,
                      label: 'Service Title',
                      textCapitalization: TextCapitalization.sentences,
                      prefixIcon: const Icon(Icons.build_circle_outlined),
                    ),
                    const SizedBox(height: 16),
                    textFormField(
                      controller: _desc,
                      label: 'Description',
                      maxLines: 3,
                      validationRequired: false,
                      textCapitalization: TextCapitalization.sentences,
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
                      child: textFormField(
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
                      child: textFormField(
                        controller: _currentDist,
                        label: 'Mileage',
                        suffix: Text('km'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // --- SECTION 3: NEXT SERVICE (Highlight) ---
                _buildSectionHeader("Next Service Requirement", theme),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textFormField(
                        controller: _nextDateCtrl,
                        label: 'Due Date',
                        readOnly: true,
                        suffix: const Icon(Icons.event, size: 20),
                        onTap: () async {
                          final date = await datePicker(_nextDate, context);
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
                      child: textFormField(
                        controller: _nextDist,
                        label: 'Due Mileage',
                        suffix: Text('km'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // --- REMARKS ---
                textFormField(
                  controller: _remarks,
                  label: 'Remarks / Notes',
                  maxLines: 3,
                  validationRequired: false,
                  textCapitalization: TextCapitalization.sentences,
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                ),

                const SizedBox(height: 30),

                // --- UPDATE BUTTON ---
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          FocusScope.of(context).unfocus();

                          final success = await maintenanceNotifier
                              .updateMaintenance(
                                id: widget.maintenance.id,
                                title: _title.text.trim(),
                                description: _desc.text.trim().isEmpty
                                    ? null
                                    : _desc.text.trim(),
                                currentServDate: _currentDate,
                                currentServDistance:
                                    double.tryParse(
                                      _currentDist.text.trim(),
                                    ) ??
                                    0.0,
                                nextServDate: _nextDate,
                                nextServDistance:
                                    double.tryParse(_nextDist.text.trim()) ??
                                    0.0,
                                remarks: _remarks.text.trim().isEmpty
                                    ? null
                                    : _remarks.text.trim(),
                              );

                          if (!context.mounted) return;

                          if (success) {
                            showAppSnackBar(
                              context: context,
                              content: 'Maintenance record updated',
                              isError: false,
                            );
                            Navigator.of(context).pop();
                          } else {
                            showAppSnackBar(
                              context: context,
                              content: 'Failed to update maintenance record',
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
                          'Update Record',
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
