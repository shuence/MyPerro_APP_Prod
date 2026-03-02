import 'package:flutter/material.dart';
import 'package:myperro/ui/screens/onboarding/location_osm_screen.dart';

import 'dart:ui' as ui;

// Brand tokens (match SignUp screen)
const _brandOrange = Color(0xFFF5832A);
const _titleGrey = Color(0xFF3A3A3A);
const _titleBlack = Color(0xFF1F1F1F);
const _labelGrey = Color(0xFF6A6A6A);
const _dividerGrey = Color(0xFFE0E0E0);
const _hintGrey = Color(0xFFB0B0B0);

class SignUpPasswordScreen extends StatefulWidget {
  const SignUpPasswordScreen({super.key});

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  // controllers & focus
  final _passCtl = TextEditingController();
  final _confirmPassCtl = TextEditingController();

  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  @override
  void dispose() {
    _passCtl.dispose();
    _confirmPassCtl.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // validation
  bool get _validPass => _passCtl.text.trim().length >= 6;
  bool get _validConfirm =>
      _confirmPassCtl.text.trim() == _passCtl.text.trim() && _validPass;

  bool get _formValid => _validPass && _validConfirm;

  void _sendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent (demo)')),
    );
    // TODO: Navigate to OTP verification screen
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
                  // --- Header animation (exactly like SignUp) ---
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
                            width: 340, // keep ellipse constant
                            height: 260,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            bottom: -8, // sit slightly on/under ellipse
                            child: Image.asset(
                              'assets/animations/signup_animation.gif',
                              width: 460, // dog bigger than ellipse
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
                    'Set Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _titleGrey,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Password
                  const _FieldLabel('Password'),
                  _DividerField(
                    controller: _passCtl,
                    focusNode: _passFocus,
                    hint: 'Minimum 6 characters',
                    textInputType: TextInputType.visiblePassword,
                    isValid: _validPass,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _confirmPassFocus.requestFocus(),
                    suffixValidTick: true,
                    obscure: true, // eye icon enabled
                  ),
                  const SizedBox(height: 18),

                  // Confirm Password
                  const _FieldLabel('Confirm Password'),
                  _DividerField(
                    controller: _confirmPassCtl,
                    focusNode: _confirmPassFocus,
                    hint: 'Re-enter your password',
                    textInputType: TextInputType.visiblePassword,
                    isValid: _validConfirm,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {},
                    suffixValidTick: true,
                    obscure: true, // eye icon enabled
                  ),

                  const SizedBox(height: 36),

                  // CTA: Send OTP (same pill + glow)
                  PillCTA(
                    label: 'Next',
                    enabled: _formValid,
                    onPressed: _formValid
                        ? () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LocationOsmScreen(),
                        ),
                      );
                    }
                        : null,
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

// ---------- Reusable bits (identical look to SignUp; eye/tick aligned) ----------

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

/// Divider-style text field + eye toggle + ✓
/// Eye and tick are pixel-aligned (both 20px icons with the same baseline).
class _DividerField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType textInputType;
  final bool isValid;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool suffixValidTick;
  final bool obscure;

  static const double _fieldHeight = 44;
  static const double _baselineNudge = -10;
  static const double _underlineThick = 1;

  // one shared baseline for both icons (tweak 2..4 if needed)
  static const double _suffixBottom = 3;

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
    this.obscure = false,
  });

  @override
  State<_DividerField> createState() => _DividerFieldState();
}

class _DividerFieldState extends State<_DividerField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    // Reserve right padding for eye (24) + tick (24) + small gap
    final double rightPad =
        (widget.obscure ? 24.0 : 0.0) + (widget.suffixValidTick ? 24.0 : 0.0) + 6.0;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        height: _DividerField._fieldHeight + _DividerField._underlineThick,
        child: Stack(
          children: [
            // TextField
            Positioned.fill(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                textAlignVertical: TextAlignVertical.bottom,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(
                    bottom: _DividerField._baselineNudge,
                    right: rightPad,
                  ),
                  hintText: widget.hint,
                  hintStyle: const TextStyle(color: _hintGrey, height: 1.0),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16, height: 1.0),
              ),
            ),

            // Eye toggle (24×24, 20px icon)
            if (widget.obscure)
              Positioned(
                right: (widget.suffixValidTick ? 24 : 0),
                bottom: _DividerField._suffixBottom,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 20,
                      color: _labelGrey,
                    ),
                  ),
                ),
              ),

            // Tick (20px icon, same baseline)
            if (widget.suffixValidTick && widget.isValid)
              const Positioned(
                right: 0,
                bottom: _DividerField._suffixBottom,
                child: Icon(Icons.check_rounded, color: _brandOrange, size: 20),
              ),

            // Underline
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Divider(
                height: 1,
                thickness: _DividerField._underlineThick,
                color: _dividerGrey,
              ),
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
      colors: [Color(0xFFF89A50), Color(0xFFF5832A)],
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
        // Glow (exact button width)
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
                    colors: [
                      Color(0xE6F5832A), // stronger orange
                      Color(0x33F5832A),
                    ],
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
