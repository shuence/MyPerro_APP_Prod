import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'onboarding_pet_uploads_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _titleBlack  = Color(0xFF1F1F1F);
const _dividerGrey = Color(0xFFE0E0E0);

// ===== Hero sizing tuned to look like your mock =====
const double _circleSize   = 230;  // peach circle
const double _imageSize    = 230;  // dog art (same size to sit nicely)
const double _imageOffsetY = 6;    // tiny push down

class OnboardingPetCredentialsScreen extends StatefulWidget {
  const OnboardingPetCredentialsScreen({super.key});

  @override
  State<OnboardingPetCredentialsScreen> createState() => _OnboardingPetCredentialsScreenState();
}

class _OnboardingPetCredentialsScreenState extends State<OnboardingPetCredentialsScreen> {
  final _nameCtrl = TextEditingController();
  final _birthdayCtrl = TextEditingController();
  String? _breed;
  String? _gender;
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  bool _showCalendar = false;

  bool get _canContinue {
    final nameOk = _nameCtrl.text.trim().isNotEmpty;
    final birthdayOk = _birthdayCtrl.text.trim().isNotEmpty;
    final breedOk = _breed != null && _breed!.isNotEmpty;
    final genderOk = _gender != null && _gender!.isNotEmpty;
    return nameOk && birthdayOk && breedOk && genderOk;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _birthdayCtrl.dispose();
    super.dispose();
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _birthdayCtrl.text = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      _showCalendar = false;
    });
  }

  void _changeMonth(bool next) {
    setState(() {
      if (next) {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      } else {
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      }
    });
  }

  void _gotoUploads() {
    if (!_canContinue) return;
    final name = _nameCtrl.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingPetUploadsScreen(petName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ===== Hero (centered) =====
                  Center(
                    child: SizedBox(
                      width: _circleSize,
                      height: _circleSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: _circleSize,
                            height: _circleSize,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1C59C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, _imageOffsetY),
                            child: Image.asset(
                              'assets/designs/pet_credentials.png',
                              width: _imageSize,
                              height: _imageSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== Title =====
                  const Text(
                    "Pet's Credentials",
                    style: TextStyle(
                      color: _titleBlack,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ===== Pet's Name =====
                  const Text(
                    "Pet's Name",
                    style: TextStyle(
                      color: _titleBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BottomBorderField(
                    controller: _nameCtrl,
                    hintText: "eg. Snowy",
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 18),

                  // ===== Pet's Gender =====
                  const Text(
                    "Pet's Gender",
                    style: TextStyle(
                      color: _titleBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _GenderOption(
                        label: 'Male',
                        isSelected: _gender == 'Male',
                        onTap: () => setState(() => _gender = 'Male'),
                      ),
                      const SizedBox(width: 40),
                      _GenderOption(
                        label: 'Female',
                        isSelected: _gender == 'Female',
                        onTap: () => setState(() => _gender = 'Female'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===== Pet's Birthday =====
                  const Text(
                    "Pet's Birthday",
                    style: TextStyle(
                      color: _titleBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BottomBorderField(
                    controller: _birthdayCtrl,
                    hintText: "DD/MM/YYYY",
                    readOnly: true,
                    onTap: _toggleCalendar,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 18),

                  // ===== Dog's Breed =====
                  SizedBox(
                    width: 200,
                    child: _RoundedDropdown<String>(
                      value: _breed,
                      hint: "Dog's Breed",
                      items: const [
                        'Labrador Retriever',
                        'German Shepherd',
                        'Golden Retriever',
                        'Beagle',
                        'Pug',
                        'Indian Pariah',
                        'Shih Tzu',
                        'Pomeranian',
                      ],
                      onChanged: (v) => setState(() => _breed = v),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ===== Continue CTA =====
                  _ContinueCTA(
                    enabled: _canContinue,
                    onPressed: _canContinue ? _gotoUploads : null,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // ===== Calendar Overlay - Full Screen =====
        if (_showCalendar)
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.3),
              child: GestureDetector(
                onTap: () => setState(() => _showCalendar = false),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _CustomCalendar(
                      currentDate: _currentDate,
                      selectedDate: _selectedDate,
                      onDateSelected: _selectDate,
                      onMonthChanged: _changeMonth,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ===== UI helpers =====

class _BottomBorderField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const _BottomBorderField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _dividerGrey, width: 1),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 16, color: _titleBlack),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _brandOrange : Colors.grey.shade400,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: _brandOrange,
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _titleBlack : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomCalendar extends StatelessWidget {
  final DateTime currentDate;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(bool) onMonthChanged;

  const _CustomCalendar({
    required this.currentDate,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final currentYear = DateTime.now().year;
    final years = List.generate(50, (index) => currentYear - index); // Last 50 years

    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month/Year Header with Dropdowns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onMonthChanged(false),
                icon: const Icon(Icons.chevron_left, color: Colors.grey),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Month Dropdown
                    GestureDetector(
                      onTap: () => _showMonthPicker(context, monthNames),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _brandOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          monthNames[currentDate.month - 1],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _brandOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Year Dropdown
                    GestureDetector(
                      onTap: () => _showYearPicker(context, years),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _brandOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${currentDate.year}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _brandOrange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onMonthChanged(true),
                icon: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                .map((day) => SizedBox(
              width: 32,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Grid
          ...List.generate((daysInMonth + firstWeekday + 6) ~/ 7, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 32, height: 32);
                  }

                  final date = DateTime(currentDate.year, currentDate.month, dayNumber);
                  final isSelected = selectedDate != null &&
                      selectedDate!.year == date.year &&
                      selectedDate!.month == date.month &&
                      selectedDate!.day == date.day;
                  final isToday = DateTime.now().year == date.year &&
                      DateTime.now().month == date.month &&
                      DateTime.now().day == date.day;

                  return GestureDetector(
                    onTap: () => onDateSelected(date),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _brandOrange
                            : isToday
                            ? _brandOrange.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          dayNumber.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                ? _brandOrange
                                : _titleBlack,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context, List<String> monthNames) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: monthNames.length,
              itemBuilder: (context, index) {
                final isSelected = index + 1 == currentDate.month;
                return ListTile(
                  title: Text(
                    monthNames[index],
                    style: TextStyle(
                      color: isSelected ? _brandOrange : _titleBlack,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: _brandOrange.withOpacity(0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onDateSelected(DateTime(currentDate.year, index + 1, 1));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showYearPicker(BuildContext context, List<int> years) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: double.minPositive,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = year == currentDate.year;
                return ListTile(
                  title: Text(
                    '$year',
                    style: TextStyle(
                      color: isSelected ? _brandOrange : _titleBlack,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: _brandOrange.withOpacity(0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onDateSelected(DateTime(year, currentDate.month, 1));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _RoundedDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<String> items;
  final ValueChanged<T?> onChanged;

  const _RoundedDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _dividerGrey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          alignment: Alignment.centerLeft,
          menuMaxHeight: 320,
          hint: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e as T,
            child: Text(
              e,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

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

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // subtle glow shadow under the pill
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
                    colors: [Color(0xE6F5832A), Color(0x33F5832A)],
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
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Continue',
                      style: TextStyle(
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