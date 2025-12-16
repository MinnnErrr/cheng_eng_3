import 'dart:io';

import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StaffProductUpdateScreen extends ConsumerStatefulWidget {
  const StaffProductUpdateScreen({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffProductUpdateState();
}

class _StaffProductUpdateState extends ConsumerState<StaffProductUpdateScreen> {
  // Controllers
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

  // State Variables (Initialized to defaults to avoid 'late' errors)
  bool _hasInstallation = false;
  ProductAvailability _availability = ProductAvailability.ready;
  bool _isLoading = false; // Added loading state
  
  // Mixed list: Can contain Strings (URLs) or Files (New photos)
  final List<dynamic> _photos = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProduct(widget.product);
  }

  void _loadProduct(Product product) {
    // Note: Don't watch providers in initState, just read.
    final imageService = ref.read(imageServiceProvider);

    _nameCtrl.text = product.name;
    _categoryCtrl.text = product.category;
    _brandCtrl.text = product.brand;
    _modelCtrl.text = product.model ?? '';
    _colourCtrl.text = product.colour ?? '';
    _descCtrl.text = product.description;
    _priceCtrl.text = product.price.toString();
    _quantityCtrl.text = product.quantity?.toString() ?? '';
    _installFeeCtrl.text = product.installationFee?.toString() ?? '';
    _remarksCtrl.text = product.remarks ?? '';
    
    // Update state variables
    setState(() {
      _hasInstallation = product.installation;
      _availability = product.availability;
      
      if (product.photoPaths.isNotEmpty) {
        for (final path in product.photoPaths) {
          final url = imageService.retrieveImageUrl(path);
          _photos.add(url);
        }
      }
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    // Optimized image picking
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

  // Helper to handle mixed types (File vs String URL)
  ImageProvider _getImage(dynamic item) {
    if (item is File) return FileImage(item);
    return NetworkImage(item as String);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                textFormField(controller: _nameCtrl, label: 'Name'),
                const SizedBox(height: 20),

                textFormField(controller: _categoryCtrl, label: 'Category'),
                const SizedBox(height: 20),

                textFormField(controller: _brandCtrl, label: 'Brand'),
                const SizedBox(height: 20),

                textFormField(controller: _modelCtrl, label: 'Model'),
                const SizedBox(height: 20),

                textFormField(controller: _colourCtrl, label: 'Colour'),
                const SizedBox(height: 20),

                textFormField(
                  controller: _descCtrl,
                  minLines: 5,
                  maxLines: null,
                  label: 'Description',
                ),
                const SizedBox(height: 20),

                textFormField(
                  controller: _remarksCtrl,
                  minLines: 3,
                  maxLines: null,
                  label: 'Remarks',
                  validationRequired: false,
                ),
                const SizedBox(height: 20),

                textFormField(
                  controller: _priceCtrl,
                  label: 'Price (RM)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<ProductAvailability>(
                  initialValue: _availability, // Use value, NOT initialValue
                  decoration: const InputDecoration(
                    labelText: "Availability",
                  ),
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
                          _quantityCtrl.clear();
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                if (_availability == ProductAvailability.ready)
                  Column(
                    children: [
                      textFormField(
                        controller: _quantityCtrl,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                DropdownButtonFormField<bool>(
                  initialValue: _hasInstallation, // Use value, NOT initialValue
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
                        if (!_hasInstallation) {
                          _installFeeCtrl.clear();
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                if (_hasInstallation)
                  Column(
                    children: [
                      textFormField(
                        controller: _installFeeCtrl,
                        label: 'Installation Fees (RM)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                _photoSection(),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitUpdate,
                    child: _isLoading 
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Update Product'),
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

    final notifier = ref.read(staffProductProvider.notifier);

    // Safe Parsing
    final quantity = int.tryParse(_quantityCtrl.text.trim()) ?? 0;
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    
    final installFee = _hasInstallation
        ? double.tryParse(_installFeeCtrl.text.trim())
        : null;

    final message = await notifier.updateProduct(
      currentProduct: widget.product,
      name: _nameCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      brand: _brandCtrl.text.trim(),
      model: _modelCtrl.text.trim().isEmpty ? null : _modelCtrl.text.trim(),
      colour: _colourCtrl.text.trim().isEmpty ? null : _colourCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      availability: _availability,
      quantity: _availability == ProductAvailability.ready ? quantity : null,
      installation: _hasInstallation,
      installationFee: installFee,
      price: price,
      photos: _photos,
      remarks: _remarksCtrl.text.trim().isEmpty ? null : _remarksCtrl.text.trim(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Photos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
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
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8)
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
                          // Handle loading for network images
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image));
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
                            decoration: const BoxDecoration(
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