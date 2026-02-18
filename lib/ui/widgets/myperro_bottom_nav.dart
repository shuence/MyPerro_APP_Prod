import 'package:flutter/material.dart';

/// Brand tokens
const _brandOrange = Color(0xFFF5832A);
const _grey700 = Color(0xFF6B6B6B);
const _grey300 = Color(0xFFE9E9E9);

/// Pixel-perfect bottom nav:
/// - rounded white bar with thin grey border & soft shadow
/// - 5 grey icons
/// - an orange circular "badge" floats slightly above the selected icon
class MyPerroBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final IconData? centerBubbleIcon;

  const MyPerroBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.centerBubbleIcon,
  });

  List<IconData> get _icons => <IconData>[
        Icons.notifications_none_rounded,
        Icons.image_outlined,
        centerBubbleIcon ?? Icons.pets_rounded,
        Icons.crop_free_rounded,
        Icons.person_outline_rounded,
      ];

  @override
  Widget build(BuildContext context) {
    final icons = _icons;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Fixed bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _grey300),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x15000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(icons.length, (i) {
                      final selected = i == currentIndex;
                      return SizedBox(
                        width: 48,
                        height: 48,
                        child: IconButton(
                          splashRadius: 24,
                          onPressed: () => onTap(i),
                          icon: Icon(
                            icons[i],
                            color: selected ? Colors.transparent : _grey700,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Floating orange selection bubble
              Positioned(
                left: 18 +
                    (currentIndex *
                        ((MediaQuery.of(context).size.width - 60) / icons.length)),
                bottom: 16,
                child: _OrangeBubble(icon: icons[currentIndex]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrangeBubble extends StatelessWidget {
  final IconData icon;
  const _OrangeBubble({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF89A50), _brandOrange],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33F5832A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // thin white ring like your mock
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
          Icon(icon, size: 22, color: Colors.white),
        ],
      ),
    );
  }
}
