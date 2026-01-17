import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestEmailScreen extends ConsumerStatefulWidget {
  const RequestEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestEmailScreenState();
}

class _RequestEmailScreenState extends ConsumerState<RequestEmailScreen> {
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/cheng_eng_logo.png',
                      height: screenSize.height * 0.25,
                    ),
                  ],
                ),
              ),

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
                          'Reset Password',
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Enter your email address and we will send you a link to reset your password.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            label: Text('Email Address'),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                        ),

                        const SizedBox(height: 30),

                        FilledButton(
                          onPressed: userState.isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()){
                                    return;
                                  }
                                  
                                  FocusScope.of(context).unfocus();

                                  final message = await userNotifier
                                      .sendPasswordResetEmail(
                                        _emailCtrl.text.trim(),
                                      );

                                  if (!context.mounted) return;

                                  showAppSnackBar(
                                    context: context,
                                    content: message.message,
                                    isError: !message.isSuccess,
                                  );

                                  if (message.isSuccess) {
                                    Navigator.pop(context);
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
                                  'SEND LINK',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
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
