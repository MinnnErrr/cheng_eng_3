import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InitialProfileScreen extends ConsumerStatefulWidget {
  const InitialProfileScreen({super.key});

  @override
  ConsumerState<InitialProfileScreen> createState() =>
      _InitialProfileScreenState();
}

class _InitialProfileScreenState extends ConsumerState<InitialProfileScreen> {
  final List<String> _genderSelection = ['Male', 'Female'];
  final _birthdayFormatter = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _dialCode = '+60';
  String _countryCode = 'MY';
  String? _phoneNum;
  String? _gender;
  DateTime? _birthday;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final user = ref.watch(authProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return profile.when(
      data: (profile) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Create Profile',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text('Start your car service journey with us'),
                      ],
                    ),
                    textFormField(
                      label: 'Email',
                      initialValue: user.value?.email,
                      enabled: false,
                    ),
                    textFormField(label: 'Name', controller: _nameController),
                    IntlPhoneField(
                      initialCountryCode: _countryCode,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      onChanged: (value) {
                        setState(() {
                          _dialCode = value.countryCode;
                          _countryCode = value.countryISOCode;
                          _phoneNum = value.number;
                        });
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Gender'),
                      initialValue: _gender,
                      onChanged: (value) => setState(() {
                        if (value != null) {
                          _gender = value;
                        }
                      }),
                      items: _genderSelection.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    textFormField(
                      validationRequired: false,
                      controller: _dateController,
                      label: 'Date of Birth',
                      readOnly: true,
                      suffix: IconButton(
                        onPressed: () async {
                          final date = await datePicker(_birthday, context);
                          if (date != null) {
                            setState(() {
                              _birthday = date;
                              _dateController.text = _birthdayFormatter.format(
                                date,
                              );
                            });
                          }
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final success = await profileNotifier.createProfile(
                          name: _nameController.text.trim(),
                          email: user.value!.email!,
                          phoneNum: _phoneNum!,
                          countryCode: _countryCode,
                          dialCode: _dialCode,
                          gender: _gender!,
                          birthday: _birthday,
                        );

                        if (!context.mounted) return;
                        showAppSnackBar(
                          context: context,
                          content: success == true
                              ? 'Profile successfully created'
                              : 'Failed to create profile',
                          isError: !success,
                        );

                        if (!success) return;

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const Main()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        profile != null ? 'Update Profile' : 'Create Profile',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      ),
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
