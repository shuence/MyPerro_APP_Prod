import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'share_link_detail_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey300 = Color(0xFFE9E9E9);

class ShareLinkScreen extends StatefulWidget {
  final String petName;

  const ShareLinkScreen({super.key, required this.petName});

  @override
  State<ShareLinkScreen> createState() => _ShareLinkScreenState();
}

class _ShareLinkScreenState extends State<ShareLinkScreen> {
  String _selectedDuration = '30 Minutes';
  String _selectedPermission = 'View Only';
  final String _generatedLink = 'https://myperro.com/track/krypto/${math.Random().nextInt(10000)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Share Link',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShareLinkDetailScreen(petName: widget.petName),
                ),
              );
            },
            child: const Text(
              'Active Links',
              style: TextStyle(color: _brandOrange),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Code container
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  padding: const EdgeInsets.all(20),
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
                  child: CustomPaint(
                    painter: _QRCodePainter(),
                    size: const Size.square(220),
                  ),
                ),
              ),
              
              // Pet Name
              Center(
                child: Text(
                  '${widget.petName}\'s Location',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _grey900,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Link duration
              const Text(
                'Share Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _grey900,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _grey300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedDuration,
                    items: ['15 Minutes', '30 Minutes', '1 Hour', '24 Hours', 'Custom']
                        .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDuration = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Permission level
              const Text(
                'Permission Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _grey900,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _grey300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedPermission,
                    items: ['View Only', 'Interact', 'Full Access']
                        .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPermission = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Generated link
              const Text(
                'Link',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _grey900,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _grey300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _generatedLink,
                        style: const TextStyle(color: _grey700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: _brandOrange),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _generatedLink));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Share Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Show sharing options
                    _showShareOptions(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandOrange,
                    foregroundColor: Colors.white,
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
  
  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share via',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _grey900,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShareOption(
                    icon: Icons.message,
                    label: 'SMS',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      _showSuccessDialog();
                    },
                  ),
                  _ShareOption(
                    icon: Icons.email,
                    label: 'Email',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showSuccessDialog();
                    },
                  ),
                  _ShareOption(
                    icon: Icons.messenger_outline,
                    label: 'Messenger',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _showSuccessDialog();
                    },
                  ),
                  _ShareOption(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp',
                    color: Colors.green.shade700,
                    onTap: () {
                      Navigator.pop(context);
                      _showSuccessDialog();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFE6F4EA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.petName}\'s location link has been shared',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _grey900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Link will expire in 30 minutes',
              style: TextStyle(
                fontSize: 14,
                color: _grey700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _grey700,
            ),
          ),
        ],
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

    // Add the MyPerro logo in the center
    final logoSize = size.width * 0.3;
    final logoOffset = (size.width - logoSize) / 2;

    for (int row = 0; row < qrPattern.length; row++) {
      for (int col = 0; col < qrPattern[row].length; col++) {
        // Skip drawing QR bits in the logo area
        final x = col * blockSize;
        final y = row * blockSize;
        
        if (x >= logoOffset && x < logoOffset + logoSize && 
            y >= logoOffset && y < logoOffset + logoSize) {
          continue;
        }
        
        if (qrPattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              x,
              y,
              blockSize,
              blockSize,
            ),
            paint,
          );
        }
      }
    }
    
    // Draw logo background
    final logoBgPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(logoOffset, logoOffset, logoSize, logoSize),
      logoBgPaint,
    );
    
    // Draw logo border
    final logoBorderPaint = Paint()
      ..color = _brandOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(
      Rect.fromLTWH(logoOffset, logoOffset, logoSize, logoSize),
      logoBorderPaint,
    );
    
    // Draw MyPerro brand text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "MyPerro",
        style: TextStyle(
          color: _brandOrange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas, 
      Offset(
        logoOffset + (logoSize - textPainter.width) / 2,
        logoOffset + logoSize / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
