import 'dart:io';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/widgets/yearpicker.dart';
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
    final picked = await _imagePicker.pickImage(source: ImageSource.camera); // or gallery
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
        // Use ListView for better keyboard handling
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // PIC
              _buildImagePicker(),
              const SizedBox(height: 20),

              // FIELDS
              // Ensure validationRequired logic works in your custom widget
              textFormField(
                controller: _description,
                label: 'Description', // e.g., "My Work Truck"
                validationRequired: false, 
              ),
              const SizedBox(height: 15),
              
              textFormField(
                controller: _regNum,
                label: 'Registration Number',
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: textFormField(controller: _make, label: 'Make'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: textFormField(controller: _model, label: 'Model'),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: textFormField(controller: _colour, label: 'Colour'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: textFormField(
                      controller: _yearController,
                      label: 'Year',
                      readOnly: true,
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Disable button while loading to prevent double submission
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          
                          // Validate Year manually since it's a specialized field
                          if (_year == null) {
                             showAppSnackBar(context: context, content: "Please select a year", isError: true);
                             return;
                          }

                          // Close keyboard
                          FocusScope.of(context).unfocus();

                          final success = await vehicleNotifier.addVehicle(
                            description: _description.text.trim(), // FIX: Was missing
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
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Create Vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200, // Fixed height for consistency
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest, // Better contrast
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      clipBehavior: Clip.hardEdge, // Essential for clipping the image
      child: Stack(
        fit: StackFit.expand, // Ensures children fill the container
        children: [
          if (_pickedImage != null)
            Image.file(
              _pickedImage!,
              fit: BoxFit.cover, // Ensures image covers the box
              width: double.infinity,
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                const SizedBox(height: 8),
                Text(
                  "Tap camera button to add photo",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            
          // Floating Button
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton.small(
              heroTag: 'vehicle_image_picker', // Unique tag prevents conflicts
              onPressed: _pickImage,
              child: Icon(_pickedImage == null ? Icons.camera_alt : Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}