import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);

class ShareLinkScreen extends StatelessWidget {
  const ShareLinkScreen({super.key});

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
          'Share link',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR Code placeholder
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code,
                    size: 200,
                    color: _grey700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Scan QR with your Family Member',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _grey700,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Share Link Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle share link
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Share Link',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _grey900
      ..style = PaintingStyle.fill;

    final blockSize = size.width / 25;
    
    // Create a simple QR code pattern
    final qrPattern = [
      [1,1,1,1,1,1,1,0,1,0,0,1,0,0,1,0,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,1,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,1,1,0,1],
      [1,0,1,1,1,0,1,0,0,1,1,0,1,1,0,0,1,0,1,1,1,0,1],
      [1,0,1,1,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,1,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1],
      [0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0],
      [1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
      [1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
      [1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
      [1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0],
      [1,1,1,1,1,1,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0],
      [1,0,1,1,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1],
      [1,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0],
      [1,0,1,1,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0],
      [1,1,1,1,1,1,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1],
    ];

    for (int row = 0; row < qrPattern.length; row++) {
      for (int col = 0; col < qrPattern[row].length; col++) {
        if (qrPattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * blockSize,
              row * blockSize,
              blockSize,
              blockSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
