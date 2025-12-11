import 'dart:io';

import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StaffProductCreateScreen extends ConsumerStatefulWidget {
  const StaffProductCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffProductCreateState();
}

class _StaffProductCreateState extends ConsumerState<StaffProductCreateScreen> {
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _colourCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _installFeeCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  bool _isActive = true;
  bool _hasInstallation = false;
  ProductAvailability _availability = ProductAvailability.ready;
  final List<File> _photos = [];

  final _formKey = GlobalKey<FormState>();

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
    _categoryCtrl.dispose();
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _colourCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _quantityCtrl.dispose();
    _installFeeCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifer = ref.read(staffProductProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                textFormField(controller: _nameCtrl, label: 'Name'),

                textFormField(controller: _categoryCtrl, label: 'Category'),

                textFormField(controller: _brandCtrl, label: 'Brand'),

                textFormField(
                  controller: _modelCtrl,
                  label: 'Model',
                  validationRequired: false,
                ),

                textFormField(
                  controller: _colourCtrl,
                  label: 'Colour',
                  validationRequired: false,
                ),

                textFormField(
                  controller: _descCtrl,
                  minLines: 5,
                  maxLines: null,
                  label: 'Description',
                ),

                textFormField(
                  controller: _remarksCtrl,
                  minLines: 3,
                  maxLines: null,
                  label: 'Remarks',
                  validationRequired: false,
                ),

                textFormField(
                  controller: _priceCtrl,
                  label: 'Price (RM)',
                  keyboardType: TextInputType.numberWithOptions(),
                ),

                DropdownButtonFormField<ProductAvailability>(
                  initialValue: _availability,
                  decoration: const InputDecoration(labelText: "Availability"),
                  items: ProductAvailability.values
                      .map(
                        (availability) => DropdownMenuItem(
                          value: availability,
                          child: Text(availability.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _availability = value;

                        if (_availability != ProductAvailability.ready) {
                          _quantityCtrl.text = '';
                        }
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
                if (_availability == ProductAvailability.ready)
                  textFormField(
                    controller: _quantityCtrl,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                  ),

                DropdownButtonFormField<bool>(
                  initialValue: _hasInstallation,
                  decoration: const InputDecoration(
                    labelText: "Is installation service provided?",
                  ),
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Yes")),
                    DropdownMenuItem(value: false, child: Text("No")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _hasInstallation = value;

                        if (_hasInstallation == false) {
                          _installFeeCtrl.text = '';
                        }
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
                if (_hasInstallation == true)
                  textFormField(
                    controller: _installFeeCtrl,
                    label: 'Installation Fees (RM)',
                    keyboardType: TextInputType.numberWithOptions(),
                  ),

                _photoSection(),

                DropdownButtonFormField<bool>(
                  initialValue: _isActive,
                  decoration: const InputDecoration(
                    labelText: "Activate the product now?",
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

                    final success = await notifer.addProduct(
                      name: _nameCtrl.text.trim(),
                      category: _categoryCtrl.text.trim(),
                      brand: _brandCtrl.text.trim(),
                      model: _modelCtrl.text.trim().isEmpty
                          ? null
                          : _modelCtrl.text.trim(),
                      colour: _colourCtrl.text.trim().isEmpty
                          ? null
                          : _colourCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      status: _isActive,
                      availability: _availability,
                      quantity: _availability == ProductAvailability.ready
                          ? int.parse(_quantityCtrl.text.trim())
                          : null,
                      installation: _hasInstallation,
                      installationFee: _hasInstallation
                          ? double.parse(
                              _installFeeCtrl.text.trim(),
                            )
                          : null,
                      price: double.parse(_priceCtrl.text.trim()),
                      photos: _photos,
                      remarks: _remarksCtrl.text.trim().isEmpty ? null : _remarksCtrl.text.trim(),
                    );

                    if (!context.mounted) return;
                    showAppSnackBar(
                      context: context,
                      content: success
                          ? 'Product added'
                          : 'Failed to add product',
                      isError: !success,
                    );

                    if (success) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add Product'),
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
