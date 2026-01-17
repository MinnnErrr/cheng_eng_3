import 'dart:async';
import 'dart:convert';

import 'package:cheng_eng_3/utils/snackbar.dart';
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
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcode = capture.barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() => _isProcessing = true);

    try {
      final String raw = barcode.rawValue!;
      final Map<String, dynamic> data = jsonDecode(raw);

      if (!data.containsKey("userId") ||
          !data.containsKey("redeemedRewardId")) {
        throw const FormatException("Missing required data fields");
      }

      final userId = data["userId"];
      final redeemedRewardId = data["redeemedRewardId"];

      if (mounted) {
        Navigator.pop(context, {
          "userId": userId,
          "redeemedRewardId": redeemedRewardId,
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context: context,
          content: 'Invalid QR Code format',
          isError: true,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _isProcessing = false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan User QR"),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: _handleBarcode,
          ),
          CustomPaint(
            painter: ScannerOverlay(scanWindow),
            child: const SizedBox.expand(),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              _isProcessing
                  ? "Processing..."
                  : "Align QR code within the frame",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
    canvas.drawPath(backgroundPath, Paint()..color = Colors.black54);
    canvas.drawPath(cutoutPath, backgroundPaint);
    canvas.restore();

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
