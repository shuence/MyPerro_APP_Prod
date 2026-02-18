import 'package:flutter/material.dart';
import 'package:myperro_app_merged/ui/screens/chat/chat_list_screen.dart';
import '../../widgets/myperro_bottom_nav.dart';
import '../map/map_home_screen.dart';
import 'pet_card_expanded_screen.dart';
import '../notifications/notifications_screen.dart';
import 'doctors_screen.dart';  // Import the doctor appointment booking screen
import '../profile/profile_screen.dart';
import '../scanner/qr_scanner_screen.dart';

// ---- Design tokens ----
const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);
const _grey300 = Color(0xFFE9E9E9);

// Card + controls sizes
const double _cardRadius = 18;
const double _pillRadius = 24;
const double _avatarR = 18;

// Visible stats on the pet card.
class PetStats {
  final String walkText; // e.g., "4.6 Km"
  final double walkPct; // 0..1
  final String homeText; // e.g., "8hrs"
  final double homePct; // 0..1
  final String safeText; // e.g., "98%"
  final double safePct; // 0..1
  final double tasksProgress; // 0..1

  const PetStats({
    required this.walkText,
    required this.walkPct,
    required this.homeText,
    required this.homePct,
    required this.safeText,
    required this.safePct,
    required this.tasksProgress,
  });
}

class DashboardScreen extends StatefulWidget {
  final String petName;
  final String petBreedAge;

  const DashboardScreen({
    super.key,
    required this.petName,
    this.petBreedAge = '5 yrs old White Labrador Retriever',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // 0 bell, 1 chat, 2 dashboard, 3 map, 4 profile

  static const stats = PetStats(
    walkText: '4.5 Km', walkPct: 0.90,
    homeText: '8hrs', homePct: 0.66,
    safeText: '98%', safePct: 0.98,
    tasksProgress: 0.58,
  );

  // Routine data
  List<String> activeRoutine = [];

  void _openMap() => setState(() => _selectedIndex = 3);
  void _onBottomTap(int i) => setState(() => _selectedIndex = i);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final ts = media.textScaleFactor.clamp(1.0, 1.3);

    final pages = <Widget>[
      NotificationsScreen(petName: widget.petName), // 0
      const ChatListScreen(), // 1
      _DashboardBody( // 2
        petName: widget.petName,
        petBreedAge: widget.petBreedAge,
        onOpenMap: _openMap,
        activeRoutine: activeRoutine,
      ),
      const MapHomeScreen(), // 3
      const ProfileScreen(), // 4 - Updated to use ProfileScreen
    ];

    return MediaQuery(
      data: media.copyWith(textScaleFactor: ts),
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: _selectedIndex == 2 ? _TopBar(onDoctorsIconTap: _openDoctorsScreen) : null,
        bottomNavigationBar: MyPerroBottomNav(
          currentIndex: _selectedIndex,
          onTap: _onBottomTap,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
    );
  }

  // Navigate to the doctors screen for booking appointments
  void _openDoctorsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorsScreen(
          onAppointmentBooked: _addToRoutine, // Pass the callback to add the appointment to the routine
        ),
      ),
    );
  }

  // Function to add the appointment to the active routine
    void _addToRoutine(String doctorName, String appointmentTime) {
    setState(() {
      activeRoutine.add('$doctorName - $appointmentTime');
    });
  }
}

// ----------------- App bar (dashboard only) -----------------
class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onDoctorsIconTap;

  const _TopBar({required this.onDoctorsIconTap});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  Widget _square(IconData i, {VoidCallback? onTap}) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _grey300),
          ),
          child: Icon(i, size: 18, color: _grey700),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: const SizedBox.shrink(),
      actions: [
        _square(Icons.medical_services_outlined),
        const SizedBox(width: 12),
        _square(Icons.local_hospital_outlined, onTap: onDoctorsIconTap),
        const SizedBox(width: 12),
        _square(Icons.support_agent_outlined),
        const SizedBox(width: 12),
        _square(
          Icons.person_add_alt_1_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerScreen(scanType: 'caretaker'),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        _square(
          Icons.qr_code_scanner,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerScreen(scanType: 'family'),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final String petName;
  final String petBreedAge;
  final VoidCallback onOpenMap;
  final List<String> activeRoutine;

  const _DashboardBody({
    required this.petName,
    required this.petBreedAge,
    required this.onOpenMap,
    required this.activeRoutine,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          const _CaretakerCard(
            name: 'Mahesh Chaurasiya',
            bookedText: 'Booked on 15th August',
            routineTitle: 'Basic Daily Routine',
            avatarAsset: 'assets/images/user_avatar.png',
            progress: 0.34,
          ),
          const SizedBox(height: 16),
          _PetCard(
            petName: petName,
            petSubtitle: petBreedAge,
            avatarAsset: 'assets/images/pet_avatar.png',
            stats: _DashboardScreenState.stats,
            onOpenPet: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PetCardExpandedScreen(
                    petName: petName,
                    petBreedAge: petBreedAge,
                    avatarAsset: 'assets/images/pet_avatar.png',
                    walkText: _DashboardScreenState.stats.walkText,
                    walkPct: _DashboardScreenState.stats.walkPct,
                    homeText: _DashboardScreenState.stats.homeText,
                    homePct: _DashboardScreenState.stats.homePct,
                    safeText: _DashboardScreenState.stats.safeText,
                    safePct: _DashboardScreenState.stats.safePct,
                    tasksProgress: _DashboardScreenState.stats.tasksProgress,
                  ),
                ),
              );
            },
            onViewMap: onOpenMap,
            onViewDocs: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Documents (TODO)'))),
          ),
          const SizedBox(height: 16),
          
          // Display Active Routine (Appointments)
          if (activeRoutine.isNotEmpty) ...[
            const Text(
              'Active Routine', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: _grey900,
              ),
            ),
            const SizedBox(height: 8),
            ...activeRoutine.map((routineItem) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  routineItem, 
                  style: const TextStyle(fontSize: 14, color: _grey900),
                ),
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              ),
            )).toList(),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

// ----------------- Shared pieces (unchanged) -----------------
class _CardShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _CardShell({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardRadius),
        child: card,
      ),
    );
  }
}

class _ThinProgress extends StatelessWidget {
  final double value; // 0..1
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

class _Avatar extends StatelessWidget {
  final String asset;
  final Color bg;
  final double radius;
  const _Avatar({required this.asset, required this.bg, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      backgroundImage: AssetImage(asset),
      onBackgroundImageError: (_, __) {},
    );
  }
}

// ----------------- Caretaker card -----------------
class _CaretakerCard extends StatelessWidget {
  final String name, bookedText, routineTitle, avatarAsset;
  final double progress;

  const _CaretakerCard({
    required this.name,
    required this.bookedText,
    required this.routineTitle,
    required this.avatarAsset,
    required this.progress,
  });

  Widget _squareIcon(IconData i) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _grey300),
        ),
        child: Icon(i, size: 18, color: _grey700),
      );

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(asset: avatarAsset, bg: const Color(0xFFECECEC), radius: _avatarR),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _grey900)),
                    Text(bookedText,
                        style: const TextStyle(color: _grey600, fontSize: 12)),
                  ],
                ),
              ),
              _squareIcon(Icons.call_outlined),
              const SizedBox(width: 8),
              _squareIcon(Icons.chat_bubble_outline),
              const SizedBox(width: 8),
              _squareIcon(Icons.check_box_outline_blank),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Tasks Completed Today',
              style: TextStyle(color: _grey600, fontSize: 12)),
          const SizedBox(height: 6),
          _ThinProgress(progress),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _grey300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('Following', style: TextStyle(color: _grey600)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Basic Daily Routine',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, color: _grey900)),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0x14F5832A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      size: 18, color: _brandOrange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- Pet card -----------------
class _PetCard extends StatelessWidget {
  final String petName, petSubtitle, avatarAsset;
  final PetStats stats;
  final VoidCallback onOpenPet;
  final VoidCallback onViewMap;
  final VoidCallback onViewDocs;

  const _PetCard({
    required this.petName,
    required this.petSubtitle,
    required this.avatarAsset,
    required this.stats,
    required this.onOpenPet,
    required this.onViewMap,
    required this.onViewDocs,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      onTap: onOpenPet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _Avatar(asset: avatarAsset, bg: const Color(0xFFFFE0B2), radius: _avatarR),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(petName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: _grey900)),
                    Text(petSubtitle,
                        style: const TextStyle(color: _grey600, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _grey300),
                ),
                child: const Icon(Icons.more_horiz, size: 18, color: _grey700),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text('Tasks Completed Today',
              style: TextStyle(color: _grey600, fontSize: 12)),
          const SizedBox(height: 6),
          _ThinProgress(stats.tasksProgress),
          const SizedBox(height: 12),

          // Semi-rings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RingStat(
                valueText: stats.walkText,
                label: 'Walk',
                icon: Icons.pets,
                percent: stats.walkPct,
                color: _brandOrange,
              ),
              _RingStat(
                valueText: stats.homeText,
                label: 'Home',
                icon: Icons.home,
                percent: stats.homePct,
                color: const Color(0xFF53D6E5),
              ),
              _RingStat(
                valueText: stats.safeText,
                label: 'Safe',
                icon: Icons.shield_outlined,
                percent: stats.safePct,
                color: const Color(0xFF52D16D),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom pills (wired)
          Row(
            children: [
              Expanded(
                child: _PillAction(icon: Icons.map_outlined, label: 'View Map', onTap: onViewMap),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PillAction(icon: Icons.receipt_long_outlined, label: 'View Documents', onTap: onViewDocs),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PillAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_pillRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_pillRadius),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(_pillRadius),
            border: Border.all(color: _grey300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: _grey700),
              const SizedBox(width: 8),
              Text(label,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600, color: _grey900)),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Rings -----------------
class _RingStat extends StatelessWidget {
  final String valueText, label;
  final IconData icon;
  final double percent; // 0..1
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
              painter: _HalfRingPainter(
                progress: percent,
                color: color,
                thickness: 10,
                trackColor: const Color(0xFFE6E6E6),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            valueText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w800, fontSize: 14, height: 1.05, color: _grey900),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: _grey600),
              const SizedBox(width: 4),
              Text(label,
                  style:
                      const TextStyle(color: _grey600, fontSize: 11, height: 1.05)),
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
    const start = 3.1415926535; // π
    const sweep = 3.1415926535; // 180°

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
