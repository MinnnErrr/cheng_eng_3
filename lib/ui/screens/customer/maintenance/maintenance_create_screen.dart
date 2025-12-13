import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceCreateScreen extends ConsumerStatefulWidget {
  const MaintenanceCreateScreen({
    super.key,
    this.vehicleId,
  });

  final String? vehicleId;

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

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(maintenanceProvider).isLoading;
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Maintenance'),
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

                    if (_currentDate == null || _nextDate == null) {
                      showAppSnackBar(
                        context: context,
                        content: 'Please select service dates',
                        isError: true,
                      );
                      return;
                    }

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

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: success == true
                          ? 'Maintenance record added'
                          : 'Failed to add maintenance record',
                      isError: !success,
                    );

                    if (success == true) Navigator.of(context).pop();
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'Create Maintenance',
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
