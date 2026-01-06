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

  // _userId can be null if we search manually (we get it from the reward data later)
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

  void _onManualSearch() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    final text = _searchController.text.trim();

    if (text.isNotEmpty) {
      setState(() {
        _redeemedId = text;
        _userId = null; // Reset user ID, let the content widget fetch it
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show content if we have a Reward ID (User ID is optional at this stage)
    final bool showContent = _redeemedId != null && _redeemedId!.isNotEmpty;

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
                    child: SearchBar(
                      controller: _searchController,
                      hintText: "Enter Reward ID",
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _onManualSearch(),

                      // Leading Icon: Search
                      leading: const Icon(Icons.search),

                      // Trailing Icons: Clear & Scan
                      trailing: [
                        // Clear Button (Only show if text exists)
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _redeemedId = null;
                                _userId = null;
                              });
                            },
                          ),
                      ],
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Scan Button
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(56, 56),
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
                  userId: _userId,
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
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
            "Scan a QR code or enter the\nReward ID to verify.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
