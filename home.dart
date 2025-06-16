import 'package:flutter/material.dart';
import 'generateqr.dart';
import 'scanqr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget animatedButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        onTap();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(scale: _animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.indigo.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 80,
                    color: Colors.indigo.shade700,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "QuickScan",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Scan QR Button
                  animatedButton(
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ScanQR()),
                        ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade700,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade300.withOpacity(0.6),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            "Scan QR Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Generate QR Button
                  animatedButton(
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => GenerateQR()),
                        ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.indigo.shade700,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code, color: Colors.indigo.shade700),
                          SizedBox(width: 12),
                          Text(
                            "Generate QR Code",
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
