// lib/ui/screens/auth/login_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myperro/core/auth/auth_locator.dart';
import 'package:myperro/ui/screens/auth/signup_screen.dart';
import 'package:myperro/ui/screens/onboarding/location_osm_screen.dart'; // <-- added

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // —— style tokens ——
  static const Color _brandOrange = Color(0xFFF5832A); // CTA button
  static const Color _bgWhite = Color(0xFFFFFFFF); // page background
  static const Color _labelGrey = Color(0xFF6A6A6A); // body text grey (warmer)
  static const Color _dividerGrey = Color(0xFFE0E0E0); // lighter divider
  static const Color _peachShadow = Color(0xFFF0D4BE); // soft peach shadow
  static const Color _hintGrey = Color(0xFFB0B0B0); // hint text
  static const Color _titleBlack = Color(0xFF1F1F1F); // title/strong text
  static const Color _titleGrey = Color(0xFF3A3A3A); // title/strong grey

  // —— Rive (optional) ——
  late String _animationURL;
  Artboard? _riveArtboard;
  StateMachineController? _ctrl;
  SMITrigger? _success, _fail;
  SMIBool? _isHandsUp, _isChecking;
  SMINumber? _numLook;

  // —— form controllers ——
  final _loginIdCtl = TextEditingController();
  final _passCtl = TextEditingController();

  final _loginIdFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _initializeRive();
    _loginIdCtl.addListener(() {
      _numLook?.change(_loginIdCtl.text.length.toDouble());
    });
  }

  Future<void> _initializeRive() async {
    try {
      await RiveFile.initialize();

      _animationURL = (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)
          ? 'assets/animations/login.riv'
          : 'animations/login.riv';

      final data = await rootBundle.load(_animationURL);
      final file = RiveFile.import(data);
      final art = file.mainArtboard;
      _ctrl = StateMachineController.fromArtboard(art, 'Login Machine');
      if (_ctrl != null) {
        art.addController(_ctrl!);
        for (final i in _ctrl!.inputs) {
          switch (i.name) {
            case 'trigSuccess':
              _success = i as SMITrigger;
              break;
            case 'trigFail':
              _fail = i as SMITrigger;
              break;
            case 'isHandsUp':
              _isHandsUp = i as SMIBool;
              break;
            case 'isChecking':
              _isChecking = i as SMIBool;
              break;
            case 'numLook':
              _numLook = i as SMINumber;
              break;
          }
        }
      }
      if (mounted) {
        setState(() => _riveArtboard = art);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Rive initialization error: $e');
      }
    }
  }

  @override
  void dispose() {
    _loginIdCtl.dispose();
    _passCtl.dispose();
    _loginIdFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  bool get _validPhone {
    final p = _loginIdCtl.text.trim();
    return RegExp(r'^[0-9]{10}$').hasMatch(p);
  }

  bool get _validEmail {
    final e = _loginIdCtl.text.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(e);
  }

  bool get _validLoginId => _validPhone || _validEmail;

  bool get _validPass => _passCtl.text.length >= 6;

  // —— DEMO shortcut: allow "admin"/"admin" regardless of other rules ——
  bool get _isAdminPair =>
      _loginIdCtl.text.trim() == 'admin' && _passCtl.text == 'admin';

  bool get _formValid => _isAdminPair || (_validLoginId && _validPass);

  void _handsUp() => _isHandsUp?.change(true);
  void _handsDown() => _isHandsUp?.change(false);

  void _lookAtField() {
    _handsDown();
    _isChecking?.change(true);
    _numLook?.change(0);
  }

  // —— shared social login wrapper (feedback + Rive) ——
  Future<void> _socialLogin(
      Future<void> Function() action,
      String provider,
      ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing in with $provider...')),
      );

      await action(); // mocked or real provider
      _success?.fire(); // Rive success

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in with $provider')),
      );

      // Navigate after social success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LocationOsmScreen()),
      );
    } catch (e) {
      _fail?.fire(); // Rive fail
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;

    // Adjust Rive animation height based on available space
    final riveHeight = keyboardHeight > 0 ? 140.0 : 240.0;

    return Scaffold(
      backgroundColor: _bgWhite,
      resizeToAvoidBottomInset: true, // Allow resize when keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: 360,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),

                      // Rive animation - responsive height
                      if (_riveArtboard != null)
                        Center(
                          child: SizedBox(
                            width: 320,
                            height: riveHeight,
                            child: Rive(artboard: _riveArtboard!, fit: BoxFit.contain),
                          ),
                        ),

                      SizedBox(height: keyboardHeight > 0 ? 8 : 12),

                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: _titleGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Phone Number / Email Address',
                        style: TextStyle(
                          color: _titleBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _dividerField(
                        controller: _loginIdCtl,
                        focusNode: _loginIdFocus,
                        hint: 'Enter Email Id or Phone Number',
                        textInputType: TextInputType.emailAddress,
                        onTap: _lookAtField,
                        isValid: _isAdminPair ? true : _validLoginId,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: _titleBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _dividerField(
                        controller: _passCtl,
                        focusNode: _passFocus,
                        hint: 'Enter Password',
                        obscure: !_showPassword,
                        textInputType: TextInputType.visiblePassword,
                        onTap: () {
                          _showPassword ? _handsDown() : _handsUp();
                        },
                        isValid: _isAdminPair ? true : _validPass,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 8),

                      // Show/Hide password row - more compact
                      Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(-6, 0),
                            child: Checkbox(
                              value: _showPassword,
                              onChanged: (v) {
                                setState(() => _showPassword = v ?? false);
                                _showPassword ? _handsDown() : _handsUp();
                              },
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              side: const BorderSide(color: _dividerGrey),
                              activeColor: _brandOrange,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Show password',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Forgot password tapped')),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: _brandOrange,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: keyboardHeight > 0 ? 20 : 32),

                      // Login button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: _formValid
                              ? [
                            BoxShadow(
                              color: _peachShadow.withOpacity(0.9),
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                            ),
                          ]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: _formValid ? _onLogin : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _formValid ? _brandOrange : Colors.grey.shade400,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sign up link
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'New to MyPerro? ',
                              style: TextStyle(
                                color: _labelGrey.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                                );
                              },
                              child: const Text(
                                'SignUp here',
                                style: TextStyle(
                                  color: _brandOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Social login section - conditional visibility when keyboard is open
                      if (keyboardHeight == 0) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(height: 1.5, color: _dividerGrey),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'or sign up with',
                                style: TextStyle(
                                  color: _labelGrey.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(height: 1.5, color: _dividerGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialCircleButton(
                              icon: const FaIcon(FontAwesomeIcons.google, color: _brandOrange),
                              onTap: () async {
                                await _socialLogin(AuthLocator.instance.loginWithGoogle, 'Google');
                              },
                            ),
                            const SizedBox(width: 20),
                            _socialCircleButton(
                              icon: const FaIcon(FontAwesomeIcons.apple, color: _brandOrange),
                              onTap: () async {
                                await _socialLogin(AuthLocator.instance.loginWithApple, 'Apple');
                              },
                            ),
                            const SizedBox(width: 20),
                            _socialCircleButton(
                              icon: const FaIcon(FontAwesomeIcons.envelope, color: _brandOrange),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Text("Email quick login coming soon!"),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dividerField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required TextInputType textInputType,
    required VoidCallback onTap,
    required bool isValid,
    bool obscure = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          onChanged: (_) => setState(() {}),
          keyboardType: textInputType,
          obscureText: obscure,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(bottom: -2),
            hintText: hint,
            hintStyle: const TextStyle(color: _hintGrey, height: 1.0),
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),
        Container(height: 1, color: _dividerGrey),
      ],
    );
  }

  Widget _socialCircleButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _dividerGrey, width: 2.5),
          color: Colors.white,
        ),
        child: Center(child: icon),
      ),
    );
  }

  void _onLogin() async {
    _isChecking?.change(false);
    _handsDown();

    if (!_formValid) {
      _fail?.fire();
      return;
    }

    // —— DEMO short-circuit: accept admin/admin without backend ——
    if (_isAdminPair) {
      _success?.fire();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LocationOsmScreen()),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing in...')),
      );
      await AuthLocator.instance.loginWithEmail(
        loginId: _loginIdCtl.text.trim(),
        password: _passCtl.text,
      );
      _success?.fire();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LocationOsmScreen()),
      );
    } catch (e) {
      _fail?.fire();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}