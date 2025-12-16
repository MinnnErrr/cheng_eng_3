import 'dart:io';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/towing_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listItem.dart';
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
  
  // Local loading state for the submit button
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
    // 1. Safety Check: Ensure user is loaded
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final vehicleList = ref.watch(customerVehicleProvider).value;
    final vehicles = vehicleList?.vehicles ?? [];
    
    // We only read the notifier here, we don't watch the state for loading
    // because we handle button loading locally
    final towingNotifier = ref.read(customerTowingsProvider(user.id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Towing Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20, // Requires Flutter 3.27+
              children: [
                // Address Box
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.address,
                        softWrap: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20, color: Colors.red),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Emergency number
                IntlPhoneField(
                  initialCountryCode: 'MY',
                  initialValue: _phoneNum,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Update state variables directly
                    _dialCode = value.countryCode;
                    _countryCode = value.countryISOCode;
                    _phoneNum = value.number;
                  },
                ),

                // Vehicle Selection
                textFormField(
                  controller: _vehicleCtrl,
                  label: 'Vehicle',
                  readOnly: true, 
                  onTap: () => _showVehicleModal(context, vehicles),
                ),

                // Remarks
                textFormField(
                  controller: _remarksCtrl,
                  label: 'Remarks',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),

                // Picture
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const Text(
                      'Picture of surrounding',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildImagePicker(),
                  ],
                ),
                
                const SizedBox(height: 10),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading 
                      ? null 
                      : () async {
                        if (!_formKey.currentState!.validate()) return;
                        
                        if (_phoneNum == null || _phoneNum!.isEmpty) {
                           showAppSnackBar(context: context, content: "Please enter a phone number", isError: true);
                           return;
                        }

                        setState(() => _isLoading = true);

                        // FIX: Pass the picked image to the notifier
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
                          photo: _pickedImage, // <--- CRITICAL FIX
                        );

                        if (!context.mounted) return;
                        
                        setState(() => _isLoading = false);

                        showAppSnackBar(
                          context: context,
                          content: success
                              ? 'Towing request submitted'
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
                    child: _isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
                        : const Text('Submit Request'),
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
      imageContent = Image.file(_pickedImage!, fit: BoxFit.cover);
    } else {
      imageContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.camera_alt, color: Colors.grey, size: 40),
          Text("No image selected", style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            // FIX: Ensure image fills the container
            Positioned.fill(child: imageContent),
            
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

  void _showVehicleModal(BuildContext context, List<Vehicle> vehicles) {
    if (vehicles.isEmpty) {
      showAppSnackBar(context: context, content: "No vehicles found. Please add a vehicle first.", isError: true);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows controlling height better
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // Take up 60% of screen
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Choose a Vehicle',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _vehicle = vehicle;
                            _vehicleCtrl.text = "${vehicle.regNum} (${vehicle.model})";
                          });
                          Navigator.pop(context);
                        },
                        child: VehicleListitem(
                          vehicle: vehicle,
                          descriptionRequired: false,
                          colourRequired: true, // Useful to identify vehicle
                          yearRequired: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}