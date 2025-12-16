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
    _loadMaintenance();
    super.initState();
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
    // Watch specific loading state
    final isLoading = ref.watch(maintenanceProvider).isLoading;
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Maintenance'),
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
                  suffix: IconButton(
                    onPressed: () async {
                      final date = await datePicker(_currentDate, context);
                      if (date != null) {
                        setState(() {
                          _currentDate = date;
                          _currentDateCtrl.text = _dateFormatter.format(date);
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                textFormField(
                  controller: _currentDist,
                  label: 'Current Service Distance (KM)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                // --- NEXT SERVICE ---
                textFormField(
                  controller: _nextDateCtrl,
                  label: 'Next Service Date',
                  readOnly: true,
                  suffix: IconButton(
                    onPressed: () async {
                      final date = await datePicker(_nextDate, context);
                      if (date != null) {
                        setState(() {
                          _nextDate = date;
                          _nextDateCtrl.text = _dateFormatter.format(date);
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                textFormField(
                  controller: _nextDist,
                  label: 'Next Service Distance (KM)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                textFormField(
                  controller: _remarks,
                  label: 'Remarks',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),

                // --- UPDATE BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // FIX 1: Disable button while loading
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            
                            FocusScope.of(context).unfocus(); // Close keyboard

                            final success = await maintenanceNotifier.updateMaintenance(
                              id: widget.maintenance.id,
                              title: _title.text.trim(),
                              // FIX 2: Pass description
                              description: _desc.text.trim().isEmpty 
                                  ? null 
                                  : _desc.text.trim(),
                              currentServDate: _currentDate,
                              currentServDistance: double.tryParse(_currentDist.text.trim()) ?? 0.0,
                              nextServDate: _nextDate,
                              nextServDistance: double.tryParse(_nextDist.text.trim()) ?? 0.0,
                              // FIX 3: Pass remarks
                              remarks: _remarks.text.trim().isEmpty 
                                  ? null 
                                  : _remarks.text.trim(),
                            );

                            if (!context.mounted) return;
                            
                            showAppSnackBar(
                              context: context,
                              content: success
                                  ? 'Maintenance record updated'
                                  : 'Failed to update maintenance record',
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
                        : const Text('Update Maintenance'),
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