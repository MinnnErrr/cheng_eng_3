import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/ui/profile/notifiers/profile_notifier.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/utils/datepicker.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/textformfield.dart';
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

  bool _isSubmitting = false;

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (profile) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Create Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your car service journey with us',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 40),

                    textFormField(
                      label: 'Email',
                      initialValue: user.value?.email ?? '',
                      enabled: false,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 20),

                    textFormField(
                      label: 'Full Name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 20),

                    IntlPhoneField(
                      initialCountryCode: _countryCode,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Phone Number',
                      ),
                      onChanged: (phone) {
                        setState(() {
                          _dialCode = phone.countryCode;
                          _countryCode = phone.countryISOCode;
                          _phoneNum = phone.number;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      decoration: inputDecoration.copyWith(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      initialValue: _gender,
                      items: _genderSelection
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _gender = value),
                      validator: (value) => value == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),

                    textFormField(
                      validationRequired: false,
                      controller: _dateController,
                      label: 'Date of Birth',
                      readOnly: true,
                      prefixIcon: const Icon(Icons.cake_outlined),
                      suffix: const Icon(Icons.calendar_month),
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

                    FilledButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() => _isSubmitting = true);

                              final success = await profileNotifier.createProfile(
                                name: _nameController.text.trim(),
                                email: user.value?.email ?? '',
                                phoneNum:
                                    _phoneNum!, 
                                countryCode: _countryCode,
                                dialCode: _dialCode,
                                gender: _gender!, 
                                birthday: _birthday,
                              );

                              if (context.mounted) {
                                setState(() => _isSubmitting = false);

                                if (success) {
                                  showAppSnackBar(
                                    context: context,
                                    content: 'Profile created successfully!',
                                    isError: false,
                                  );

                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => const Main(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  showAppSnackBar(
                                    context: context,
                                    content:
                                        'Failed to create profile. Please try again.',
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
                          : const Text(
                              'CREATE PROFILE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
