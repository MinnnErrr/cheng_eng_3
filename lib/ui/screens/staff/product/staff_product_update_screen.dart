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

  // State Variables
  bool _hasInstallation = false;
  ProductAvailability _availability = ProductAvailability.ready;
  bool _isActive = true; // Added Active State tracking
  bool _isLoading = false;

  // Mixed list: Can contain Strings (URLs) or Files (New photos)
  final List<dynamic> _photos = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProduct(widget.product);
  }

  void _loadProduct(Product product) {
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
      _isActive = product.status; // Load status

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

  // --- ACTIONS ---

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(staffProductProvider.notifier);

    // Safe parsing
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
      remarks: _remarksCtrl.text.trim().isEmpty
          ? null
          : _remarksCtrl.text.trim(),
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

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Update Product'),
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
                // --- 1. Basic Info ---
                const _SectionHeader(title: "Basic Information"),
                textFormField(controller: _nameCtrl, label: 'Product Name'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textFormField(
                        controller: _categoryCtrl,
                        label: 'Category',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: textFormField(
                        controller: _brandCtrl,
                        label: 'Brand',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textFormField(
                        controller: _modelCtrl,
                        label: 'Model (Opt)',
                        validationRequired: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: textFormField(
                        controller: _colourCtrl,
                        label: 'Colour (Opt)',
                        validationRequired: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                textFormField(
                  controller: _descCtrl,
                  minLines: 3,
                  maxLines: null,
                  label: 'Description',
                ),

                const SizedBox(height: 30),

                // --- 2. Pricing & Availability ---
                const _SectionHeader(title: "Pricing & Stock"),
                textFormField(
                  controller: _priceCtrl,
                  label: 'Price (RM)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<ProductAvailability>(
                  initialValue: _availability,
                  decoration: const InputDecoration(
                    labelText: "Availability Status",
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

                if (_availability == ProductAvailability.ready) ...[
                  const SizedBox(height: 20),
                  textFormField(
                    controller: _quantityCtrl,
                    label: 'Stock Quantity',
                    keyboardType: TextInputType.number,
                  ),
                ],

                const SizedBox(height: 30),

                // --- 3. Installation Service ---
                const _SectionHeader(title: "Services"),
                DropdownButtonFormField<bool>(
                  initialValue: _hasInstallation,
                  decoration: const InputDecoration(
                    labelText: "Installation Provided?",
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

                if (_hasInstallation) ...[
                  const SizedBox(height: 20),
                  textFormField(
                    controller: _installFeeCtrl,
                    label: 'Installation Fee (RM)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // --- 4. Photos ---
                _photoSection(theme),

                const SizedBox(height: 20),
                textFormField(
                  controller: _remarksCtrl,
                  minLines: 2,
                  maxLines: null,
                  label: 'Remarks',
                  validationRequired: false,
                ),

                const SizedBox(height: 40),

                FilledButton(
                  onPressed: _isLoading ? null : _submitUpdate,

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
                          'UPDATE PRODUCT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
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

  // --- WIDGETS ---

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
            // Upload Button
            if (index == _photos.length) {
              return InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
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
                        "Upload",
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
                      return const Center(child: CircularProgressIndicator());
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

// Reusable Header
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
