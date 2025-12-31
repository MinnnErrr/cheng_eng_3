import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/screens/request_email_screen.dart';
import 'package:cheng_eng_3/ui/screens/signup_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authProvider);
    final userNotifier = ref.read(authProvider.notifier);
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 30,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: Text(
                                'Log In',
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            textFormField(
                              controller: _emailController,
                              label: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 10,
                              children: [
                                textFormField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  obscure: _obscurePassword,
                                  suffix: GestureDetector(
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
                                TextButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestEmailScreen(),
                                    ),
                                  ),
                                  child: Text('Forget password?'),
                                ),
                              ],
                            ),
                            FilledButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                setState(() {});

                                final res = await userNotifier.signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                                if (!context.mounted) return;

                                //error
                                if (res != null) {
                                  showAppSnackBar(
                                    content: res,
                                    isError: true,
                                    context: context,
                                  );
                                  return;

                                  // if (res.contains('Email not verified')) {
                                  //   await userNotifier.resendOtp(
                                  //     _emailController.text.trim(),
                                  //   );

                                  //   if (!context.mounted) return;
                                  //   Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //       builder: (context) => VerifyEmailScreen(
                                  //         email: _emailController.text.trim(),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }
                                }

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const Main(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text('Log In'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ),
                                  ),
                                  child: Text('Register Now'),
                                ),
                              ],
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
