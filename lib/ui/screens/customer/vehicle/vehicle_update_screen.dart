import 'dart:io';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/widgets/yearpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VehicleUpdateScreen extends ConsumerStatefulWidget {
  const VehicleUpdateScreen({super.key, required this.vehicle});
  final Vehicle vehicle;

  @override
  ConsumerState<VehicleUpdateScreen> createState() =>
      _VehicleUpdateScreenState();
}

class _VehicleUpdateScreenState extends ConsumerState<VehicleUpdateScreen> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _regNum = TextEditingController();
  final TextEditingController _make = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _colour = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  
  late int _year;
  File? _pickedImage;
  String? _imageUrl;

  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _loadVehicle(Vehicle vehicle) {
    final imageService = ref.read(imageServiceProvider);

    // FIX: Handle potential null values to prevent crashes
    _description.text = vehicle.description ?? "";
    _regNum.text = vehicle.regNum;
    _make.text = vehicle.make;
    _model.text = vehicle.model;
    _colour.text = vehicle.colour; // FIX: Null safety added

    _year = vehicle.year;
    _yearController.text = vehicle.year.toString();

    if (vehicle.photoPath != null) {
      _imageUrl = imageService.retrieveImageUrl(vehicle.photoPath!);
    }
  }

  @override
  void initState() {
    _loadVehicle(widget.vehicle);
    super.initState();
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
        title: const Text('Update Vehicle'),
      ),
      body: SafeArea(
        // FIX: Use ListView for better scrolling with keyboard
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // PIC
              _buildImagePicker(),
              const SizedBox(height: 20),

              // FIELDS
              textFormField(
                controller: _description,
                label: 'Description',
                validationRequired: false,
              ),
              const SizedBox(height: 15),

              textFormField(
                controller: _regNum,
                label: 'Registration Number',
              ),
              const SizedBox(height: 15),

              textFormField(
                controller: _make,
                label: 'Make',
              ),
              const SizedBox(height: 15),

              textFormField(
                controller: _model,
                label: 'Model',
              ),
              const SizedBox(height: 15),

              textFormField(
                controller: _colour,
                label: 'Colour',
              ),
              const SizedBox(height: 15),

              textFormField(
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
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // FIX: Disable button while loading
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          
                          FocusScope.of(context).unfocus();

                          final success = await vehicleNotifier.updateVehicle(
                            id: widget.vehicle.id,
                            description: _description.text.trim().isEmpty
                                ? null
                                : _description.text.trim(),
                            regNum: _regNum.text.trim(),
                            make: _make.text.trim(),
                            model: _model.text.trim(),
                            colour: _colour.text.trim(),
                            year: _year,
                            photo: _pickedImage,
                          );

                          if (!context.mounted) return;
                          
                          if (success) {
                             showAppSnackBar(
                              context: context,
                              content: 'Vehicle updated',
                              isError: false,
                            );
                            Navigator.of(context).pop();
                          } else {
                             showAppSnackBar(
                              context: context,
                              content: 'Failed to update vehicle',
                              isError: true,
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator()
                        )
                      : const Text('Update Vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    Widget imageContent;

    if (_pickedImage != null) {
      imageContent = Image.file(_pickedImage!, fit: BoxFit.cover);
    } else if (_imageUrl != null) {
      imageContent = Image.network(
        _imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.image_not_supported),
        ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : const Center(child: CircularProgressIndicator(strokeWidth: 3)),
      );
    } else {
      imageContent = const Center(child: Text("No image selected"));
    }

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge, // Clip the corners of the image
      child: Stack(
        children: [
          // FIX: Use Positioned.fill so the image stretches to the Container size
          Positioned.fill(child: imageContent),
          
          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton.filled(
              onPressed: _pickImage,
              icon: Icon(_pickedImage == null ? Icons.add_a_photo : Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}