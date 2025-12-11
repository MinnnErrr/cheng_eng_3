import 'package:cheng_eng_3/ui/screens/customer/towing/towing_submit_screen.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TowingMapScreen extends ConsumerStatefulWidget {
  const TowingMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TowingMapScreenState();
}

class _TowingMapScreenState extends ConsumerState<TowingMapScreen> {
  final _addressCtrl = TextEditingController();
  final _latitudeCtrl = TextEditingController();
  final _longitudeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a location'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                textFormField(controller: _addressCtrl, label: 'address'),
                textFormField(controller: _latitudeCtrl, label: 'latitude'),
                textFormField(controller: _longitudeCtrl, label: 'longitude'),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TowingSubmitScreen(
                        address: _addressCtrl.text.trim(),
                        latitude: double.parse(_latitudeCtrl.text.trim()),
                        longitude: double.parse(_longitudeCtrl.text.trim()),
                      ),
                    ),
                  ),
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
