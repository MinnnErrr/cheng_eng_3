import 'package:cheng_eng_3/colorscheme/colorscheme.dart'; // Ensure this import is here for textYellow
import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  final _searchCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _searchedEmail = "";
  PointHistoryAction _action = PointHistoryAction.addition;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _performSearch() {
    FocusScope.of(context).unfocus();
    if (_searchCtrl.text.trim().isEmpty) return;
    setState(() {
      _searchedEmail = _searchCtrl.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = _searchedEmail.isEmpty
        ? null
        : ref.watch(userProfileByEmailProvider(_searchedEmail));

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Points')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. SEARCH BAR ---
              TextField(
                controller: _searchCtrl,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: "Search customer email...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- 2. RESULTS ---
              if (profileAsync != null)
                profileAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (profile) {
                    if (profile == null) return _buildNotFoundState();
                    return _buildContent(profile, theme);
                  },
                ),

              if (_searchedEmail.isNotEmpty && profileAsync == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Please enter an email",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildContent(Profile profile, ThemeData theme) {
    final balanceAsync = ref.watch(totalPointsProvider(profile.userId));
    final int currentBalance = balanceAsync.value ?? 0;
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- A. CUSTOMER DETAILS CARD (Matches Order Summary Card) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Customer Details",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        profile.role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow("Name", profile.name),
                _buildInfoRow("Email", profile.email),
                _buildInfoRow(
                  "Phone",
                  "${profile.dialCode} ${profile.phoneNum}",
                ),
                _buildInfoRow(
                  "DOB",
                  profile.birthday != null
                      ? dateFormatter.format(profile.birthday!)
                      : "-",
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$currentBalance pts',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        // Assuming textYellow is defined globally or imported
                        color: textYellow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- B. ACTION SELECTION (Matches Delivery Method Cards) ---
          Text(
            'Transaction Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionOptionCard(
                  label: "Add Points",
                  icon: Icons.add_circle_outline,
                  isSelected: _action == PointHistoryAction.addition,
                  activeColor: Colors.green,
                  onTap: () =>
                      setState(() => _action = PointHistoryAction.addition),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionOptionCard(
                  label: "Deduct Points",
                  icon: Icons.remove_circle_outline,
                  isSelected: _action == PointHistoryAction.deduction,
                  activeColor: Colors.red,
                  onTap: () =>
                      setState(() => _action = PointHistoryAction.deduction),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // --- C. FORM INPUTS ---
          Text(
            'Transaction Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          textFormField(
            controller: _amountCtrl,
            label: "Points Amount",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          textFormField(
            controller: _reasonCtrl,
            label: "Reason / Remarks",
            minLines: 2,
            maxLines: 3,
          ),

          const SizedBox(height: 30),

          // --- D. SUBMIT BUTTON ---
          SizedBox(
            width: double.infinity,
            height: 54, // Matching Checkout Button Height
            child: FilledButton(
              onPressed: _isLoading ? null : () => _submitForm(profile.userId),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _action == PointHistoryAction.addition
                          ? "CONFIRM ADDITION"
                          : "CONFIRM DEDUCTION",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _submitForm(String userId) async {
    if (!_formKey.currentState!.validate()) return;

    if (_action == PointHistoryAction.deduction) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Confirm Deduction"),
          content: Text("Deduct ${_amountCtrl.text} points from this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),

              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _isLoading = true);

    final notifier = ref.read(pointHistoryProvider(userId).notifier);
    final points = int.parse(_amountCtrl.text.trim());

    final Message message = _action == PointHistoryAction.deduction
        ? await notifier.deductPoints(
            userId: userId,
            pointsToDeduct: points,
            reason: _reasonCtrl.text.trim(),
            isIssuedByStaff: true,
          )
        : await notifier.addPoints(
            userId: userId,
            points: points,
            reason: _reasonCtrl.text.trim(),
            isIssuedByStaff: true,
          );

    if (!mounted) return;
    setState(() => _isLoading = false);

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

  Widget _buildNotFoundState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Text(
            'No user found with that email.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPER: Action Selection Card ---
// Exact replica of _DeliveryOptionCard styling logic
class _ActionOptionCard extends StatelessWidget {
  const _ActionOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Background Color
    final bgColor = isSelected
        ? activeColor.withValues(alpha: 0.1)
        : theme.colorScheme.surface;

    // Border Color
    final borderColor = isSelected ? activeColor : theme.colorScheme.outline;

    // Content Color
    final contentColor = isSelected
        ? activeColor
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: contentColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
