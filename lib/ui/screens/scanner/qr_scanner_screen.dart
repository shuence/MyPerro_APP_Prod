import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scanner_success_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);

class QRScannerScreen extends StatefulWidget {
  final String scanType; // 'caretaker' or 'family'

  const QRScannerScreen({super.key, required this.scanType});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simulateSuccessfulScan() {
    // Simulate scanning delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScannerSuccessScreen(
              scanType: widget.scanType,
              memberName: widget.scanType == 'caretaker' 
                  ? 'Rahul Kumar (Caretaker)'
                  : 'Priya Sharma (Family)',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: Text(
          'Scan QR Code - ${widget.scanType == 'caretaker' ? 'Caretaker' : 'Family Member'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _flashOn = !_flashOn);
            },
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
                ),
              ),
              child: CustomPaint(
                painter: _CameraGridPainter(),
              ),
            ),

            // Scanning overlay
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scanning frame
                  Container(
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(color: _brandOrange, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Corner brackets
                        ..._buildCornerBrackets(screenWidth * 0.7),
                        
                        // Scanning line animation
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              left: 20,
                              right: 20,
                              top: (screenWidth * 0.7 - 60) * _animation.value + 20,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: _brandOrange,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _brandOrange.withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    'Position the QR code within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    'The ${widget.scanType} will get access to track your pet',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Manual entry option
                    TextButton(
                      onPressed: () {
                        _showManualEntryDialog();
                      },
                      child: const Text(
                        'Enter code manually',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Simulate scan button (for demo)
                    ElevatedButton(
                      onPressed: _simulateSuccessfulScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Simulate Scan (Demo)'),
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

  List<Widget> _buildCornerBrackets(double frameSize) {
    const double bracketSize = 30;
    const double thickness = 4;
    
    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: CustomPaint(
          size: const Size(bracketSize, bracketSize),
          painter: _CornerBracketPainter(
            color: _brandOrange,
            thickness: thickness,
            corner: Corner.topLeft,
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: CustomPaint(
          size: const Size(bracketSize, bracketSize),
          painter: _CornerBracketPainter(
            color: _brandOrange,
            thickness: thickness,
            corner: Corner.topRight,
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: CustomPaint(
          size: const Size(bracketSize, bracketSize),
          painter: _CornerBracketPainter(
            color: _brandOrange,
            thickness: thickness,
            corner: Corner.bottomLeft,
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: CustomPaint(
          size: const Size(bracketSize, bracketSize),
          painter: _CornerBracketPainter(
            color: _brandOrange,
            thickness: thickness,
            corner: Corner.bottomRight,
          ),
        ),
      ),
    ];
  }

  void _showManualEntryDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter code manually',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.trim().isNotEmpty) {
                _simulateSuccessfulScan();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _brandOrange),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final Corner corner;

  _CornerBracketPainter({
    required this.color,
    required this.thickness,
    required this.corner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (corner) {
      case Corner.topLeft:
        canvas.drawLine(Offset(0, size.height * 0.7), const Offset(0, 0), paint);
        canvas.drawLine(const Offset(0, 0), Offset(size.width * 0.7, 0), paint);
        break;
      case Corner.topRight:
        canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width, 0), paint);
        canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height * 0.7), paint);
        break;
      case Corner.bottomLeft:
        canvas.drawLine(Offset(0, size.height * 0.3), Offset(0, size.height), paint);
        canvas.drawLine(Offset(0, size.height), Offset(size.width * 0.7, size.height), paint);
        break;
      case Corner.bottomRight:
        canvas.drawLine(Offset(size.width * 0.3, size.height), Offset(size.width, size.height), paint);
        canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height * 0.3), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 1; i < 3; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(size.width / 3 * i, 0),
        Offset(size.width / 3 * i, size.height),
        paint,
      );
      // Horizontal lines
      canvas.drawLine(
        Offset(0, size.height / 3 * i),
        Offset(size.width, size.height / 3 * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
