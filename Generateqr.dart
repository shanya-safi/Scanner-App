import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> with SingleTickerProviderStateMixin {
  String qrData = "";
  final TextEditingController qrdataFeed = TextEditingController();

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
    _buttonAnimation = CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    qrdataFeed.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Widget animatedButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.reverse(),
      onTapUp: (_) {
        _buttonController.forward();
        onTap();
      },
      onTapCancel: () => _buttonController.forward(),
      child: ScaleTransition(
        scale: _buttonAnimation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate QR Code", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
        centerTitle: true,
      ),
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
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            elevation: 18,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade300.withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      child: qrData.isEmpty
                          ? Text(
                              "No QR Code Generated",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 220,
                            ),
                    ),

                    SizedBox(height: 30),

                    Text(
                      "Enter data to generate QR Code:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade900,
                      ),
                    ),

                    SizedBox(height: 14),

                    TextField(
                      controller: qrdataFeed,
                      cursorColor: Colors.indigo.shade700,
                      decoration: InputDecoration(
                        hintText: "Enter your text or link here...",
                        filled: true,
                        fillColor: Colors.indigo.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.indigo.shade700, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.indigo.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.indigo.shade900, width: 2),
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.indigo.shade900),
                    ),

                    SizedBox(height: 30),

                    animatedButton(
                      onTap: () {
                        if (qrdataFeed.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter some data")),
                          );
                        } else {
                          setState(() {
                            qrData = qrdataFeed.text.trim();
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(30),
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
                            Icon(Icons.qr_code, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              "Generate QR Code",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
