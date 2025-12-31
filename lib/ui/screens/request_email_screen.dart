import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestEmailScreen extends ConsumerStatefulWidget {
  const RequestEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<RequestEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              'Enter your email to reset password',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            textFormField(
                              controller: _emailCtrl,
                              label: 'Email',
                            ),

                            FilledButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final message = await userNotifier
                                    .sendPasswordResetEmail(_emailCtrl.text.trim());

                                if (!context.mounted) return;
                                showAppSnackBar(
                                  context: context,
                                  content: message.message,
                                  isError: !message.isSuccess,
                                );
                              },
                              child: Text('Send Link'),
                            ),

                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
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
