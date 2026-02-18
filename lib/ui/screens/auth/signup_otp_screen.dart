// lib/ui/screens/auth/signup_otp_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_password_screen.dart';

// ---- Brand tokens (keep in sync with your other screens)
const _brandOrange = Color(0xFFF5832A);
const _titleGrey   = Color(0xFF3A3A3A);
const _titleBlack  = Color(0xFF1F1F1F);
const _dividerGrey = Color(0xFFE0E0E0);

class SignUpOtpScreen extends StatefulWidget {
  final String phone;
  final String email;

  const SignUpOtpScreen({
    super.key,
    required this.phone,
    required this.email,
  });

  @override
  State<SignUpOtpScreen> createState() => _SignUpOtpScreenState();
}

enum _VerifyState { initial, success, fail }

class _SignUpOtpScreenState extends State<SignUpOtpScreen> {
  // Demo "correct" OTPs (frontend only)
  static const String _phoneCorrect = '012345';
  static const String _emailCorrect = '678901';
  static const int _len = 6;

  // Phone OTP
  final List<TextEditingController> _ph =
  List.generate(_len, (_) => TextEditingController());
  final List<FocusNode> _phNodes = List.generate(_len, (_) => FocusNode());
  _VerifyState _phoneState = _VerifyState.initial;

  // Email OTP
  final List<TextEditingController> _em =
  List.generate(_len, (_) => TextEditingController());
  final List<FocusNode> _emNodes = List.generate(_len, (_) => FocusNode());
  _VerifyState _emailState = _VerifyState.initial;

  // Resend timers (seconds)
  static const int _resendCooldown = 30;
  int _phoneSeconds = _resendCooldown;
  int _emailSeconds = _resendCooldown;
  Timer? _phoneTimer;
  Timer? _emailTimer;

  @override
  void initState() {
    super.initState();
    _startPhoneTimer();
    _startEmailTimer();
  }

  @override
  void dispose() {
    for (final c in _ph) {
      c.dispose();
    }
    for (final n in _phNodes) {
      n.dispose();
    }
    for (final c in _em) {
      c.dispose();
    }
    for (final n in _emNodes) {
      n.dispose();
    }
    _phoneTimer?.cancel();
    _emailTimer?.cancel();
    super.dispose();
  }

  // ----- Helpers -----
  String _join(List<TextEditingController> list) =>
      list.map((c) => c.text).join();

  // ✅ Proper "all digits filled" checks (fixes Verify not enabling)
  bool _filled(List<TextEditingController> list) =>
      list.every((c) => c.text.isNotEmpty);

  void _clearSection(List<TextEditingController> list, List<FocusNode> nodes) {
    for (final c in list) {
      c.clear();
    }
    nodes.first.requestFocus();
  }

  // ----- Verify logic -----
  Future<void> _verifyPhone() async {
    final ok = _join(_ph) == _phoneCorrect;
    setState(() => _phoneState = ok ? _VerifyState.success : _VerifyState.fail);
    if (ok && _emailState == _VerifyState.success) _goNext();
  }

  Future<void> _verifyEmail() async {
    final ok = _join(_em) == _emailCorrect;
    setState(() => _emailState = ok ? _VerifyState.success : _VerifyState.fail);
    if (ok && _phoneState == _VerifyState.success) _goNext();
  }

  void _goNext() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpPasswordScreen()),
    );
  }

  // ----- Resend logic + timers -----
  void _startPhoneTimer() {
    _phoneTimer?.cancel();
    setState(() => _phoneSeconds = _resendCooldown);
    _phoneTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_phoneSeconds <= 1) {
        t.cancel();
        setState(() => _phoneSeconds = 0);
      } else {
        setState(() => _phoneSeconds -= 1);
      }
    });
  }

  void _startEmailTimer() {
    _emailTimer?.cancel();
    setState(() => _emailSeconds = _resendCooldown);
    _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_emailSeconds <= 1) {
        t.cancel();
        setState(() => _emailSeconds = 0);
      } else {
        setState(() => _emailSeconds -= 1);
      }
    });
  }

  void _resendPhone() {
    if (_phoneSeconds > 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone OTP re-sent to ${widget.phone} (demo)')),
    );
    setState(() => _phoneState = _VerifyState.initial);
    _clearSection(_ph, _phNodes);
    _startPhoneTimer();
  }

  void _resendEmail() {
    if (_emailSeconds > 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email OTP re-sent to ${widget.email} (demo)')),
    );
    setState(() => _emailState = _VerifyState.initial);
    _clearSection(_em, _emNodes);
    _startEmailTimer();
  }

  String _fmt(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ----- UI -----
  @override
  Widget build(BuildContext context) {
    // Match previous screens’ visual scale (slightly larger ellipse and animation)
    const double containerW = 400;
    const double containerH = 320;
    const double ellipseW = 300; // previous screens
    const double animW = 320;    // previous screens

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header (ellipse + gif) — clean, centered
                  const SizedBox(height: 8),
                  SizedBox(
                    width: containerW,
                    height: containerH,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/illustrations/ellipse_bg.png',
                          width: ellipseW,
                          fit: BoxFit.contain,
                        ),
                        Image.asset(
                          'assets/animations/otp_verification_animation.gif',
                          width: animW,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _titleBlack,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ===== Phone section =====
                  Text.rich(
                    TextSpan(
                      text: 'Enter the 6-digit code sent to ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: _titleGrey,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: widget.phone,
                          style: const TextStyle(
                            color: _brandOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _OtpRow(
                    controllers: _ph,
                    nodes: _phNodes,
                    state: _phoneState,
                    onAnyChange: () => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Resend (with timer)
                      TextButton(
                        onPressed: _phoneSeconds == 0 ? _resendPhone : null,
                        style: TextButton.styleFrom(
                          foregroundColor: _brandOrange,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          _phoneSeconds == 0
                              ? 'Resend'
                              : 'Resend in ${_fmt(_phoneSeconds)}',
                        ),
                      ),
                      const Spacer(),
                      _MiniVerifyButton(
                        onPressed: _filled(_ph) ? _verifyPhone : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ===== Email section =====
                  Text.rich(
                    TextSpan(
                      text: 'Enter the 6-digit code sent to ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: _titleGrey,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            color: _brandOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _OtpRow(
                    controllers: _em,
                    nodes: _emNodes,
                    state: _emailState,
                    onAnyChange: () => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _emailSeconds == 0 ? _resendEmail : null,
                        style: TextButton.styleFrom(
                          foregroundColor: _brandOrange,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          _emailSeconds == 0
                              ? 'Resend'
                              : 'Resend in ${_fmt(_emailSeconds)}',
                        ),
                      ),
                      const Spacer(),
                      _MiniVerifyButton(
                        onPressed: _filled(_em) ? _verifyEmail : null,
                      ),
                    ],
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

// ----- Mini verify button (small rounded rectangle)
class _MiniVerifyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _MiniVerifyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _brandOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

// ----- Row of 6 OTP boxes (forward on input, back on delete) + trailing status
class _OtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> nodes;
  final _VerifyState state;
  final VoidCallback onAnyChange;

  const _OtpRow({
    required this.controllers,
    required this.nodes,
    required this.state,
    required this.onAnyChange,
  });

  static const _boxWidth = 42.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The 6 boxes
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(controllers.length, (i) {
              return SizedBox(
                width: _boxWidth,
                child: Focus(
                  onKeyEvent: (node, evt) {
                    // Backspace while empty -> jump to previous
                    if (evt is KeyDownEvent &&
                        evt.logicalKey == LogicalKeyboardKey.backspace &&
                        controllers[i].text.isEmpty) {
                      if (i > 0) {
                        nodes[i - 1].requestFocus();
                        controllers[i - 1].clear();
                        onAnyChange();
                      }
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: controllers[i],
                    focusNode: nodes[i],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _dividerGrey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _brandOrange, width: 1.6),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (val) {
                      // sanitize to last digit
                      if (val.isNotEmpty) {
                        controllers[i].text = val.characters.last;
                        controllers[i].selection = TextSelection.fromPosition(
                          TextPosition(offset: controllers[i].text.length),
                        );
                        // move forward automatically
                        if (i < controllers.length - 1) {
                          nodes[i + 1].requestFocus();
                        } else {
                          nodes[i].unfocus();
                        }
                      }
                      onAnyChange();
                    },
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        if (state != _VerifyState.initial)
          Icon(
            state == _VerifyState.success
                ? Icons.check_circle
                : Icons.cancel_rounded,
            color: state == _VerifyState.success
                ? _brandOrange
                : Colors.redAccent,
            size: 20,
          ),
      ],
    );
  }
}
