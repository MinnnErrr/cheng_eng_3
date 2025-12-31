import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_scanner_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_claim_content.dart';
import 'package:flutter/material.dart';

class StaffClaimRewardScreen extends StatefulWidget {
  const StaffClaimRewardScreen({super.key});

  @override
  State<StaffClaimRewardScreen> createState() => _StaffClaimRewardScreenState();
}

class _StaffClaimRewardScreenState extends State<StaffClaimRewardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _userId;
  String? _redeemedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onScanResult(Map<String, dynamic> result) {
    setState(() {
      _userId = result['userId'];
      _redeemedId = result['redeemedRewardId'];
      _searchController.text = _redeemedId ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine if we have valid data to show content
    final bool showContent = _userId != null && _redeemedId != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Claim Reward'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // --- 1. Search / Scan Section ---
              Row(
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      readOnly: true, // Keep scan-only logic
                      decoration: InputDecoration(
                        hintText: "Reward ID...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        // Use White/Light Grey background for input
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Scan Button (Styled: Yellow/Black)
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary, // Yellow
                      foregroundColor: theme.colorScheme.onPrimary, // Black
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(
                        56,
                        56,
                      ), // Square shape matching input height
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StaffClaimRewardScannerScreen(),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        _onScanResult(result);
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 28),
                    tooltip: "Scan QR Code",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- 2. Results or Empty State ---
              if (showContent)
                RewardClaimContent(
                  userId: _userId!,
                  redeemedId: _redeemedId!,
                )
              else
                _buildEmptyState(theme),
            ],
          ),
        ),
      ),
    );
  }

  // A clean, simple empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_2,
              size: 60,
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Please scan the customer's QR code\nto verify and claim the reward.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
