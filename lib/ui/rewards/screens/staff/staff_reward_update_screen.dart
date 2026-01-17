import 'dart:io';

import 'package:cheng_eng_3/ui/rewards/notifiers/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/domain/models/reward_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/utils/datepicker.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/custom_text_field.dart';
import 'package:cheng_eng_3/utils/validation.dart';
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
  bool _hasValidity = false;
  bool _isLoading = false;

  final List<dynamic> _photos = [];

  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd MMM yyyy, h:mm a');

  @override
  void initState() {
    super.initState();
    _loadReward(widget.reward);
  }

  void _loadReward(Reward reward) {
    final imageService = ref.read(imageServiceProvider);

    _codeCtrl.text = reward.code;
    _nameCtrl.text = reward.name;
    _descCtrl.text = reward.description;
    _pointCtrl.text = reward.points.toString();
    _qtyCtrl.text = reward.quantity.toString();
    _conditionCtrl.text = reward.conditions ?? '';

    if (reward.availableUntil != null) {
      _limitedPeriod = true;
      _availableUntil = reward.availableUntil;
      _availableDateCtrl.text = _dateFormatter.format(_availableUntil!);
    } else {
      _limitedPeriod = false;
    }

    if (reward.validityWeeks != null) {
      _hasValidity = true;
      _validityCtrl.text = reward.validityWeeks.toString();
    } else {
      _hasValidity = false;
    }

    if (reward.photoPaths.isNotEmpty) {
      for (final path in reward.photoPaths) {
        final url = imageService.retrieveImageUrl(path);
        _photos.add(url);
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
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
    return NetworkImage(item as String);
  }

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

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(staffRewardsProvider.notifier);
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
      photos: _photos,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Update Reward'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: "Basic Information"),
                Customtextfield(controller: _codeCtrl, label: 'Reward Code', validator: Validators.maxLength(20),),
                const SizedBox(height: 20),
                Customtextfield(controller: _nameCtrl, label: 'Reward Name', validator: Validators.maxLength(50),),
                const SizedBox(height: 20),
                Customtextfield(
                  controller: _descCtrl,
                  label: 'Description',
                  minLines: 3,
                  maxLines: null,
                ),

                const SizedBox(height: 30),
                _SectionHeader(title: "Value & Stock"),
                Row(
                  children: [
                    Expanded(
                      child: Customtextfield(
                        controller: _pointCtrl,
                        label: 'Points Cost',
                        keyboardType: TextInputType.number,
                        validator: Validators.isInt,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Customtextfield(
                        controller: _qtyCtrl,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                        validator: Validators.isInt,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                _SectionHeader(title: "Availability"),

                DropdownButtonFormField<bool>(
                  initialValue: _limitedPeriod,
                  decoration: InputDecoration(
                    labelText: "Display reward for limited period?",
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: false,
                      child: Text("No (Permanent)"),
                    ),
                    DropdownMenuItem(
                      value: true,
                      child: Text("Yes (Set Date)"),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _limitedPeriod = val;
                        if (!val) {
                          _availableUntil = null;
                          _availableDateCtrl.clear();
                        }
                      });
                    }
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),

                if (_limitedPeriod) ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _handleDateSelection,
                    child: AbsorbPointer(
                      child: Customtextfield(
                        controller: _availableDateCtrl,
                        label: 'Available Until',
                        suffix: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                DropdownButtonFormField<bool>(
                  initialValue: _hasValidity,
                  decoration: InputDecoration(
                    labelText: "Set validity period for the reward?",
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: false, child: Text("No (Forever)")),
                    DropdownMenuItem(
                      value: true,
                      child: Text("Yes (Set Weeks)"),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _hasValidity = val;
                        if (!val) _validityCtrl.clear();
                      });
                    }
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),

                if (_hasValidity) ...[
                  const SizedBox(height: 20),
                  Customtextfield(
                    controller: _validityCtrl,
                    label: 'Validity Period (Weeks)',
                    keyboardType: TextInputType.number,
                    suffix: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Weeks",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    validator: Validators.isInt,
                  ),
                ],

                const SizedBox(height: 30),
                _SectionHeader(title: 'Terms & Conditions'),
                Customtextfield(
                  controller: _conditionCtrl,
                  isRequired: false,
                  minLines: 3,
                  maxLines: null,
                ),

                const SizedBox(height: 30),
                _photoSection(theme),
                const SizedBox(height: 40),

               FilledButton(
                    onPressed: _isLoading ? null : _submitUpdate,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "UPDATE REWARD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                

                const SizedBox(height: 40), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionHeader(title: "Photos", padding: 0),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _photos.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index == _photos.length) {
              return InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final photo = _photos[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: _getImage(photo),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _photos.removeAt(index));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final double padding;
  const _SectionHeader({required this.title, this.padding = 20});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
