import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/ui/screens/initial_profile_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  bool _isResending = false; // Local state for resend button loading

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final userNotifier = ref.read(authProvider.notifier);
    final userState = ref.watch(authProvider);
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Default styling for Pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      // 1. SingleChildScrollView fixes layout issues on small screens/keyboard open
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
                          'Verify Email',
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Please enter the 6-digit code sent to\n$email',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // OTP Input
                        Center(
                          child: Pinput(
                            length: 6,
                            controller: _pinController,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyDecorationWith(
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Please enter full code';
                              }
                              return null;
                            },
                            // Auto-submit when last digit entered (Optional UX improvement)
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Resend Logic
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: _isResending
                                  ? null
                                  : () async {
                                      setState(() => _isResending = true);

                                      // Call Resend API
                                      await userNotifier.resendOtp(email);

                                      if (context.mounted) {
                                        setState(() => _isResending = false);
                                        showAppSnackBar(
                                          context: context,
                                          content: "Verification code resent!",
                                          isError: false,
                                        );
                                      }
                                    },
                              child: _isResending
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Resend'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Verify Button
                        FilledButton(
                          onPressed: userState.isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate())
                                    return;

                                  FocusScope.of(context).unfocus();

                                  final res = await userNotifier.verifyWithOtp(
                                    email,
                                    _pinController.text,
                                  );

                                  if (!context.mounted) return;

                                  if (res == null) {
                                    // Success
                                    showAppSnackBar(
                                      content: 'Email verified successfully!',
                                      isError: false,
                                      context: context,
                                    );

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const InitialProfileScreen(),
                                      ),
                                    );
                                  } else {
                                    // Error
                                    showAppSnackBar(
                                      content: res,
                                      isError: true,
                                      context: context,
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
                                  'VERIFY',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
