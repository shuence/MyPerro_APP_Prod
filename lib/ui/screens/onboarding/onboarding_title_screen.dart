import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'onboarding_pet_credentials_screen.dart';

// keep constants same as other screens
const _brandOrange = Color(0xFFF5832A);
const _titleBlack = Color(0xFF1F1F1F);

class OnboardingTitleScreen extends StatefulWidget {
  const OnboardingTitleScreen({super.key});

  @override
  State<OnboardingTitleScreen> createState() => _OnboardingTitleScreenState();
}

class _OnboardingTitleScreenState extends State<OnboardingTitleScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;
  late AnimationController _animationController;
  bool _isAnimating = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Precache role images to avoid flicker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/roles/pet_parent.png'), context);
      precacheImage(const AssetImage('assets/roles/care_taker.png'), context);
      precacheImage(const AssetImage('assets/roles/family_member.png'), context);

      // Trigger fade-in once ready
      setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Return different images based on selected role
  String _gifFor(String? role) {
    switch (role) {
      case 'Pet Parent':
        return 'assets/roles/pet_parent.png';
      case 'Caretaker':
        return 'assets/roles/care_taker.png';
      case 'Family Member':
        return 'assets/roles/family_member.png';
      default:
        return 'assets/roles/pet_parent.png'; // default fallback
    }
  }

  void _onRoleSelected(String role) async {
    if (_selectedRole == role || _isAnimating) return;

    setState(() => _isAnimating = true);

    if (_selectedRole != null && _selectedRole != role) {
      await _animationController.reverse();
      if (mounted) {
        setState(() => _selectedRole = role);
        await _animationController.forward();
      }
    } else {
      setState(() => _selectedRole = role);
      await _animationController.forward();
    }

    if (mounted) {
      setState(() => _isAnimating = false);
    }
  }

  void _onContinue() {
    if (_selectedRole == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OnboardingPetCredentialsScreen(),
      ),
    );
  }

  Widget _roleOption(String label) {
    final bool isSelected = _selectedRole == label;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _onRoleSelected(label),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? _brandOrange : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? _brandOrange.withOpacity(0.05) : Colors.white,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: _brandOrange.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _brandOrange : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected ? _brandOrange : Colors.white,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                    key: ValueKey('check'),
                  )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? _brandOrange : Colors.black87,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gifPath = _gifFor(_selectedRole);

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
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Role-specific image
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedRole != null
                          ? _brandOrange
                          : Colors.grey.shade300,
                      width: 4,
                    ),
                    boxShadow: _selectedRole != null
                        ? [
                      BoxShadow(
                        color: _brandOrange.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                        : [],
                  ),
                  child: ClipOval(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        gifPath,
                        key: ValueKey(gifPath),
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 280,
                            height: 280,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFE0B2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 120,
                              color: _brandOrange,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                const Text(
                  "What are you?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _titleBlack,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                // Role options
                Column(
                  children: [
                    _roleOption('Pet Parent'),
                    _roleOption('Caretaker'),
                    _roleOption('Family Member'),
                  ],
                ),

                const Spacer(),

                // Continue button
                _ContinueCTA(
                  enabled: _selectedRole != null,
                  onPressed: _selectedRole != null ? _onContinue : null,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Rounded gradient CTA (matches Location screen look) =====
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow effect
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            bottom: -8,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: enabled ? 1.0 : 0.3,
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
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
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
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          shadows: enabled
                              ? [
                            const Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ]
                              : [],
                        ),
                        child: const Text('Continue'),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        right: 14,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
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
      ),
    );
  }
}
