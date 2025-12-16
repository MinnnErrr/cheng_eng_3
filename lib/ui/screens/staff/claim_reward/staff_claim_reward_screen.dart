
import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_scanner_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_claim_content.dart';
import 'package:flutter/material.dart';

class StaffClaimRewardScreen extends StatefulWidget {
  const StaffClaimRewardScreen({super.key});

  @override
  State<StaffClaimRewardScreen> createState() => _StaffClaimRewardScreenState();
}

class _StaffClaimRewardScreenState extends State<StaffClaimRewardScreen> {
  // We only need simple state here, no need for ConsumerState yet
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Reward'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // --- Search / Scan Section ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Reward ID...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Optional: Allow manual entry if needed (logic required to map ID to User)
                      readOnly: true, 
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
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
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Results Section (Extracted Widget) ---
              // Only show if we have the necessary IDs
              if (_userId != null && _redeemedId != null)
                RewardClaimContent(
                  userId: _userId!,
                  redeemedId: _redeemedId!,
                )
              else
                Column(
                  children: [
                    const SizedBox(height: 50),
                    Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    const Text("Scan a customer's QR code to proceed"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}