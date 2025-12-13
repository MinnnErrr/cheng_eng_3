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
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
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
    bool isLoading = ref.watch(customerVehicleProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Vehicle'),
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
                textFormField(controller: _description, label: 'Description', validationRequired: false),
                textFormField(
                  controller: _regNum,
                  label: 'Registration Number',
                ),
                textFormField(
                  controller: _make,
                  label: 'Make',
                ),
                textFormField(
                  controller: _model,
                  label: 'Model',
                ),
                textFormField(
                  controller: _colour,
                  label: 'Colour',
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
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final success = await vehicleNotifier.addVehicle(
                      regNum: _regNum.text.trim(),
                      make: _make.text.trim(),
                      model: _model.text.trim(),
                      colour: _colour.text.trim(),
                      year: _year!,
                      photo: _pickedImage,
                    );

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: success == true
                          ? 'Vehicle added'
                          : 'Failed to add vehicle',
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
                      : Text('Create Vehicle',
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
