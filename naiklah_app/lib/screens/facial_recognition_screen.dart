import 'package:flutter/material.dart';
import 'home_screen.dart';

class FacialRecognitionScreen extends StatefulWidget {
  const FacialRecognitionScreen({super.key});

  @override
  State<FacialRecognitionScreen> createState() =>
      _FacialRecognitionScreenState();
}

class _FacialRecognitionScreenState extends State<FacialRecognitionScreen> {
  bool _isProcessing = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startRecognition();
  }

  void _startRecognition() async {
    // Simulate initial delay to "find face"
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isProcessing = true;
      });
    }

    // Simulate progress bar
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _progress = i / 100;
        });
      }
    }

    // Success delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Facial Recognition',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Look at the camera and stay still',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      // Circular Camera Placeholder
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.face,
                              size: 140,
                              color: Colors.blue.withOpacity(0.1),
                            ),
                            // Scanning frame for face
                            _buildCircularFrame(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Processing Status
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isProcessing
                              ? Column(
                                  key: const ValueKey('processing'),
                                  children: [
                                    LinearProgressIndicator(
                                      value: _progress,
                                      backgroundColor: Colors.blue.shade50,
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Processing facial recognition...',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'Finding face...',
                                  key: ValueKey('finding'),
                                  style: TextStyle(color: Colors.grey),
                                ),
                        ),
                      ),
                      const SizedBox(height: 48),
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

  Widget _buildCircularFrame() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );
  }
}
