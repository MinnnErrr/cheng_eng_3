import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(authProvider.notifier);
    final userState = ref.watch(authProvider);
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      // 1. Safe Layout for Keyboard
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              // --- TOP: Logo Section ---
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/cheng_eng_logo.png',
                    height: screenSize.height * 0.25,
                  ),
                ),
              ),

              // --- BOTTOM: Form Section ---
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Set New Password',
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your email has been verified. Please create a new strong password.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Password Input
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: InputDecoration(
                            label: Text('New Password'),
                            hintText: 'Enter your new password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),

                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],

                          // Visibility Toggle
                        ),

                        const SizedBox(height: 40),

                        // Update Button
                        FilledButton(
                          onPressed: userState.isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate())
                                    return;

                                  // Hide Keyboard
                                  FocusScope.of(context).unfocus();

                                  // 1. Update the password
                                  // (Since we are authenticated via link, this works)
                                  final message = await userNotifier
                                      .resetPassword(
                                        _passwordCtrl.text.trim(),
                                      );

                                  if (!context.mounted) return;

                                  showAppSnackBar(
                                    context: context,
                                    content: message.message,
                                    isError: !message.isSuccess,
                                  );

                                  if (message.isSuccess) {
                                    // 2. IMPORTANT: Sign out to kill the magic link session
                                    await userNotifier.signOut();

                                    if (!context.mounted) return;

                                    // 3. Redirect to Login to force fresh authentication
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                          child: userState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'UPDATE PASSWORD',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Cancel Button
                        SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // If they cancel, we MUST sign them out so they
                              // don't stay logged in via the temporary magic link.
                              await ref.read(authProvider.notifier).signOut();

                              if (!context.mounted) return;

                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('CANCEL'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
