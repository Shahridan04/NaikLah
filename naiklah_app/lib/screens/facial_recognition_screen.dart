import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
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
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _cameraRequested = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeCamera() async {
    setState(() => _cameraRequested = true);

    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final cameras = await availableCameras();
        // Try to find front camera
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Camera error: $e')));
        }
      }
    } else {
      if (mounted) {
        setState(() => _cameraRequested = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
    }
  }

  void _startRecognition() async {
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
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Identity Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Verify your identity to secure your account',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Container(
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
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Facial Recognition',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Look at the camera and stay still',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      // Circular Camera Placeholder
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: _isCameraInitialized
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: constraints.maxWidth,
                                          height:
                                              constraints.maxWidth /
                                              _cameraController!
                                                  .value
                                                  .aspectRatio,
                                          child: CameraPreview(
                                            _cameraController!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.face,
                                        size: 100,
                                        color: Colors.blue.withOpacity(0.1),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                              : SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        _cameraRequested &&
                                            !_isCameraInitialized
                                        ? null
                                        : (_isCameraInitialized
                                              ? _startRecognition
                                              : _initializeCamera),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        _cameraRequested &&
                                            !_isCameraInitialized
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            _isCameraInitialized
                                                ? 'Capture Selfie'
                                                : 'Open Selfie Camera',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
