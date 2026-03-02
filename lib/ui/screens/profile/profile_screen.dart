import 'package:flutter/material.dart';
import 'subscription_period_screen.dart';
import 'onboarding_setup_screen.dart';
import 'home_wifi_setup_screen.dart';
import 'change_home_location_screen.dart';
import 'manage_accounts_screen.dart';
import 'devices_screen.dart' hide InkWell;
import '../share/share_link_screen.dart';
import '../users/users_screen.dart';

// Design tokens
const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);
const _grey300 = Color(0xFFE9E9E9);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingSetupScreen(),
                ),
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _grey300),
              ),
              child: const Icon(Icons.wifi, size: 18, color: _grey700),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DevicesScreen(),
                ),
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _grey300),
              ),
              child: const Icon(Icons.devices, size: 18, color: _grey700),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _grey300),
              ),
              child: const Icon(Icons.edit_outlined, size: 18, color: _grey700),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShareLinkScreen(petName: 'Krypto'),
                ),
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _grey300),
              ),
              child: const Icon(Icons.share, size: 18, color: _grey700),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: _grey700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mehul Paul',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _grey900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Photographer, Krishna Pradesh 52436',
                      style: TextStyle(
                        fontSize: 12,
                        color: _grey600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Your Pets Section
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Pets',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _grey900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        _PetAvatar('Krypto', 'assets/images/pet1.png'),
                        SizedBox(width: 16),
                        _PetAvatar('Bobby', 'assets/images/pet2.png'),
                        SizedBox(width: 16),
                        _PetAvatar('Leo', 'assets/images/pet3.png'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Menu Options
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.access_time,
                      iconColor: Colors.green,
                      title: 'Subscription Period',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionPeriodScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.wifi,
                      iconColor: Colors.pink,
                      title: 'Change Home WiFi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeWifiSetupScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.location_on,
                      iconColor: Colors.purple,
                      title: 'Change Home Location',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeHomeLocationScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.manage_accounts,
                      iconColor: Colors.pink,
                      title: 'Manage Accounts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageAccountsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.people,
                      iconColor: Colors.blue,
                      title: 'Family & Caretakers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsersScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.share,
                      iconColor: Colors.green,
                      title: 'Share Pet Location',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShareLinkScreen(petName: 'Krypto'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final String name;
  final String imagePath;

  const _PetAvatar(this.name, this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _brandOrange,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.pets,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _grey900,
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _grey900,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _grey600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
