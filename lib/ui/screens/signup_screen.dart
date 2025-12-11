import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/screens/verify_email_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
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
    final userNotifier = ref.read(authProvider.notifier);
    final userState = ref.watch(authProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: 
      userState.isLoading ?
      const Center(child: CircularProgressIndicator(),):
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                alignment: AlignmentGeometry.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: screenSize.width,
                  height: screenSize.height * 0.7,
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
                            'Sign Up',
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
                        ),
                        textFormField(
                          obscure: _obscurePassword,
                          controller: _passwordController,
                          label: 'Password',
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            final res = await userNotifier.signUp(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (!context.mounted) return;

                            if (res == null) {
                              showAppSnackBar(
                                content:
                                    'Account created. Please verify you email.',
                                isError: false,
                                context: context,
                              );

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => VerifyEmailScreen(
                                    email: _emailController.text.trim(),
                                  ),
                                ),
                              );
                            } else {
                              showAppSnackBar(
                                content: res,
                                isError: true,
                                context: context,
                              );
                            }
                          },
                          child: Text('Sign Up'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an account"),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              ),
                              child: Text('Log In Now'),
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
      ),
    );
  }
}
