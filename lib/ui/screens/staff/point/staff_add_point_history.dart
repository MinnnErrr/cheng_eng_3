import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/staff_user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:cheng_eng_3/ui/widgets/profile_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PointHistoryAction {
  addition,
  deduction,
}

class StaffAddPointHistoryScreen extends ConsumerStatefulWidget {
  const StaffAddPointHistoryScreen({super.key});

  @override
  ConsumerState<StaffAddPointHistoryScreen> createState() =>
      _StaffAddPointHistoryScreenState();
}

class _StaffAddPointHistoryScreenState
    extends ConsumerState<StaffAddPointHistoryScreen> {
  String _email = "";

  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  PointHistoryAction _action = PointHistoryAction.addition;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = _email.isEmpty
        ? null
        : ref.watch(userProfileByEmailProvider(_email));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Membership Points'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search email...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (profileAsync != null)
                profileAsync.when(
                  data: (profile) {
                    return Column(
                      children: [
                        _userDetails(profile),
                        const SizedBox(height: 30),
                        _addRecordForm(),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            final notifier = ref.read(
                              pointHistoryProvider(profile.userId).notifier,
                            );

                            final message = await notifier.addRecord(
                              userId: profile.userId,
                              points: int.tryParse(_amountCtrl.text.trim()),
                              type: _action == PointHistoryAction.deduction
                                  ? PointType.use
                                  : PointType.earn,
                              reason: _reasonCtrl.text.trim(),
                              isIssuedByStaff: true,
                            );

                            if (!context.mounted) return;
                            showAppSnackBar(
                              context: context,
                              content: message.message,
                              isError: !message.isSuccess,
                            );

                            if (message.isSuccess) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Add Record"),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Text(
                      error.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userDetails(Profile profile) {
     final balance = ref.watch(totalPointsProvider(profile.userId));

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 20,
        children: [
          Text(
            'User Details',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          ProfileListitem(profile: profile),
          Text('Total Points: $balance pts', style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }

  Widget _addRecordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<PointHistoryAction>(
            initialValue: _action,
            decoration: const InputDecoration(labelText: "Action"),
            items: const [
              DropdownMenuItem(
                value: PointHistoryAction.addition,
                child: Text("Add Point"),
              ),
              DropdownMenuItem(
                value: PointHistoryAction.deduction,
                child: Text("Deduct Point"),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _action = value;
                });
              }
            },
            validator: (value) => value == null ? "Required" : null,
          ),

          const SizedBox(height: 20),

          textFormField(
            controller: _amountCtrl,
            label: "Point Amount",
            keyboardType: TextInputType.number,
          ),

          textFormField(
            controller: _reasonCtrl,
            label: "Reason",
          ),
        ],
      ),
    );
  }
}
