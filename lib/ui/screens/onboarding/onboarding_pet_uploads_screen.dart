import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'onboarding_done_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _titleBlack  = Color(0xFF1F1F1F);
const _dividerGrey = Color(0xFFE0E0E0);
const _tileStroke  = Color(0xFFE6E6E6); // lighter stroke for modern look
const _lightGray = Color(0xFFF8F9FA);
const _mediumGray = Color(0xFF6B7280);

class OnboardingPetUploadsScreen extends StatefulWidget {
  final String petName;

  const OnboardingPetUploadsScreen({super.key, required this.petName});

  @override
  State<OnboardingPetUploadsScreen> createState() => _OnboardingPetUploadsScreenState();
}

class _OnboardingPetUploadsScreenState extends State<OnboardingPetUploadsScreen> {
  final _picker = ImagePicker();
  XFile? _petImage;
  final List<PlatformFile> _docs = [];

  bool get _canContinue => _petImage != null; // image is required

  // pickers
  Future<void> _pickPetImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _petImage = picked);
  }

  Future<void> _pickDocs() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      withData: true,
    );
    if (result == null) return;

    final remaining = 10 - _docs.length;
    setState(() => _docs.addAll(result.files.take(remaining)));

    if (_docs.length == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 documents added.')),
      );
    }
  }

  void _removeDoc(int idx) => setState(() => _docs.removeAt(idx));

  void _onContinue() {
    if (!_canContinue) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingDoneScreen(petName: widget.petName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Fixed bottom CTA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: _ContinueCTA(
            enabled: _canContinue,
            onPressed: _canContinue ? _onContinue : null,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Header
                  Text(
                    'Add ${widget.petName}\'s Information',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _titleBlack,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // PET IMAGE SECTION
                  const Text(
                    'Pet Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _titleBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CircularPetUploadTile(
                    onTap: _pickPetImage,
                    selectedImage: _petImage,
                  ),


                  // HEALTH DOCUMENTS SECTION
                  const Text(
                    'Health Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _titleBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ModernUploadTile(
                    height: 200,
                    icon: Icons.health_and_safety_outlined,
                    title: 'Upload Health Documents',
                    subtitle: 'Vaccination records, medical history, certificates',
                    onTap: _pickDocs,
                    documentCount: _docs.length,
                  ),

                  if (_docs.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _DocsList(docs: _docs, onRemove: _removeDoc),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Circular pet upload tile matching the reference design
class _CircularPetUploadTile extends StatelessWidget {
  final VoidCallback onTap;
  final XFile? selectedImage;

  const _CircularPetUploadTile({
    required this.onTap,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(80),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main circular container with dashed border
                Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CustomPaint(
                    painter: _DashedCirclePainter(
                      color: _mediumGray.withOpacity(0.4),
                      strokeWidth: 2,
                    ),
                    child: selectedImage != null
                        ? _buildImagePreview()
                        : _buildPetPlaceholder(),
                  ),
                ),
                // Plus button in top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _tileStroke, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      selectedImage != null ? Icons.edit : Icons.add,
                      size: 18,
                      color: _mediumGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: SizedBox(
          width: 144,
          height: 144,
          child: kIsWeb
              ? Image.network(selectedImage!.path, fit: BoxFit.cover)
              : Image.file(File(selectedImage!.path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildPetPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _brandOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 28,
              color: _brandOrange,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload an image\nof your pet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: _mediumGray,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed circle border
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = (size.width / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    const dashLength = 8.0;
    const gapLength = 6.0;
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength) / radius);
      final endAngle = startAngle + (dashLength / radius);

      final startPoint = Offset(
        center.dx + radius * math.cos(startAngle),
        center.dy + radius * math.sin(startAngle),
      );
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Modern upload tile for documents
class _ModernUploadTile extends StatelessWidget {
  final double height;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int? documentCount;

  const _ModernUploadTile({
    required this.height,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.documentCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasContent = documentCount != null && documentCount! > 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasContent ? _brandOrange.withOpacity(0.3) : _tileStroke,
          width: hasContent ? 2 : 1.5,
        ),
        color: hasContent ? _brandOrange.withOpacity(0.02) : _lightGray,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _brandOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: _brandOrange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _titleBlack,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _mediumGray,
                    height: 1.3,
                  ),
                ),
                if (documentCount != null && documentCount! > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _brandOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$documentCount file${documentCount! > 1 ? 's' : ''} selected',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _brandOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DocsList extends StatelessWidget {
  final List<PlatformFile> docs;
  final void Function(int idx) onRemove;
  const _DocsList({required this.docs, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _tileStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_outlined, size: 20, color: _mediumGray),
              const SizedBox(width: 8),
              const Text(
                'Selected Documents',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _titleBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${docs.length}/10',
                style: const TextStyle(
                  fontSize: 12,
                  color: _mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < docs.length; i++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _tileStroke),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFileIcon(docs[i].extension ?? ''),
                        size: 16,
                        color: _mediumGray,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          docs[i].name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _titleBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => onRemove(i),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: _mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

// Gradient CTA (same as other screens)
class _ContinueCTA extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  const _ContinueCTA({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Gradient bg = enabled
        ? const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF89A50), _brandOrange],
    )
        : const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFCFCFCF), Color(0xFFBDBDBD)],
    );
    final bubble = Colors.white.withOpacity(enabled ? 0.28 : 0.35);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -8,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 22,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xE6F5832A), Color(0x33F5832A)],
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: bg,
            ),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Positioned(
                      right: 14,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: bubble,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}