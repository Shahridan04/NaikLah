import 'package:flutter/material.dart';
import 'facial_recognition_screen.dart';

class ICScanScreen extends StatefulWidget {
  const ICScanScreen({super.key});

  @override
  State<ICScanScreen> createState() => _ICScanScreenState();
}

class _ICScanScreenState extends State<ICScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startScanning() async {
    setState(() {
      _isScanning = true;
    });
    _controller.repeat(reverse: true);

    // Simulate scanning for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FacialRecognitionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Identity Verification',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verify your identity to secure your account',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.blue,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Scan Your IC',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Place your Identity Card in front of the camera for scanning',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Position your IC here',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Scan Frame Overlay
                              _buildScanFrame(),
                              // Scanning Line Animation
                              if (_isScanning)
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Positioned(
                                      top:
                                          _controller.value *
                                          (MediaQuery.of(context).size.height *
                                              0.3), // Approximate height
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.withOpacity(0),
                                              Colors.blue,
                                              Colors.blue.withOpacity(0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isScanning ? null : _startScanning,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isScanning
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Start Scanning',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Facial recognition will be activated automatically after IC scan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanFrame() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: ScanFramePainter(),
        );
      },
    );
  }
}

class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double cornerLength = 30;
    const double padding = 30;

    Rect rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - (padding * 2),
      size.height - (padding * 2),
    );

    // Top Left
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left, rect.top + cornerLength),
      paint,
    );

    // Top Right
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right - cornerLength, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Bottom Left
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left, rect.bottom - cornerLength),
      paint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right - cornerLength, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
