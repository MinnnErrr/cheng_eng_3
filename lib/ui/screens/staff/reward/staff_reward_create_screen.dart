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
  bool _isLoading = false;
  final List<File> _photos = [];

  final _formKey = GlobalKey<FormState>();
  final _dateFormatter = DateFormat('dd MMM yyyy, h:mm a');

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

  // --- ACTIONS ---

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

  Future<void> _handleDateSelection() async {
    final date = await datePicker(DateTime.now(), context);
    if (date != null) {
      setState(() {
        _availableUntil = date;
        _availableDateCtrl.text = _dateFormatter.format(date);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final points = int.tryParse(_pointCtrl.text.trim()) ?? 0;
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;

    final int? validityWeeks = _hasValidity && _validityCtrl.text.isNotEmpty
        ? int.tryParse(_validityCtrl.text.trim())
        : null;

    final DateTime? availableDate = _limitedPeriod ? _availableUntil : null;

    final notifier = ref.read(staffRewardsProvider.notifier);

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

    if (mounted) setState(() => _isLoading = false);

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

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Add Reward'),
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
                textFormField(controller: _codeCtrl, label: 'Reward Code'),
                const SizedBox(height: 20),
                textFormField(controller: _nameCtrl, label: 'Reward Name'),
                const SizedBox(height: 20),
                textFormField(
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
                      child: textFormField(
                        controller: _pointCtrl,
                        label: 'Points Cost',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: textFormField(
                        controller: _qtyCtrl,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                _SectionHeader(title: "Availability"),

                // Limited Period Toggle
                DropdownButtonFormField<bool>(
                  initialValue: _limitedPeriod,
                  decoration: InputDecoration(
                    labelText: "Limited Period?",
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
                ),

                if (_limitedPeriod) ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _handleDateSelection, // Tap anywhere on field
                    child: AbsorbPointer(
                      // Prevents keyboard from showing
                      child: textFormField(
                        controller: _availableDateCtrl,
                        label: 'Available Until',
                        suffix: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Validity Period Toggle
                DropdownButtonFormField<bool>(
                  initialValue: _hasValidity,
                  decoration: InputDecoration(
                    labelText: "Limited Validity?",
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
                ),

                if (_hasValidity) ...[
                  const SizedBox(height: 20),
                  textFormField(
                    controller: _validityCtrl,
                    label: 'Valid for (Weeks)',
                    keyboardType: TextInputType.number,
                    suffix: Text(
                      "weeks",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],

                const SizedBox(height: 30),
                _SectionHeader(title: "Terms & Conditions (Optional)"),
                textFormField(
                  controller: _conditionCtrl,
                  validationRequired: false,
                  minLines: 3,
                  maxLines: null,
                ),

                const SizedBox(height: 30),
                _photoSection(theme),

                const SizedBox(height: 30),

                // Status Toggle
                DropdownButtonFormField<bool>(
                  initialValue: _isActive,
                  decoration: InputDecoration(
                    labelText: "Status",
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text(
                        "Active (Visible)",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text(
                        "Draft (Hidden)",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _isActive = val);
                  },
                ),

                const SizedBox(height: 40),

                // Submit Button
                FilledButton(
                  onPressed: _isLoading ? null : _submitForm,

                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black, // Contrast on Yellow
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "ADD REWARD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 40), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- SUB WIDGETS ---

  Widget _photoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionHeader(title: "Photos", padding: 0),
          ],
        ),
        const SizedBox(height: 12),

        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _photos.length + 1, // +1 for the "Add" button card
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            // "Add Photo" Button as the last item (or first if you prefer)
            if (index == _photos.length) {
              return InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
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

            final file = _photos[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
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

// Simple Header Helper
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
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant, // Highlight headers
        ),
      ),
    );
  }
}
