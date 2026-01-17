import 'dart:io';
import 'package:cheng_eng_3/ui/vehicles/notifiers/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/custom_text_field.dart';
import 'package:cheng_eng_3/utils/validation.dart';
import 'package:cheng_eng_3/utils/yearpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VehicleCreateScreen extends ConsumerStatefulWidget {
  const VehicleCreateScreen({super.key});

  @override
  ConsumerState<VehicleCreateScreen> createState() =>
      _VehicleCreateScreenState();
}

class _VehicleCreateScreenState extends ConsumerState<VehicleCreateScreen> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _regNum = TextEditingController();
  final TextEditingController _make = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _colour = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  int? _year;
  File? _pickedImage;

  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
    ); 
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _regNum.dispose();
    _make.dispose();
    _model.dispose();
    _colour.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleNotifier = ref.read(customerVehicleProvider.notifier);
    final isLoading = ref.watch(customerVehicleProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Vehicle'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // PIC
              _buildImagePicker(),
              const SizedBox(height: 30),

              Text(
                "Vehicle Details",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // FIELDS
              Customtextfield(
                controller: _description,
                label: 'Description',
                isRequired: false,
                hint: 'e.g. Work Car',
                textCapitalization: TextCapitalization.sentences,
                validator: Validators.maxLength(20),
              ),
              const SizedBox(height: 16),

              Customtextfield(
                controller: _regNum,
                label: 'Registration Number',
                hint: 'e.g. ABC1234',
                textCapitalization: TextCapitalization.characters,
                validator: Validators.maxLength(10),
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Customtextfield(
                      controller: _make,
                      label: 'Make',
                      textCapitalization: TextCapitalization.words,
                      validator: Validators.maxLength(20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Customtextfield(
                      controller: _model,
                      label: 'Model',
                      textCapitalization: TextCapitalization.words,
                      validator: Validators.maxLength(50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Customtextfield(
                      controller: _colour,
                      label: 'Colour',
                      textCapitalization: TextCapitalization.words,
                      validator: Validators.maxLength(20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Customtextfield(
                      controller: _yearController,
                      label: 'Year',
                      readOnly: true,
                      suffix: const Icon(Icons.calendar_month, size: 20),
                      onTap: () {
                        yearPicker(context, _year, (value) {
                          setState(() {
                            _year = value.year;
                            _yearController.text = value.year.toString();
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // BUTTON
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        if (_year == null) {
                          showAppSnackBar(
                            context: context,
                            content: "Please select a year",
                            isError: true,
                          );
                          return;
                        }

                        FocusScope.of(context).unfocus();

                        final success = await vehicleNotifier.addVehicle(
                          description: _description.text
                              .trim(), 
                          regNum: _regNum.text.trim(),
                          make: _make.text.trim(),
                          model: _model.text.trim(),
                          colour: _colour.text.trim(),
                          year: _year!,
                          photo: _pickedImage,
                        );

                        if (!context.mounted) return;

                        if (success) {
                          showAppSnackBar(
                            context: context,
                            content: 'Vehicle added successfully',
                            isError: false,
                          );
                          Navigator.of(context).pop();
                        } else {
                          showAppSnackBar(
                            context: context,
                            content: 'Failed to add vehicle',
                            isError: true,
                          );
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'ADD RECORD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final theme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.outline.withValues(alpha: 0.2)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: theme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tap to add vehicle photo",
                    style: TextStyle(
                      color: theme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

            if (_pickedImage != null)
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
