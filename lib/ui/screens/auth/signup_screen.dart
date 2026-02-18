import 'package:flutter/material.dart';
import 'package:myperro_app_merged/ui/screens/auth/signup_otp_screen.dart';
import 'dart:ui' as ui;

// Brand tokens (match login)
const _brandOrange = Color(0xFFF5832A);
const _titleGrey = Color(0xFF3A3A3A);
const _titleBlack = Color(0xFF1F1F1F);
const _labelGrey = Color(0xFF6A6A6A);
const _dividerGrey = Color(0xFFE0E0E0);
const _hintGrey = Color(0xFFB0B0B0);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // controllers & focus
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _emailCtl = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _emailCtl.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // --- validation ---
  bool get _validName => _nameCtl.text.trim().length >= 2;
  bool get _validPhone =>
      RegExp(r'^[0-9]{10}$').hasMatch(_phoneCtl.text.trim());
  bool get _validEmail {
    final e = _emailCtl.text.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(e);
  }

  bool get _formValid => _validName && _validPhone && _validEmail;

  void _sendOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpOtpScreen(
          phone: _phoneCtl.text.trim(),
          email: _emailCtl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header: ellipse (fixed) + large GIF (can overflow) ---
                  Center(
                    child: SizedBox(
                      width: 500,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/illustrations/ellipse_bg.png',
                            width: 340,  // keep ellipse constant
                            height: 260,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            bottom: -8, // sit slightly on/under ellipse
                            child: Image.asset(
                              'assets/animations/signup_animation.gif',
                              width: 460,    // dog bigger than ellipse
                              height: 360,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Sign-Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _titleGrey,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Name
                  const _FieldLabel('Your Name'),
                  _DividerField(
                    controller: _nameCtl,
                    focusNode: _nameFocus,
                    hint: 'FirstName LastName',
                    textInputType: TextInputType.name,
                    isValid: _validName,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _phoneFocus.requestFocus(),
                    suffixValidTick: true,
                  ),
                  const SizedBox(height: 18),

                  // Phone
                  const _FieldLabel('Phone Number'),
                  _DividerField(
                    controller: _phoneCtl,
                    focusNode: _phoneFocus,
                    hint: '10 Digits',
                    textInputType: TextInputType.phone,
                    isValid: _validPhone,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                    suffixValidTick: true,
                  ),
                  const SizedBox(height: 18),

                  // Email
                  const _FieldLabel('Email Address'),
                  _DividerField(
                    controller: _emailCtl,
                    focusNode: _emailFocus,
                    hint: 'example@domain.com',
                    textInputType: TextInputType.emailAddress,
                    isValid: _validEmail,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.done,
                    suffixValidTick: true,
                  ),

                  const SizedBox(height: 18),

                  // Already have account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: _labelGrey.withOpacity(0.9),
                          fontSize: 13.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: _brandOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // --- CTA (pill + right arrow bubble + orange under-glow) ---
                  // --- CTA (pill + right arrow bubble + orange under-glow) ---
                  PillCTA(
                    label: 'Send OTP',
                    enabled: _formValid,
                    onPressed: _formValid ? _sendOtp : null, // <- use your correct method
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Reusable bits ----------

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _titleBlack,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Clean divider-style text field:
/// - spacing ABOVE the field (from label)
/// - text sits tight on the underline (typing looks "on the line")
class _DividerField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType textInputType;
  final bool isValid;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool suffixValidTick;

  static const double _fieldHeight = 44;      // visual height of the row
  static const double _baselineNudge = -10;   // pulls text closer to the line
  static const double _tickBottom = 6;        // vertical align for the ✓
  static const double _underlineThick = 1;

  const _DividerField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.textInputType,
    required this.isValid,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.suffixValidTick = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // space between label (“Your Name”) and the row
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        height: _fieldHeight + _underlineThick,
        child: Stack(
          children: [
            // 1) Text field (reserve right padding so text never hits the tick)
            Positioned.fill(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardType: textInputType,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(
                    bottom: _baselineNudge, // pull baseline onto the line
                    right: suffixValidTick ? 40 : 0, // room for ✓
                  ),
                  hintText: hint,
                  hintStyle: const TextStyle(color: _hintGrey, height: 1.0),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16, height: 1.0),
              ),
            ),

            // 2) Tick placed with exact bottom offset (aligned visually with line)
            if (suffixValidTick && isValid)
              const Positioned(
                right: 0,
                bottom: _tickBottom,
                child: Icon(Icons.check_rounded,
                    color: _brandOrange, size: 20),
              ),

            // 3) Underline pinned to the absolute bottom
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Divider(height: 1, thickness: _underlineThick, color: _dividerGrey),
            ),
          ],
        ),
      ),
    );
  }
}


/// Pill CTA with right circular arrow and orange under-glow
class PillCTA extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;
  const PillCTA({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Gradient bg = enabled
        ? const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF89A50), Color(0xFFF5832A)], // subtle top->bottom
    )
        : const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFCFCFCF), Color(0xFFBDBDBD)],
    );

    final Color bubble = Colors.white.withOpacity(enabled ? 0.28 : 0.35);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Under-glow (exact width of the button, centered, darker orange)
        Positioned(
          bottom: -2,
          left: 8,
          right: 0,
          child: SizedBox(
            height: 22,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xE6F5832A), // 90% orange on top
                      Color(0x33F5832A), // 20% fade
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // The pill button
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: bg,
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
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
