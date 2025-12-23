import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
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
  // Use a controller for search so we can clear it if needed
  final _searchCtrl = TextEditingController();

  String _searchedEmail = ""; // Store the committed search term
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  PointHistoryAction _action = PointHistoryAction.addition;
  bool _isLoading = false; // Prevent double taps

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _performSearch() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      _searchedEmail = _searchCtrl.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only watch the provider if we actually have an email to search
    final profileAsync = _searchedEmail.isEmpty
        ? null
        : ref.watch(userProfileByEmailProvider(_searchedEmail));

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
              // --- Search Bar ---
              TextField(
                controller: _searchCtrl,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) =>
                    _performSearch(), // Optimization: Search on Enter
                decoration: InputDecoration(
                  hintText: "Search customer email...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Results Section ---
              if (profileAsync != null)
                profileAsync.when(
                  data: (profile) {
                    if (profile == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'No user found',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _userDetails(profile),
                        const SizedBox(height: 30),

                        _addRecordForm(),
                        const SizedBox(height: 30),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    await _submitForm(profile.userId);
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : const Text("Add Record"),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Error finding user: $error",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),

              if (_searchedEmail.isNotEmpty && profileAsync == null)
                const Center(child: Text("Please enter an email")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(String userId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 1. We assume this won't crash
    final notifier = ref.read(pointHistoryProvider(userId).notifier);
    final points = int.tryParse(_amountCtrl.text.trim()) ?? 0;

    Message message;

    // 2. We trust these methods to return a Message, not throw
    if (_action == PointHistoryAction.deduction) {
      message = await notifier.deductPoints(
        userId: userId,
        pointsToDeduct: points,
        reason: _reasonCtrl.text.trim(),
        isIssuedByStaff: true,
      );
    } else {
      message = await notifier.addPoints(
        userId: userId,
        points: points,
        reason: _reasonCtrl.text.trim(),
        isIssuedByStaff: true,
      );
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    // 3. Handle the result (Success OR Failure) here
    showAppSnackBar(
      context: context,
      content: message.message,
      isError: !message.isSuccess,
    );

    if (message.isSuccess) {
      _amountCtrl.clear();
      _reasonCtrl.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Widget _userDetails(Profile profile) {
    // FIX: AsyncValue handling.
    final balanceAsync = ref.watch(totalPointsProvider(profile.userId));

    // Extract actual value, defaulting to 0 if loading/error
    final int currentBalance = balanceAsync.value ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer, // Use Container color for better contrast
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Details',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 10),

          // Assuming ProfileListitem handles its own styling,
          // ensure it looks good on primaryContainer background
          ProfileListitem(email: profile.email, name: profile.name, dialCode: profile.dialCode, phoneNum: profile.phoneNum, gender: profile.gender),

          const SizedBox(height: 10),
          Divider(
            color: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Balance:",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '$currentBalance pts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
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
            initialValue: _action, // FIX: Use value instead of initialValue
            decoration: const InputDecoration(labelText: "Action"),
            items: const [
              DropdownMenuItem(
                value: PointHistoryAction.addition,
                child: Text("Add Points"),
              ),
              DropdownMenuItem(
                value: PointHistoryAction.deduction,
                child: Text("Deduct Points"),
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

          const SizedBox(height: 20),

          textFormField(
            controller: _reasonCtrl,
            label: "Reason / Remarks",
            minLines: 2,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
