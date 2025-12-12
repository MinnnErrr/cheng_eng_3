import 'dart:io';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towing_notifier.dart';
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
  String _countryCode = 'MY';
  String _dialCode = '+60';
  String? _phoneNum;
  File? _pickedImage;
  String? _vehicleId;

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
    final vehicleList = ref.watch(customerVehicleProvider).value;
    final vehicles = vehicleList?.vehicles ?? [];

    final user = ref.watch(authProvider).value;
    final towingNotifier = ref.read(customerTowingProvider(user!.id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Towing Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                //address
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.address,
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${widget.longitude}, ${widget.latitude}'),
                        ],
                      ),
                    ],
                  ),
                ),

                //emergency number
                IntlPhoneField(
                  initialCountryCode: _countryCode,
                  initialValue: _phoneNum,
                  decoration: InputDecoration(
                    labelText: 'Emergency Phone Number',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _dialCode = value.countryCode;
                      _countryCode = value.countryISOCode;
                      _phoneNum = value.number;
                    });
                  },
                ),

                //vehicle
                textFormField(
                  controller: _vehicleCtrl,
                  label: 'Vehicle',
                  onTap: () => _showVehicleModal(context, vehicles),
                ),

                //remarks
                textFormField(
                  controller: _remarksCtrl,
                  label: 'Remarks',
                  maxLines: null,
                  minLines: 3,
                  validationRequired: false,
                ),

                //picture
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Picture of surrounding',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildImagePicker(),
                  ],
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final success = await towingNotifier.addTowing(
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                      address: widget.address,
                      phoneNum: _phoneNum!,
                      dialCode: _dialCode,
                      countryCode: _countryCode,
                      remarks: _remarksCtrl.text.trim().isEmpty ? null : _remarksCtrl.text.trim(),
                      vehicleId: _vehicleId!,
                    );

                    if (!context.mounted) return;
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
                          builder: (context) => TowingScreen(),
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  },
                  child: Text('Submit'),
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

  void _showVehicleModal(BuildContext context, List<Vehicle> vehicles) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity, // 🔥 forces full-width
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // keeps system behavior
              spacing: 20,
              children: [
                Text(
                  'Choose a Vehicle',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),

                Expanded(
                  child: ListView.separated(
                    itemCount: vehicles.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];

                      return VehicleListitem(
                        vehicle: vehicle,
                        descriptionRequired: false,
                        colourRequired: false,
                        yearRequired: false,
                        tapAction: () {
                          setState(() {
                            _vehicleId = vehicle.id;
                            _vehicleCtrl.text = vehicle.regNum;
                          });
                          Navigator.pop(context);
                        },
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
