import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

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
        title: const Text(
          'Devices',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            _DeviceTile(
              name: 'Krypto\'s Collar',
              color: Colors.pink,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _DeviceTile(
              name: 'Leo\'s Collar',
              color: Colors.blue,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _DeviceTile(
              name: 'Bobby\'s Collar',
              color: Colors.green,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;

  const _DeviceTile({
    required this.name,
    required this.color,
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
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.watch,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
