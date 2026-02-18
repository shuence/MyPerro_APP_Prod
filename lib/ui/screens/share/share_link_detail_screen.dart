import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);
const _grey300 = Color(0xFFE9E9E9);

class ShareLinkDetailScreen extends StatefulWidget {
  final String petName;

  const ShareLinkDetailScreen({super.key, required this.petName});

  @override
  State<ShareLinkDetailScreen> createState() => _ShareLinkDetailScreenState();
}

class _ShareLinkDetailScreenState extends State<ShareLinkDetailScreen> {
  final List<Map<String, dynamic>> _activeLinks = [
    {
      'id': '1',
      'link': 'https://myperro.com/track/1234',
      'expiresIn': '25 minutes',
      'permission': 'View Only',
      'createdAt': '10:30 AM',
    },
    {
      'id': '2',
      'link': 'https://myperro.com/track/5678',
      'expiresIn': '4 hours',
      'permission': 'Interact',
      'createdAt': '9:15 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Active Links',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '${widget.petName}\'s Active Sharing Links',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _grey900,
                ),
              ),
            ),
            
            Expanded(
              child: _activeLinks.isEmpty
                  ? const Center(
                      child: Text(
                        'No active links',
                        style: TextStyle(color: _grey600),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      itemCount: _activeLinks.length,
                      itemBuilder: (context, index) {
                        final link = _activeLinks[index];
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Active',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          link['createdAt'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: _grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            link['link'],
                                            style: const TextStyle(color: _grey900),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy, color: _brandOrange),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: link['link']));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Link copied')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: _grey300),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _activeLinks.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          'Revoke',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: _grey600,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: _grey600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: _grey900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _grey700,
            ),
          ),
        ],
      ),
    );
  }
}
