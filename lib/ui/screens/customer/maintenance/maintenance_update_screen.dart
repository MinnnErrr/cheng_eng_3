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
    this.maintenanceId,
    this.vehicleId,
  });

  final String? maintenanceId;
  final String? vehicleId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaintenanceUpdateScreenState();
}

class _MaintenanceUpdateScreenState
    extends ConsumerState<MaintenanceUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy');
  bool _initialized = false;

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _currentDateCtrl = TextEditingController();
  final _currentDist = TextEditingController();
  final _nextDateCtrl = TextEditingController();
  final _nextDist = TextEditingController();
  final _remarks = TextEditingController();

  DateTime? _currentDate;
  DateTime? _nextDate;

  void _loadMaintenance(Maintenance maintenance) {
    _title.text = maintenance.title;
    _desc.text = maintenance.description ?? '';
    _currentDist.text = maintenance.currentServDistance.toString();
    _nextDist.text = maintenance.nextServDistance.toString();
    _remarks.text = maintenance.remarks ?? '';
    _currentDate = maintenance.currentServDate;
    _currentDateCtrl.text = _dateFormatter.format(maintenance.currentServDate);
    _nextDate = maintenance.nextServDate;
    _nextDateCtrl.text = _dateFormatter.format(maintenance.nextServDate);
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
    bool isLoading = ref.watch(maintenanceProvider).isLoading;
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    final maintenance = widget.maintenanceId != null
        ? ref.watch(maintenanceByIdProvider(widget.maintenanceId!)).value
        : null;

    if (maintenance != null && _initialized != true) {
      _initialized = true;
      _loadMaintenance(maintenance);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.maintenanceId == null
              ? 'Add Maintenance'
              : 'Update Maintenance',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
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
                          _currentDateCtrl.text = _dateFormatter.format(
                            date,
                          );
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                textFormField(
                  controller: _currentDist,
                  label: 'Current Service Distance (KM)',
                  keyboardType: TextInputType.numberWithOptions(),
                ),
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
                          _nextDateCtrl.text = _dateFormatter.format(
                            date,
                          );
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                textFormField(
                  controller: _nextDist,
                  label: 'Next Service Distance (KM)',
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                textFormField(
                  controller: _remarks,
                  label: 'Remarks',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    bool success;

                    if (maintenance == null) {
                      success = await maintenanceNotifier.addMaintenance(
                        title: _title.text.trim(),
                        currentServDate: _currentDate!,
                        currentServDistance: double.parse(
                          _currentDist.text.trim(),
                        ),
                        nextServDate: _nextDate!,
                        nextServDistance: double.parse(_nextDist.text.trim()),
                        vehicleId: widget.vehicleId!,
                      );
                    } else {
                      success = await maintenanceNotifier.updateMaintenance(
                        id: maintenance.id,
                        title: _title.text.trim(),
                        currentServDate: _currentDate!,
                        currentServDistance: double.parse(
                          _currentDist.text.trim(),
                        ),
                        nextServDate: _nextDate!,
                        nextServDistance: double.parse(_nextDist.text.trim()),
                      );
                    }

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: maintenance == null
                          ? success == true
                                ? 'Maintenance record added'
                                : 'Failed to add maintenance record'
                          : success == true
                          ? 'Maintenance record updated'
                          : 'Failed to update maintenance record',
                      isError: !success,
                    );

                    if (success == true) Navigator.of(context).pop();
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          widget.maintenanceId != null
                              ? 'Update Maintenance'
                              : 'Create Maintenance',
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
