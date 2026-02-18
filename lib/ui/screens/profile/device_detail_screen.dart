import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);
const _grey300 = Color(0xFFE9E9E9);

class DeviceDetailScreen extends StatelessWidget {
  final String deviceName;
  final Color deviceColor;

  const DeviceDetailScreen({
    super.key,
    required this.deviceName,
    required this.deviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
        ),
        title: Text(
          deviceName,
          style: const TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: _grey700),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Icon and Status
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: deviceColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.watch,
                              color: deviceColor,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            deviceName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _grey900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Connected',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Device Settings
                    const Text(
                      'Device Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _grey900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _SettingsTile(
                      icon: Icons.power_settings_new,
                      title: 'Power',
                      trailing: Switch(
                        value: true,
                        activeColor: _brandOrange,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _SettingsTile(
                      icon: Icons.location_on,
                      title: 'GPS Tracking',
                      trailing: Switch(
                        value: true,
                        activeColor: _brandOrange,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _SettingsTile(
                      icon: Icons.vibration,
                      title: 'Vibration',
                      trailing: Switch(
                        value: false,
                        activeColor: _brandOrange,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _SettingsTile(
                      icon: Icons.volume_up,
                      title: 'Sound Alerts',
                      trailing: Switch(
                        value: true,
                        activeColor: _brandOrange,
                        onChanged: (value) {},
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Device Info
                    const Text(
                      'Device Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _grey900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _InfoTile(
                      label: 'Device ID',
                      value: 'MP001234567',
                    ),
                    const SizedBox(height: 12),
                    
                    _InfoTile(
                      label: 'Firmware Version',
                      value: 'v2.1.5',
                    ),
                    const SizedBox(height: 12),
                    
                    _InfoTile(
                      label: 'Battery Level',
                      value: '87%',
                    ),
                    const SizedBox(height: 12),
                    
                    _InfoTile(
                      label: 'Last Sync',
                      value: '2 minutes ago',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(icon, color: _grey700, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _grey900,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _grey700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _grey900,
            ),
          ),
        ],
      ),
    );
  }
}
