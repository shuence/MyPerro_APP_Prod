import 'package:flutter/material.dart';
import '../../widgets/myperro_bottom_nav.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg      = Color(0xFFF7F7F7);
const _grey900     = Color(0xFF202020);
const _grey700     = Color(0xFF6B6B6B);
const _grey600     = Color(0xFF8E8E8E);
const _grey300     = Color(0xFFE9E9E9);

const double _cardRadius = 18;

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _Routine {
  String name;
  bool enabled;
  final List<_Activity> activities;
  _Routine(this.name, {this.enabled = true, List<_Activity>? activities})
      : activities = activities ?? [];
}

class _Activity {
  String name;
  TimeOfDay? start;
  TimeOfDay? end;
  _Activity(this.name, {this.start, this.end});
}

class _RoutineScreenState extends State<RoutineScreen> {
  final List<_Routine> _routines = [
    _Routine('Basic Daily Routine', activities: [
      _Activity('Wake up', start: const TimeOfDay(hour: 8, minute: 0)),
      _Activity('Breakfast', start: const TimeOfDay(hour: 8, minute: 15)),
      _Activity('Potty Break', start: const TimeOfDay(hour: 8, minute: 30)),
      _Activity('To Caretaker', start: const TimeOfDay(hour: 9, minute: 0)),
      _Activity('Outdoor Walk', start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 11, minute: 0)),
      _Activity('Play Time', start: const TimeOfDay(hour: 14, minute: 0)),
      _Activity('Outdoor Walk', start: const TimeOfDay(hour: 16, minute: 0), end: const TimeOfDay(hour: 16, minute: 30)),
      _Activity('Handover', start: const TimeOfDay(hour: 18, minute: 0)),
      _Activity('Dinner', start: const TimeOfDay(hour: 19, minute: 30)),
      _Activity('Sleep', start: const TimeOfDay(hour: 22, minute: 0)),
    ]),
    _Routine('Athletic Routine', enabled: false, activities: [
      _Activity('Run', start: const TimeOfDay(hour: 6, minute: 0), end: const TimeOfDay(hour: 6, minute: 30)),
    ]),
    _Routine('Aged Dog Routine', enabled: false, activities: [
      _Activity('Gentle Walk', start: const TimeOfDay(hour: 7, minute: 30), end: const TimeOfDay(hour: 8, minute: 0)),
    ]),
  ];

  int _followingIndex = 0;

  void _onBottomTap(BuildContext context, int i) {
    switch (i) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications (TODO)')),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Images (TODO)')),
        );
        break;
      case 2:
        // center paw: stay
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scanner (TODO)')),
        );
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile/Settings (TODO)')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final ts = media.textScaleFactor.clamp(1.0, 1.3);
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(ts)),
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Routine', style: TextStyle(color: _grey900)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _showCreateRoutineDialog, // quick access to create
              icon: const Icon(Icons.add_circle_outline, color: _brandOrange),
              tooltip: 'Create Routine',
            )
          ],
        ),

        bottomNavigationBar: MyPerroBottomNav(
          currentIndex: 2,
          onTap: (i) => _onBottomTap(context, i),
        ),

        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
          children: [
            _FollowingPill(
              title: _routines[_followingIndex].name,
              onSettings: () {},
            ),
            const SizedBox(height: 12),

            for (int i = 0; i < _routines.length; i++) ...[
              _RoutineCard(
                routine: _routines[i],
                initiallyExpanded: i == _followingIndex,
                onToggleEnabled: (v) => setState(() => _routines[i].enabled = v),
                onAddMore: () => _showAddActivityDialog(_routines[i]),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  // ---- Dialogs ----

  Future<void> _showCreateRoutineDialog() async {
    final nameCtrl = TextEditingController(text: 'New Routine');

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _SoftDialog(
        title: 'Routine Name*',
        primaryText: 'Next',
        onPrimary: () => Navigator.pop(ctx, true),
        child: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );

    if (ok == true) {
      setState(() {
        _routines.add(_Routine(nameCtrl.text));
        _followingIndex = _routines.length - 1;
      });
    }
  }

  Future<void> _showAddActivityDialog(_Routine routine) async {
    final nameCtrl = TextEditingController(text: '');
    TimeOfDay? start;
    TimeOfDay? end;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setLocal) {
          Future<void> pickStart() async {
            final res = await showTimePicker(
              context: ctx,
              initialTime: start ?? const TimeOfDay(hour: 8, minute: 0),
            );
            if (res != null) setLocal(() => start = res);
          }

          Future<void> pickEnd() async {
            final res = await showTimePicker(
              context: ctx,
              initialTime: end ?? const TimeOfDay(hour: 9, minute: 0),
            );
            if (res != null) setLocal(() => end = res);
          }

          return _SoftDialog(
            title: routine.name,
            primaryText: 'Confirm',
            onPrimary: () {
              if (nameCtrl.text.trim().isEmpty || start == null) return;
              setState(() {
                routine.activities.add(_Activity(nameCtrl.text, start: start, end: end));
              });
              Navigator.pop(ctx);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Activity Name*'),
                const SizedBox(height: 6),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _grey300)),
                  ),
                  child: TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Start Time*'),
                const SizedBox(height: 6),
                _TimeRow(
                  label: start == null ? '--' : _fmt(start!),
                  onTap: pickStart,
                ),
                const SizedBox(height: 14),
                const Text('End Time'),
                const SizedBox(height: 6),
                _TimeRow(
                  label: end == null ? '--' : _fmt(end!),
                  onTap: pickEnd,
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final mm = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$mm $ampm';
  }
}

// ===== Widgets for Routine screen =====

class _FollowingPill extends StatelessWidget {
  final String title;
  final VoidCallback onSettings;
  const _FollowingPill({required this.title, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _grey300),
      ),
      child: Row(
        children: [
          const Text('Following', style: TextStyle(color: _grey600, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700, color: _grey900)),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onSettings,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0x14F5832A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.settings_outlined, size: 16, color: _brandOrange),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineCard extends StatefulWidget {
  final _Routine routine;
  final bool initiallyExpanded;
  final ValueChanged<bool> onToggleEnabled;
  final VoidCallback onAddMore;

  const _RoutineCard({
    required this.routine,
    required this.initiallyExpanded,
    required this.onToggleEnabled,
    required this.onAddMore,
  });

  @override
  State<_RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<_RoutineCard> {
  late bool expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF8ED),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Following',
                            style: TextStyle(color: Color(0xFF5CB85C), fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.routine.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _grey900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.routine.enabled,
                  activeThumbColor: _brandOrange,
                  onChanged: (v) => widget.onToggleEnabled(v),
                ),
              ],
            ),
          ),

          if (expanded) const Divider(height: 1),

          // Activities
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                children: [
                  for (final a in widget.routine.activities) ...[
                    _ActivityRow(activity: a),
                    const SizedBox(height: 8),
                  ],
                  InkWell(
                    onTap: widget.onAddMore,
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 18, color: _grey700),
                          SizedBox(width: 8),
                          Text('Add More', style: TextStyle(color: _grey700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _Activity activity;
  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final timeStr = () {
      final s = activity.start;
      final e = activity.end;
      String fmt(TimeOfDay t) {
        final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
        final mm = t.minute.toString().padLeft(2, '0');
        final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
        return '$h:$mm $ampm';
      }

      if (s == null) return '--';
      if (e == null) return fmt(s);
      return '${fmt(s)} - ${fmt(e)}';
    }();

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _grey300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(activity.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _grey900)),
          ),
          Text(timeStr, style: const TextStyle(color: _grey700)),
          const SizedBox(width: 10),
          const Icon(Icons.edit_outlined, size: 18, color: _grey700),
          const SizedBox(width: 6),
          const Icon(Icons.close, size: 18, color: _grey700),
        ],
      ),
    );
  }
}

class _SoftDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final String primaryText;
  final VoidCallback onPrimary;

  const _SoftDialog({
    required this.title,
    required this.child,
    required this.primaryText,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w700, color: _grey900)),
      content: child,
      actions: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: onPrimary,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              backgroundColor: _brandOrange,
              foregroundColor: Colors.white,
            ),
            child: Text(primaryText, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TimeRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 44,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _grey300)),
        ),
        child: Text(label, style: const TextStyle(color: _grey900)),
      ),
    );
  }
}
