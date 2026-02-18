import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/myperro_bottom_nav.dart';

/// ---- Design tokens (match your app) ----
const _brandOrange = Color(0xFFF5832A);
const _pageBg      = Color(0xFFF7F7F7);
const _grey900     = Color(0xFF202020);
const _grey700     = Color(0xFF6B6B6B);
const _grey600     = Color(0xFF8E8E8E);
const _grey500     = Color(0xFFA7A7A7);
const _grey300     = Color(0xFFE9E9E9);

enum _PanelState { collapsed, expanded, dateMode, singlePet }

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  _PanelState _panel = _PanelState.collapsed;
  int _selectedPet = 0;
  DateTime _date = DateTime.now();
  Position? _currentPosition;
  bool _isLocating = false;
  String? _locationError;

  // simple data for carousel
  final _pets = const [
    ('Krypto', 'assets/images/pet_avatar.png'),
    ('Baby',   'assets/images/pet_avatar.png'),
    ('Loki',   'assets/images/pet_avatar.png'),
    ('Leo',    'assets/images/pet_avatar.png'),
  ];

  void _toggleExpand() {
    setState(() {
      _panel = _panel == _PanelState.expanded ? _PanelState.collapsed : _PanelState.expanded;
    });
  }

  void _toggleDateMode() {
    setState(() {
      _panel = _panel == _PanelState.dateMode ? _PanelState.collapsed : _PanelState.dateMode;
    });
  }

  void _selectPet(int i) {
    setState(() {
      if (_panel == _PanelState.singlePet && _selectedPet == i) {
        _panel = _PanelState.collapsed; // exit single pet
        _selectedPet = 0;
      } else {
        _selectedPet = i;
        _panel = _PanelState.singlePet;
      }
    });
  }

  void _prevDate() => setState(() => _date = _date.subtract(const Duration(days: 1)));
  void _nextDate() => setState(() => _date = _date.add(const Duration(days: 1)));

  // bottom nav wiring
  void _onBottomTap(int i) {
    // order: 0 bell, 1 gallery, 2 paw (dashboard), 3 map (here), 4 profile
    if (i == 2) {
      // Back to dashboard
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    } else if (i == 3) {
      // already here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tab $i (wire later)')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw const LocationServiceDisabledException();
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const PermissionDeniedException('Location permission denied');
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (mounted) setState(() => _currentPosition = position);
    } catch (e) {
      if (mounted) setState(() => _locationError = e.toString());
    } finally {
      if (mounted) setState(() => _isLocating = false);
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
            icon: const Icon(Icons.arrow_back, color: _grey900),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Map', style: TextStyle(color: _grey900)),
          centerTitle: true,
        ),
        bottomNavigationBar: MyPerroBottomNav(
          currentIndex: 3,
          onTap: _onBottomTap,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: _MapCanvas(
                  singlePet: _panel == _PanelState.singlePet ? _pets[_selectedPet].$1 : null,
                  position: _currentPosition,
                  onCenter: _initLocation,
                ),
              ),
              if (_isLocating)
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 72),
                    child: CircularProgressIndicator(color: _brandOrange),
                  ),
                ),
              if (_locationError != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 72),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _locationError!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              if (_currentPosition != null)
                Positioned(
                  left: 16,
                  top: 72,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      'Lat: ${_currentPosition!.latitude.toStringAsFixed(5)} | '
                      'Lng: ${_currentPosition!.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(color: _grey700, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    _TopChip(
                      icon: Icons.info_outline_rounded,
                      label: 'Track your pets here!',
                      onTap: () {},
                    ),
                    const Spacer(),
                    if (_panel == _PanelState.dateMode) ...[
                      _RoundSquare(icon: Icons.chevron_left, onTap: _prevDate),
                      const SizedBox(width: 6),
                      _TopChip(
                        icon: Icons.calendar_month_outlined,
                        label: _fmtDate(_date),
                        onTap: _toggleDateMode,
                      ),
                      const SizedBox(width: 6),
                      _RoundSquare(icon: Icons.chevron_right, onTap: _nextDate),
                    ] else
                      _TopChip(
                        icon: Icons.calendar_month_outlined,
                        label: 'Today',
                        onTap: _toggleDateMode,
                      ),
                  ],
                ),
              ),
              _BottomPanel(
                state: _panel,
                pets: _pets,
                selectedPet: _selectedPet,
                onSelectPet: _selectPet,
                onToggleExpand: _toggleExpand,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const w = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${w[d.weekday % 7]} ${d.day.toString().padLeft(2,'0')} ${m[d.month - 1]} ${d.year}';
  }
}

/// ================= Map painter (placeholder) =================
class _MapCanvas extends StatelessWidget {
  final String? singlePet;
  final Position? position;
  final VoidCallback onCenter;
  const _MapCanvas({this.singlePet, this.position, required this.onCenter});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FakeMapPainter(),
      child: Stack(
        children: [
          // route pin
          Positioned(
            right: 18,
            bottom: 100,
            child: _RoundSquare(icon: Icons.my_location, onTap: onCenter),
          ),
          // if single pet, show its chip near bottom-right
          if (singlePet != null)
            Positioned(
              right: 16,
              bottom: 160,
              child: _SinglePetChip(name: singlePet!),
            ),
          // pulse marker for current location
          if (position != null)
            const Align(
              alignment: Alignment.center,
              child: _CurrentLocationPulse(),
            ),
        ],
      ),
    );
  }
}

class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // subtle grid
    final grid = Paint()..color = const Color(0xFFEFEFEF)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // walking route polyline
    final route = Paint()
      ..color = _brandOrange
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..lineTo(size.width * 0.32, size.height * 0.45)
      ..lineTo(size.width * 0.62, size.height * 0.50)
      ..lineTo(size.width * 0.78, size.height * 0.74);
    canvas.drawPath(path, route);

    // a small “start” marker
    final pin = Paint()..color = _brandOrange;
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.72), 6, pin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ================= Top chips & small UI pieces =================
class _TopChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _TopChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: _grey300),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: _grey700),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: _grey900, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundSquare extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundSquare({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: _grey300),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Icon(icon, size: 20, color: _grey700),
        ),
      ),
    );
  }
}

class _SinglePetChip extends StatelessWidget {
  final String name;
  const _SinglePetChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.only(left: 6, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _grey300),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFFFFE0B2)),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: _grey900)),
        ],
      ),
    );
  }
}

/// ================= Bottom Panel (all variants) =================
class _BottomPanel extends StatelessWidget {
  final _PanelState state;
  final List<(String,String)> pets;
  final int selectedPet;
  final ValueChanged<int> onSelectPet;
  final VoidCallback onToggleExpand;

  const _BottomPanel({
    required this.state,
    required this.pets,
    required this.selectedPet,
    required this.onSelectPet,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final collapsedH = 110.0;
    final expandedH  = media.size.height * 0.46;

    final targetH = switch (state) {
      _PanelState.expanded => expandedH,
      _PanelState.singlePet => collapsedH,
      _PanelState.dateMode => collapsedH,
      _PanelState.collapsed => collapsedH,
    };

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      left: 0,
      right: 0,
      bottom: 0,
      height: targetH + media.padding.bottom,
      child: _PanelShell(
        child: Column(
          children: [
            // handle row
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 56, height: 5, decoration: BoxDecoration(color: _grey300, borderRadius: BorderRadius.circular(3))),
                ],
              ),
            ),
            // avatar carousel
            SizedBox(
              height: 66,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final (name, asset) = pets[i];
                  final selected = state == _PanelState.singlePet && i == selectedPet;
                  return _PetBubble(
                    name: name,
                    asset: asset,
                    selected: selected,
                    onTap: () => onSelectPet(i),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: pets.length,
              ),
            ),

            // control row just above nav
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _BarIcon(icon: Icons.home_outlined),
                _BarIcon(icon: Icons.chat_bubble_outline),
                _BarIcon(icon: Icons.pets_outlined),
                _BarIcon(icon: Icons.crop_free_rounded),
                _BarIcon(icon: Icons.person_outline),
              ],
            ),

            // expanded content
            if (state == _PanelState.expanded) ...[
              const SizedBox(height: 12),
              const _SectionTitle('Tasks Completed Today'),
              const SizedBox(height: 12),
              const _StatsRow(), // 3 half-rings
              const SizedBox(height: 12),
              const _FeedCard(imageAsset: 'assets/images/pet_feed_1.jpg'),
              const SizedBox(height: 10),
              const _FeedCard(imageAsset: 'assets/images/pet_feed_2.jpg'),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _Pill(text: 'Start Walking', leading: Icons.run_circle_outlined, onTap: () {}),
                    const SizedBox(width: 8),
                    _Pill(text: 'Contact a Walker', leading: Icons.person_pin_circle_outlined, onTap: () {}),
                  ],
                ),
              ),
            ],

            // expand/collapse button (orange)
            const SizedBox(height: 8),
            _ExpandButton(
              expanded: state == _PanelState.expanded,
              onTap: onToggleExpand,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _PanelShell extends StatelessWidget {
  final Widget child;
  const _PanelShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, -8))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        child: child,
      ),
    );
  }
}

class _PetBubble extends StatelessWidget {
  final String name;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _PetBubble({
    required this.name,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFFE0B2),
                backgroundImage: AssetImage(asset),
                onBackgroundImageError: (_, __) {},
              ),
              if (selected)
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: _brandOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 52,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _grey700, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _BarIcon extends StatelessWidget {
  final IconData icon;
  const _BarIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: _grey700, size: 22);
  }
}

class _ExpandButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _ExpandButton({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF89A50), _brandOrange],
          ),
          boxShadow: [BoxShadow(color: Color(0x33F5832A), blurRadius: 16, offset: Offset(0, 8))],
        ),
        child: Icon(expanded ? Icons.expand_more : Icons.expand_less, color: Colors.white),
      ),
    );
  }
}

/// ================= Expanded panel content =================
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: _grey700, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0x14F5832A),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.tune_rounded, size: 16, color: _brandOrange),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _RingStat(valueText: '4.5 Km', label: 'Walk', icon: Icons.pets, percent: 0.9, color: _brandOrange),
          _RingStat(valueText: '8hrs',   label: 'Home', icon: Icons.home, percent: 0.66, color: Color(0xFF53D6E5)),
          _RingStat(valueText: '98%',    label: 'Safe', icon: Icons.shield_outlined, percent: 0.98, color: Color(0xFF52D16D)),
        ],
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final String imageAsset;
  const _FeedCard({required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          border: Border.all(color: _grey300),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.image_outlined, color: _grey500, size: 40),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData leading;
  final VoidCallback onTap;
  const _Pill({required this.text, required this.leading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: _grey300),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(leading, size: 18, color: _grey700),
                const SizedBox(width: 8),
                Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: _grey900)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= Half-ring (same visual as dashboard) =================
class _RingStat extends StatelessWidget {
  final String valueText, label;
  final IconData icon;
  final double percent;
  final Color color;
  const _RingStat({
    required this.valueText,
    required this.label,
    required this.icon,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 82,
            height: 52,
            child: CustomPaint(
              painter: _HalfRingPainter(progress: percent, color: color, thickness: 10, trackColor: const Color(0xFFE6E6E6)),
            ),
          ),
          const SizedBox(height: 6),
          Text(valueText, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _grey900)),
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
  final double progress;   // 0..1
  final double thickness;
  final Color color;
  final Color trackColor;

  _HalfRingPainter({
    this.progress = 0,
    required this.color,
    required this.thickness,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const start = 3.1415926535;
    const sweep = 3.1415926535;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final prog = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(10), start, sweep, false, track);
    canvas.drawArc(rect.deflate(10), start, sweep * progress.clamp(0, 1), false, prog);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ================= Pulse marker for current location =================
class _CurrentLocationPulse extends StatefulWidget {
  const _CurrentLocationPulse();

  @override
  State<_CurrentLocationPulse> createState() => _CurrentLocationPulseState();
}

class _CurrentLocationPulseState extends State<_CurrentLocationPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();
  late final Animation<double> _scale = Tween(begin: 0.8, end: 1.3).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );
  late final Animation<double> _opacity = Tween(begin: 0.8, end: 0.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _brandOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: _brandOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x1AF5832A), blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
