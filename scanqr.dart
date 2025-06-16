import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';


class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with SingleTickerProviderStateMixin {
  String qrCodeResult = "Not Yet Scanned";
  bool isScanned = false;

  final MobileScannerController controller = MobileScannerController();
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid or unsupported link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget animatedButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.reverse(),
      onTapUp: (_) {
        _buttonController.forward();
        onTap();
      },
      onTapCancel: () => _buttonController.forward(),
      child: ScaleTransition(scale: _buttonAnimation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo.shade700;
    final Color primaryLight = Colors.indigo.shade50;

    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        title: Text("Scan QR Code", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Align the QR code inside the frame to scan",
              style: TextStyle(
                fontSize: 18,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: primaryColor, width: 4),
                ),
                child: MobileScanner(
                  controller: controller,
                  onDetect: (barcodeCapture) {
                    final barcodes = barcodeCapture.barcodes;
                    for (final barcode in barcodes) {
                      final code = barcode.rawValue;
                      if (!isScanned && code != null) {
                        setState(() {
                          qrCodeResult = code;
                          isScanned = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Scanned: $code'),
                            backgroundColor: primaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        _launchURL(code); // ✅ Open scanned link
                        break;
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 12,
              color: primaryLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Column(
                  children: [
                    Text(
                      "Scan Result",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 14),
                    SelectableText(
                      qrCodeResult,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            animatedButton(
              onTap: () {
                setState(() {
                  isScanned = false;
                  qrCodeResult = "Not Yet Scanned";
                });
                controller.start();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 48),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.6),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
                    SizedBox(width: 16),
                    Text(
                      "Scan Again",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}