import 'dart:convert';

import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class StaffClaimRewardScannerScreen extends StatefulWidget {
  const StaffClaimRewardScannerScreen({super.key});

  @override
  State<StaffClaimRewardScannerScreen> createState() =>
      _StaffClaimRewardScannerScreenState();
}

class _StaffClaimRewardScannerScreenState
    extends State<StaffClaimRewardScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;

          scanned = true;

          final barcode = capture.barcodes.first;

          if (barcode.rawValue != null) {
            String raw = barcode.rawValue!;
            try {
              final data = jsonDecode(raw);

              final userId = data["userId"];
              final redeemedRewardId = data["redeemedRewardId"];

              Navigator.pop(context, {
                "userId": userId,
                "redeemedRewardId": redeemedRewardId,
              });
            } catch (e) {
              showAppSnackBar(
                context: context,
                content: 'Invalid QR format',
                isError: true,
              );
            }
          }
        },
      ),
    );
  }
}
