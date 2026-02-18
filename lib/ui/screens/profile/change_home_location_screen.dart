import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);

class ChangeHomeLocationScreen extends StatelessWidget {
  const ChangeHomeLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
        ),
        title: const Text(
          'Change Home Location',
          style: TextStyle(
            color: _grey900,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Map container
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Map placeholder with roads pattern
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFE8F5E8),
                    ),
                    child: CustomPaint(
                      painter: _MapPainter(),
                      size: Size.infinite,
                    ),
                  ),
                  // Location markers
                  Positioned(
                    top: 60,
                    right: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'SKEI - Smt. Kamulabai\nEducational Institution',
                        style: TextStyle(
                          fontSize: 10,
                          color: _grey700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Orange location pin
                  const Positioned(
                    bottom: 80,
                    left: 100,
                    child: Icon(
                      Icons.location_on,
                      color: _brandOrange,
                      size: 32,
                    ),
                  ),
                  // Map data attribution
                  const Positioned(
                    bottom: 8,
                    right: 8,
                    child: Text(
                      'Map data ©2024',
                      style: TextStyle(
                        fontSize: 10,
                        color: _grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Location info section
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _grey900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Phirangipuram, Andhra Pradesh 522438',
                    style: TextStyle(
                      fontSize: 14,
                      color: _grey700,
                    ),
                  ),
                  const Spacer(),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
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

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0D0D0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw road patterns
    final path = Path();
    
    // Horizontal roads
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.3);
    
    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    
    // Vertical roads
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.2, size.height);
    
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width * 0.7, size.height);
    
    // Curved roads
    path.moveTo(size.width * 0.1, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.4,
      size.width * 0.9, size.height * 0.2,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
