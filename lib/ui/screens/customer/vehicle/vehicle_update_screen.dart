import 'dart:io';
import 'package:cheng_eng_3/core/controllers/vehicle/vehicle_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/widgets/yearpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VehicleUpdateScreen extends ConsumerStatefulWidget {
  const VehicleUpdateScreen({super.key, this.vehicleId});
  final String? vehicleId;

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
  int? _year;
  File? _pickedImage;
  String? _imageUrl;

  bool _initialized = false;
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

    _description.text = vehicle.description ?? "";
    _regNum.text = vehicle.regNum;
    _make.text = vehicle.make;
    _model.text = vehicle.model;
    _colour.text = vehicle.colour;

    _year = vehicle.year;
    _yearController.text = vehicle.year.toString();

    if (vehicle.photoPath != null) {
      _imageUrl = imageService.retrieveImageUrl(vehicle.photoPath!);
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
    final vehicleNotifier = ref.read(vehicleProvider.notifier);
    bool isLoading = ref.watch(vehicleProvider).isLoading;

    final vehicle = widget.vehicleId == null
        ? null
        : ref.watch(vehicleByIdProvider(widget.vehicleId!)).value;

    if (vehicle != null && _initialized != true) {
      _initialized = true;
      _loadVehicle(vehicle);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicleId != null ? 'Update Vehicle' : 'Add Vehicle',
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
                //PIC
                _buildImagePicker(),

                //FIELDS
                textFormField(controller: _description, label: 'Description'),
                textFormField(
                  controller: _regNum,
                  label: 'Registration Number',
                  validationRequired: true,
                ),
                textFormField(
                  controller: _make,
                  label: 'Make',
                  validationRequired: true,
                ),
                textFormField(
                  controller: _model,
                  label: 'Model',
                  validationRequired: true,
                ),
                textFormField(
                  controller: _colour,
                  label: 'Colour',
                  validationRequired: true,
                ),
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
                  validationRequired: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    bool success;

                    if (widget.vehicleId == null) {
                      success = await vehicleNotifier.addVehicle(
                        regNum: _regNum.text.trim(),
                        make: _make.text.trim(),
                        model: _model.text.trim(),
                        colour: _colour.text.trim(),
                        year: _year!,
                        photo: _pickedImage,
                      );
                    } else {
                      success = await vehicleNotifier.updateVehicle(
                        id: widget.vehicleId!,
                        description: _description.text.trim().isEmpty
                            ? null
                            : _description.text.trim(),
                        regNum: _regNum.text.trim(),
                        make: _make.text.trim(),
                        model: _model.text.trim(),
                        colour: _colour.text.trim(),
                        year: _year!,
                        photo: _pickedImage,
                      );
                    }

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: widget.vehicleId == null
                          ? success == true
                                ? 'Vehicle added'
                                : 'Failed to add vehicle'
                          : success == true
                          ? 'Vehicle updated'
                          : 'Failed to update vehicle',
                    );

                    if (success == true) Navigator.of(context).pop();
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          widget.vehicleId != null
                              ? 'Update Vehicle'
                              : 'Create Vehicle',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    Widget imageContent;

    if (_pickedImage != null) {
      // User picked new image
      imageContent = Image.file(_pickedImage!, fit: BoxFit.cover);
    } else if (_imageUrl != null) {
      // Existing stored URL loaded from db
      imageContent = Image.network(
        _imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: const Icon(Icons.image_not_supported),
        ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
            ? child
            : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
      );
    } else {
      // None
      imageContent = const Center(child: Text("No image selected"));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            imageContent,
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton.filled(
                onPressed: _pickImage,
                icon: Icon(_pickedImage == null ? Icons.add : Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
