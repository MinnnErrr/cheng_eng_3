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

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final userNotifier = ref.read(authProvider.notifier);
    final userState = ref.watch(authProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: userState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                children: [
                  //logo
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/cheng_eng_logo.png',
                      height: screenSize.height * 0.3,
                    ),
                  ),

                  //login form
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.7,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 30,
                          children: [
                            Text(
                              'Verify Email',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Please enter the OTP sent to $email for verification.',
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 20,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Pinput(
                                    length: 6,
                                    controller: _pinController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text("Didn't receive the code?"),
                                    TextButton(
                                      onPressed: () =>
                                          userNotifier.resendOtp(email),
                                      child: Text(
                                        'Resend',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  final res = await userNotifier.verifyWithOtp(
                                    email,
                                    _pinController.text,
                                  );

                                  if (!context.mounted) return;
                                  if (res == null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InitialProfileScreen(),
                                      ),
                                    );
                                    showAppSnackBar(
                                      content: 'Email verified.',
                                      isError: false,
                                      context: context,
                                    );
                                  } else {
                                    showAppSnackBar(
                                      content: res,
                                      isError: true,
                                      context: context,
                                    );
                                  }
                                },
                                child: Text('Verify'),
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
    );
  }
}
