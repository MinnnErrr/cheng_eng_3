import 'dart:io';

import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/ui/tows/notifiers/customer_towings_notifier.dart';
import 'package:cheng_eng_3/ui/vehicles/notifiers/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/domain/models/vehicle_model.dart';
import 'package:cheng_eng_3/ui/tows/screens/customer/towing_screen.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/vehicles/widgets/vehicle_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class TowingSubmitScreen extends ConsumerStatefulWidget {
  const TowingSubmitScreen({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double latitude;
  final double longitude;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TowingSubmitScreenState();
}

class _TowingSubmitScreenState extends ConsumerState<TowingSubmitScreen> {
  final _remarksCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();

  bool _isLoading = false;

  String _countryCode = 'MY';
  String _dialCode = '+60';
  String? _phoneNum;
  File? _pickedImage;
  Vehicle? _vehicle;

  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final vehicleList = ref.watch(customerVehicleProvider).value;
    final vehicles = vehicleList?.vehicles ?? [];

    final towingNotifier = ref.read(customerTowingsProvider(user.id).notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Towing Request')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. LOCATION CARD ---
                _buildSectionLabel('Location Details', theme),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.address,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- 2. CONTACT INFO ---
                _buildSectionLabel('Contact Info', theme),
                const SizedBox(height: 20),
                IntlPhoneField(
                  initialCountryCode: 'MY',
                  initialValue: _phoneNum,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (value) {
                    _dialCode = value.countryCode;
                    _countryCode = value.countryISOCode;
                    _phoneNum = value.number;
                  },
                ),

                const SizedBox(height: 10),

                // --- 3. VEHICLE ---
                textFormField(
                  controller: _vehicleCtrl,
                  label: 'Select Vehicle',
                  readOnly: true,
                  suffix: const Icon(Icons.arrow_drop_down),
                  onTap: () => _showVehicleModal(context, vehicles),
                ),

                const SizedBox(height: 20),

                // --- 4. DETAILS ---
                textFormField(
                  controller: _remarksCtrl,
                  label: 'Remarks (Optional)',
                  maxLines: 3,
                  validationRequired: false,
                  textCapitalization: TextCapitalization.sentences,
                ),

                const SizedBox(height: 30),

                // --- 5. IMAGE ---
                _buildSectionLabel('Photo Evidence', theme),
                const SizedBox(height: 10),
                _buildImagePicker(theme),

                const SizedBox(height: 30),

                // --- SUBMIT BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            if (_phoneNum == null || _phoneNum!.isEmpty) {
                              showAppSnackBar(
                                context: context,
                                content: "Please enter a phone number",
                                isError: true,
                              );
                              return;
                            }
                            if (_vehicle == null) {
                              showAppSnackBar(
                                context: context,
                                content: "Please select a vehicle",
                                isError: true,
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            final success = await towingNotifier.addTowing(
                              latitude: widget.latitude,
                              longitude: widget.longitude,
                              address: widget.address,
                              phoneNum: _phoneNum!,
                              dialCode: _dialCode,
                              countryCode: _countryCode,
                              remarks: _remarksCtrl.text.trim().isEmpty
                                  ? null
                                  : _remarksCtrl.text.trim(),
                              vehicle: _vehicle!,
                              photo: _pickedImage,
                            );

                            if (!context.mounted) return;
                            setState(() => _isLoading = false);

                            showAppSnackBar(
                              context: context,
                              content: success
                                  ? 'Towing request submitted successfully'
                                  : 'Failed to submit towing request',
                              isError: !success,
                            );

                            if (success) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const TowingScreen(),
                                ),
                                (route) => route.isFirst,
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'SUBMIT REQUEST',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: _pickedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_pickedImage!, fit: BoxFit.cover),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tap to add vehicle photo",
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showVehicleModal(BuildContext context, List<Vehicle> vehicles) {
    if (vehicles.isEmpty) {
      showAppSnackBar(
        context: context,
        content: "No vehicles found. Please add a vehicle first.",
        isError: true,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Vehicle',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: vehicles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _vehicle = vehicle;
                              _vehicleCtrl.text =
                                  "${vehicle.regNum.toUpperCase()} (${vehicle.model})";
                            });
                            Navigator.pop(context);
                          },
                          child: VehicleListitem(
                            make: vehicle.make,
                            model: vehicle.model,
                            regNum: vehicle.regNum,
                            photoPath: vehicle.photoPath,
                            colour: vehicle.colour,
                            year: vehicle.year,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
