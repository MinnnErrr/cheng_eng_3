import 'dart:io';

import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
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
  // Controllers
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _conditionCtrl = TextEditingController();
  final _pointCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _availableDateCtrl = TextEditingController();
  final _validityCtrl = TextEditingController();

  // State Variables
  bool _limitedPeriod = false;
  DateTime? _availableUntil;
  bool _isActive = true;
  bool _hasValidity = false;
  bool _isLoading = false; // Added loading state
  final List<File> _photos = [];

  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    // Added maxWidth/Height to optimize performance and upload speed
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024, 
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  // Helper method to pick date to avoid code duplication
  Future<void> _handleDateSelection() async {
    final date = await datePicker(DateTime.now(), context);
    if (date != null) {
      setState(() {
        _availableUntil = date;
        _availableDateCtrl.text = _dateFormatter.format(date);
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
    // You can also watch the provider state to see if it is loading globally
    // final state = ref.watch(staffRewardsProvider); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reward'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              // spacing: 20 is valid in newer Flutter versions. 
              // If using older versions, use SizedBox(height: 20) between widgets.
              spacing: 20, 
              children: [
                textFormField(controller: _codeCtrl, label: 'Reward Code'),

                textFormField(controller: _nameCtrl, label: 'Name'),

                textFormField(
                  controller: _pointCtrl, 
                  label: 'Points Required',
                  keyboardType: TextInputType.number, // Ensure numeric keyboard
                ),

                textFormField(
                  controller: _qtyCtrl,
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                ),

                DropdownButtonFormField<bool>(
                  initialValue: _limitedPeriod, // changed from initialValue to value for better state syncing
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
                        if (!value) {
                          _availableUntil = null;
                          _availableDateCtrl.clear();
                        }
                      });
                    }
                  },
                ),

                if (_limitedPeriod)
                  textFormField(
                    controller: _availableDateCtrl,
                    label: 'Available Until',
                    readOnly: true,
                    // UX: Allow tapping the whole field, not just the icon
                    onTap: _handleDateSelection, 
                    suffix: IconButton(
                      onPressed: _handleDateSelection,
                      icon: const Icon(Icons.calendar_month),
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
                        if (!value) {
                          _validityCtrl.clear();
                        }
                      });
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
                    if (value != null) setState(() => _isActive = value);
                  },
                ),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading 
                      ? const CircularProgressIndicator.adaptive() 
                      : const Text('Add Reward'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // 1. Basic Form Validation (checks for empty fields based on your validators)
    if (!_formKey.currentState!.validate()) return;

    // 2. Set Loading State
    setState(() => _isLoading = true);

    // 3. Prepare Data (Safe Parsing)
    // We do this in the UI to ensure we send valid types to the Notifier
    final points = int.tryParse(_pointCtrl.text.trim()) ?? 0;
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    
    // Logic for conditional validity
    final int? validityWeeks = _hasValidity && _validityCtrl.text.isNotEmpty
        ? int.tryParse(_validityCtrl.text.trim())
        : null;

    // Logic for conditional date
    final DateTime? availableDate = _limitedPeriod 
        ? _availableUntil 
        : null;

    final notifier = ref.read(staffRewardsProvider.notifier);

    // 4. Call the Notifier
    // Since you handle try-catch inside here, we just await the result.
    final message = await notifier.addReward(
      rewardCode: _codeCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      points: points,
      quantity: qty,
      status: _isActive,
      photos: _photos,
      conditions: _conditionCtrl.text.trim().isEmpty 
          ? null 
          : _conditionCtrl.text.trim(),
      availableUntil: availableDate,
      validityWeeks: validityWeeks,
    );

    // 5. Turn off Loading
    if (mounted) {
      setState(() => _isLoading = false);
    }

    // 6. Handle Navigation & Feedback
    if (!mounted) return;

    showAppSnackBar(
      context: context,
      content: message.message,
      isError: !message.isSuccess,
    );

    if (message.isSuccess) {
      Navigator.of(context).pop();
    }
  }

  Widget _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Photos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: _pickPhoto,
              label: const Text('Add'),
              icon: const Icon(Icons.add_circle),
              style: ButtonStyle(iconAlignment: IconAlignment.end),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _photos.isEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('No photo added')),
              )
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
                              color: Colors.red, // Changed to red for standard delete action
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