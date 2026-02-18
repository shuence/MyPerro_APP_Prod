import 'package:flutter/material.dart';
import '../../widgets/myperro_bottom_nav.dart';
import '../map/map_home_screen.dart';
import 'routine_screen.dart'; // ← add this import

const _brandOrange = Color(0xFFF5832A);
const _pageBg      = Color(0xFFF7F7F7);
const _grey900     = Color(0xFF202020);
const _grey700     = Color(0xFF6B6B6B);
const _grey600     = Color(0xFF8E8E8E);
const _grey300     = Color(0xFFE9E9E9);

const double _cardRadius = 18;

class PetCardExpandedScreen extends StatefulWidget {
  final String petName;
  final String petBreedAge;
  final String avatarAsset;

  final String walkText;
  final double walkPct;
  final String homeText;
  final double homePct;
  final String safeText;
  final double safePct;
  final double tasksProgress;

  const PetCardExpandedScreen({
    super.key,
    required this.petName,
    required this.petBreedAge,
    required this.avatarAsset,
    required this.walkText,
    required this.walkPct,
    required this.homeText,
    required this.homePct,
    required this.safeText,
    required this.safePct,
    required this.tasksProgress,
  });

  @override
  State<PetCardExpandedScreen> createState() => _PetCardExpandedScreenState();
}

class _PetCardExpandedScreenState extends State<PetCardExpandedScreen> {
  int _mode = 0; // 0 Walk, 1 Home

  Future<void> _confirmModeChange(int next) async {
    if (_mode == next) return;
    final to   = next == 0 ? 'Walk mode' : 'Home mode';

    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 6),
              Text('Are you sure you want to switch mode?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _grey900, fontSize: 14)),
              SizedBox(height: 16),
            ],
          ),
          actionsPadding: EdgeInsets.zero,
          actions: [
            SizedBox(
              height: 44,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: _brandOrange),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes'),
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No', style: TextStyle(color: _grey700)),
              ),
            ),
          ],
        );
      },
    );

    if (yes == true) {
      setState(() => _mode = next);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to $to')),
      );
    }
  }

  void _onBottomTap(BuildContext context, int i) {
    // Tabs: 0 bell, 1 gallery, 2 paw, 3 MAP, 4 profile
    if (i == 2) {
      Navigator.of(context).pop();          // paw → back to dashboard
    } else if (i == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MapHomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tab $i (wired later)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final ts = media.textScaleFactor.clamp(1.0, 1.3);
    return MediaQuery(
      data: media.copyWith(textScaleFactor: ts),
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(''),
        ),

        bottomNavigationBar: MyPerroBottomNav(
          currentIndex: 2,
          onTap: (i) => _onBottomTap(context, i),
        ),

        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 140),
              children: [
                _CardShell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: const [
                          _SquareIcon(icon: Icons.description_outlined),
                          Spacer(),
                          _SquareIcon(icon: Icons.close),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Column(
                        children: [
                          Text(widget.petName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: _grey900,
                              )),
                          const SizedBox(height: 2),
                          Text(widget.petBreedAge,
                              style: const TextStyle(color: _grey600, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      const _StatusRow(
                        icon: Icons.check_circle,
                        iconColor: Color(0xFF46C46E),
                        label: 'Safe',
                        trailing: _StatusTrailingDot(text: 'At Home'),
                      ),
                      const SizedBox(height: 8),
                      const _StatusRow(
                        icon: Icons.check_circle,
                        iconColor: Color(0xFF46C46E),
                        label: 'Fence Feedback Active',
                        trailing: _TogglePill(isOn: true),
                      ),
                      const SizedBox(height: 8),
                      _StatusRow(
                        icon: Icons.directions_walk,
                        iconColor: _grey700,
                        label: 'Currently Walking',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _TinySquare(icon: Icons.location_pin),
                            const SizedBox(width: 6),
                            _SmallTwinToggle(
                              index: _mode,
                              onChanged: (i) => _confirmModeChange(i),
                            ),
                            const SizedBox(width: 6),
                            const _TinySquare(icon: Icons.settings_outlined),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      _InsetCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Expanded(
                                  child: Text('Tasks Completed Today',
                                      style: TextStyle(color: _grey600, fontSize: 12)),
                                ),
                                _RoundChipIcon(
                                  icon: Icons.tune_rounded,
                                  bg: Color(0x14F5832A),
                                  iconColor: _brandOrange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _ThinProgress(widget.tasksProgress),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _RingStat(valueText: widget.walkText, label: 'Walk', icon: Icons.pets, percent: widget.walkPct, color: _brandOrange),
                          _RingStat(valueText: widget.homeText, label: 'Home', icon: Icons.home, percent: widget.homePct, color: Color(0xFF53D6E5)),
                          _RingStat(valueText: widget.safeText, label: 'Safe', icon: Icons.shield_outlined, percent: widget.safePct, color: Color(0xFF52D16D)),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // >>> MAKE THIS PILL CLICKABLE <<<
                      _InsetCard(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RoutineScreen()),
                              );
                            },
                            child: Row(
                              children: const [
                                Text('Following', style: TextStyle(color: _grey600, fontSize: 12)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text('Basic Daily Routine',
                                      style: TextStyle(fontWeight: FontWeight.w700, color: _grey900)),
                                ),
                                _RoundChipIcon(
                                  icon: Icons.settings_outlined,
                                  bg: Color(0x14F5832A),
                                  iconColor: _brandOrange,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      const _MapCard(),
                    ],
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFE0B2),
                backgroundImage: AssetImage(widget.avatarAsset),
                onBackgroundImageError: (_, __) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== Reused widgets (unchanged below) ======
class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 24, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}

class _InsetCard extends StatelessWidget {
  final Widget child;
  const _InsetCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _grey300),
      ),
      child: child,
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final IconData icon;
  const _SquareIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _grey300)),
      child: Icon(icon, size: 18, color: _grey700),
    );
  }
}

class _RoundChipIcon extends StatelessWidget {
  final IconData icon; final Color bg; final Color iconColor;
  const _RoundChipIcon({required this.icon, required this.bg, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon; final Color iconColor; final String label; final Widget trailing;
  const _StatusRow({required this.icon, required this.iconColor, required this.label, required this.trailing});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(color: _grey900, fontSize: 14))),
        trailing,
      ],
    );
  }
}

class _StatusTrailingDot extends StatelessWidget {
  final String text;
  const _StatusTrailingDot({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.circle, size: 8, color: Color(0xFF46C46E)),
        SizedBox(width: 6),
        Text('At Home', style: TextStyle(color: _grey700, fontSize: 13)),
      ],
    );
  }
}

class _TogglePill extends StatelessWidget {
  final bool isOn;
  const _TogglePill({required this.isOn});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46, height: 26, padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: isOn ? _brandOrange : const Color(0xFFE6E6E6)),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
      ),
    );
  }
}

class _TinySquare extends StatelessWidget {
  final IconData icon;
  const _TinySquare({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _grey300)),
      child: Icon(icon, size: 16, color: _grey700),
    );
  }
}

class _SmallTwinToggle extends StatelessWidget {
  final int index; final ValueChanged<int> onChanged;
  const _SmallTwinToggle({required this.index, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78, height: 28,
      decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(16), border: Border.all(color: _grey300)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == 0 ? const Color(0xFFEEEEEE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('On', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(1),
              child: Container(
                alignment: Alignment.center,
                child: Text('Home', style: TextStyle(fontSize: 12, color: index == 1 ? _grey900 : _grey700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThinProgress extends StatelessWidget {
  final double value;
  const _ThinProgress(this.value);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          color: _brandOrange,
          backgroundColor: const Color(0xFFE6E6E6),
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _grey300),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: const Center(child: Icon(Icons.map_outlined, size: 56, color: Colors.black26)),
    );
  }
}

class _RingStat extends StatelessWidget {
  final String valueText, label;
  final IconData icon;
  final double percent;
  final Color color;
  const _RingStat({required this.valueText, required this.label, required this.icon, required this.percent, required this.color});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 82, height: 52,
            child: CustomPaint(
              painter: _HalfRingPainter(progress: percent, color: color, thickness: 10, trackColor: const Color(0xFFE6E6E6)),
            ),
          ),
          const SizedBox(height: 6),
          Text(valueText, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _grey900)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: _grey600),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: _grey600, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HalfRingPainter extends CustomPainter {
  final double progress; final double thickness; final Color color; final Color trackColor;
  _HalfRingPainter({this.progress = 0, required this.color, required this.thickness, required this.trackColor});
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const start = 3.1415926535; const sweep = 3.1415926535;
    final track = Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = thickness..strokeCap = StrokeCap.round;
    final prog  = Paint()..color = color     ..style = PaintingStyle.stroke..strokeWidth = thickness..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(10), start, sweep, false, track);
    canvas.drawArc(rect.deflate(10), start, sweep * progress.clamp(0, 1), false, prog);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
