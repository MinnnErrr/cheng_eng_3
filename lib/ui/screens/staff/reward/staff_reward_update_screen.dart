import 'dart:io';

import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StaffRewardUpdateScreen extends ConsumerStatefulWidget {
  const StaffRewardUpdateScreen({super.key, required this.reward});

  final Reward reward;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffRewardUpdateState();
}

class _StaffRewardUpdateState extends ConsumerState<StaffRewardUpdateScreen> {
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
  // Remove 'late' to avoid initialization errors. Set defaults.
  bool _limitedPeriod = false;
  DateTime? _availableUntil;
  bool _hasValidity = false;
  bool _isLoading = false; // Added loading state

  // List to hold Strings (URLs) and Files (New Photos)
  final List<dynamic> _photos = [];

  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

  @override
  void initState() {
    super.initState();
    // Load data after super.initState
    _loadReward(widget.reward);
  }

  void _loadReward(Reward reward) {
    // Note: It's safe to read providers in initState, but don't watch them.
    final imageService = ref.read(imageServiceProvider);

    _codeCtrl.text = reward.code;
    _nameCtrl.text = reward.name;
    _descCtrl.text = reward.description;
    _pointCtrl.text = reward.points.toString();
    _qtyCtrl.text = reward.quantity.toString();
    
    // Simplified null check
    _conditionCtrl.text = reward.conditions ?? '';

    // Handle Limited Period Logic
    if (reward.availableUntil != null) {
      _limitedPeriod = true;
      _availableUntil = reward.availableUntil;
      _availableDateCtrl.text = _dateFormatter.format(_availableUntil!);
    } else {
      _limitedPeriod = false;
    }

    // Handle Validity Logic
    if (reward.validityWeeks != null) {
      _hasValidity = true;
      _validityCtrl.text = reward.validityWeeks.toString();
    } else {
      _hasValidity = false;
    }

    // Handle Photos
    if (reward.photoPaths.isNotEmpty) {
      for (final path in reward.photoPaths) {
        final url = imageService.retrieveImageUrl(path);
        _photos.add(url);
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    // Added image optimization to prevent memory crashes
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

  ImageProvider _getImage(dynamic item) {
    if (item is File) return FileImage(item);
    return NetworkImage(item as String); // Cast as String for safety
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Reward'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                textFormField(controller: _codeCtrl, label: 'Reward Code'),

                textFormField(controller: _nameCtrl, label: 'Name'),

                textFormField(
                  controller: _pointCtrl, 
                  label: 'Points Required',
                  keyboardType: TextInputType.number,
                ),

                textFormField(
                  controller: _qtyCtrl,
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                ),

                DropdownButtonFormField<bool>(
                  initialValue: _limitedPeriod, // Changed from initialValue to value
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
                         // Clear data if user switches to No
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
                    // Better UX: Tap anywhere on field to open picker
                    onTap: () async {
                       final date = await datePicker(DateTime.now(), context);
                       if (date != null) {
                          setState(() {
                            _availableUntil = date;
                            _availableDateCtrl.text = _dateFormatter.format(date);
                          });
                       }
                    },
                    suffix: IconButton(
                      onPressed: () async {
                         // Duplicate logic handled by extracting method or keeping simple
                         final date = await datePicker(DateTime.now(), context);
                         if (date != null) {
                            setState(() {
                              _availableUntil = date;
                              _availableDateCtrl.text = _dateFormatter.format(date);
                            });
                         }
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),

                DropdownButtonFormField<bool>(
                  initialValue: _hasValidity, // Changed from initialValue to value
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

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitUpdate, // Disable if loading
                    child: _isLoading 
                      ? const CircularProgressIndicator.adaptive() 
                      : const Text('Update Reward'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(staffRewardsProvider.notifier);

    // Safe parsing to prevent crashes
    final points = int.tryParse(_pointCtrl.text.trim()) ?? 0;
    final quantity = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    
    final validityWeeks = _hasValidity && _validityCtrl.text.isNotEmpty
        ? int.tryParse(_validityCtrl.text.trim())
        : null;

    final message = await notifier.updateReward(
      id: widget.reward.id,
      rewardCode: _codeCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      points: points,
      quantity: quantity,
      photos: _photos, // Contains mixed List<String> and List<File>
      conditions: _conditionCtrl.text.trim().isEmpty
          ? null
          : _conditionCtrl.text.trim(),
      availableUntil: _limitedPeriod ? _availableUntil : null,
      validityWeeks: validityWeeks,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      
      showAppSnackBar(
        context: context,
        content: message.message,
        isError: !message.isSuccess,
      );

      if (message.isSuccess) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Photos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _pickPhoto,
              label: const Text('Add'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        
        const SizedBox(height: 10),

        _photos.isEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
                  final photo = _photos[index];

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: _getImage(photo),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          // Loading builder specifically for network images
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
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
                              color: Colors.red,
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