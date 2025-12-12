import 'dart:io';

import 'package:cheng_eng_3/core/controllers/reward/staff_reward_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StaffRewardCreateScreen extends ConsumerStatefulWidget {
  const StaffRewardCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffRewardCreateState();
}

class _StaffRewardCreateState extends ConsumerState<StaffRewardCreateScreen> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _conditionCtrl = TextEditingController();
  final _pointCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _availableDateCtrl = TextEditingController();
  final _validityCtrl = TextEditingController();

  bool _limitedPeriod = false;
  DateTime? _availableUntil;
  bool _isActive = true;
  bool _hasValidity = false;
  final List<File> _photos = [];

  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _conditionCtrl.dispose();
    _pointCtrl.dispose();
    _qtyCtrl.dispose();
    _availableDateCtrl.dispose();
    _validityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifer = ref.read(staffRewardProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reward'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                textFormField(controller: _codeCtrl, label: 'Reward Code'),

                textFormField(controller: _nameCtrl, label: 'Name'),

                textFormField(controller: _pointCtrl, label: 'Points Required'),

                textFormField(
                  controller: _qtyCtrl,
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                ),

                DropdownButtonFormField<bool>(
                  initialValue: _limitedPeriod,
                  decoration: const InputDecoration(
                    labelText: "Display reward for limited period?",
                  ),
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Yes")),
                    DropdownMenuItem(value: false, child: Text("No")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _limitedPeriod = value;
                      });

                      if (value == false) {
                        setState(() {
                          _availableUntil == null;
                          _availableDateCtrl.text = '';
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    } else {
                      return null;
                    }
                  },
                ),

                if (_limitedPeriod)
                  textFormField(
                    controller: _availableDateCtrl,
                    label: 'Available Until',
                    readOnly: true,
                    suffix: IconButton(
                      onPressed: () async {
                        final date = await datePicker(DateTime.now(), context);
                        if (date != null) {
                          setState(() {
                            _availableUntil = date;
                            _availableDateCtrl.text = _dateFormatter.format(
                              date,
                            );
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                  ),

                DropdownButtonFormField<bool>(
                  initialValue: _hasValidity,
                  decoration: const InputDecoration(
                    labelText: "Set validity period for the reward?",
                  ),
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Yes")),
                    DropdownMenuItem(value: false, child: Text("No")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _hasValidity = value;
                      });

                      if (value == false) {
                        setState(() {
                          _validityCtrl.text = '';
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    } else {
                      return null;
                    }
                  },
                ),

                if (_hasValidity)
                  textFormField(
                    controller: _validityCtrl,
                    label: 'Validity Period (Weeks)',
                    keyboardType: TextInputType.number,
                  ),

                textFormField(
                  controller: _descCtrl,
                  label: 'Description',
                  minLines: 3,
                  maxLines: null,
                ),

                textFormField(
                  controller: _conditionCtrl,
                  label: 'Terms & Conditions',
                  validationRequired: false,
                  minLines: 3,
                  maxLines: null,
                ),

                _photoSection(),

                DropdownButtonFormField<bool>(
                  initialValue: _isActive,
                  decoration: const InputDecoration(
                    labelText: "Activate the reward now?",
                  ),
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Yes")),
                    DropdownMenuItem(value: false, child: Text("No")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isActive = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    } else {
                      return null;
                    }
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final message = await notifer.addReward(
                      rewardCode: _codeCtrl.text.trim(),
                      name: _nameCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      points: int.parse(_pointCtrl.text.trim()),
                      quantity: int.parse(_qtyCtrl.text.trim()),
                      status: _isActive,
                      photos: _photos,
                      conditions: _conditionCtrl.text.trim().isEmpty
                          ? null
                          : _conditionCtrl.text.trim(),
                      availableUntil: _availableUntil,
                      validityWeeks: _validityCtrl.text.trim().isEmpty
                          ? null
                          : int.parse(_validityCtrl.text.trim()),
                    );

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: message.message,
                      isError: !message.isSuccess,
                    );

                    if (message.isSuccess) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add Reward'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          children: [
            const Text(
              "Photos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: _pickPhoto,
              label: Text('Add'),
              icon: Icon(Icons.add_circle),
              style: ButtonStyle(iconAlignment: IconAlignment.end),
            ),
          ],
        ),

        // Photo Grid
        _photos.isEmpty
            ? Text('No photo added')
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final file = _photos[index];

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      //delete
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _photos.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ],
    );
  }
}
