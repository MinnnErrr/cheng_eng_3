import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileUpdateScreen extends ConsumerStatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  ConsumerState<ProfileUpdateScreen> createState() =>
      _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends ConsumerState<ProfileUpdateScreen> {
  final List<String> _genderSelection = ['Male', 'Female'];
  final _birthdayFormatter = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;
  bool _isSubmitting = false;

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
    final profileAsync = ref.watch(profileProvider);
    final user = ref.watch(authProvider);
    final profileNotifier = ref.read(profileProvider.notifier);
    final theme = Theme.of(context);

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (profile) {
        if (!_initialized && profile != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _nameController.text = profile.name;
                _dialCode = profile.dialCode;
                _countryCode = profile.countryCode;
                _phoneNum = profile.phoneNum;
                _gender = profile.gender;
                _birthday = profile.birthday;
                if (_birthday != null) {
                  _dateController.text = _birthdayFormatter.format(_birthday!);
                }
                _initialized = true;
              });
            }
          });
        }

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Text(profile != null ? 'Edit Profile' : 'Create Profile'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email (Read Only)
                    textFormField(
                      label: 'Email Address',
                      initialValue: profile?.email ?? user.value?.email ?? '',
                      enabled: false,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    textFormField(
                      label: 'Full Name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 20),

                    // Phone Number
                    IntlPhoneField(
                      initialCountryCode: _countryCode,
                      initialValue: _phoneNum,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Phone Number',
                        counterText: '',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _dialCode = value.countryCode;
                          _countryCode = value.countryISOCode;
                          _phoneNum = value.number;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      items: _genderSelection.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _gender = value),
                      validator: (val) => val == null ? 'required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Birthday
                    textFormField(
                      controller: _dateController,
                      label: 'Date of Birth',
                      readOnly: true,
                      validationRequired: false,
                      prefixIcon: const Icon(Icons.cake_outlined),
                      suffix: Icon(Icons.calendar_month),
                      onTap: () async {
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
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
                    FilledButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (_phoneNum == null || _phoneNum!.isEmpty) {
                                showAppSnackBar(
                                  context: context,
                                  content: 'Please enter a phone number',
                                  isError: true,
                                );
                                return;
                              }

                              setState(() => _isSubmitting = true);

                              bool success;
                              if (profile == null) {
                                success = await profileNotifier.createProfile(
                                  name: _nameController.text.trim(),
                                  email: user.value?.email ?? '',
                                  phoneNum: _phoneNum!,
                                  countryCode: _countryCode,
                                  dialCode: _dialCode,
                                  gender: _gender!,
                                  birthday: _birthday,
                                );
                              } else {
                                success = await profileNotifier.updateProfile(
                                  name: _nameController.text.trim(),
                                  phoneNum: _phoneNum!,
                                  countryCode: _countryCode,
                                  dialCode: _dialCode,
                                  gender: _gender!,
                                  birthday: _birthday,
                                );
                              }

                              if (context.mounted) {
                                setState(() => _isSubmitting = false);

                                if (success) {
                                  showAppSnackBar(
                                    context: context,
                                    content: profile == null
                                        ? 'Profile created successfully'
                                        : 'Profile updated successfully',
                                    isError: false,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  showAppSnackBar(
                                    context: context,
                                    content: 'Failed to save profile',
                                    isError: true,
                                  );
                                }
                              }
                            },
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              profile != null
                                  ? 'SAVE CHANGES'
                                  : 'CREATE PROFILE',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
