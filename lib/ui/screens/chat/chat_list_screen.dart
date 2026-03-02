import 'package:flutter/material.dart';
import 'chat_conversation_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey300 = Color(0xFFE9E9E9);

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      // 🔕 NO APPBAR
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // safe + nav spacing
          children: [
            _ChatListItem(
              avatarAsset: null,
              name: 'Mahesh Chaurasiya',
              lastMessage: 'Send me an update about Krypto\'s evening walk.',
              lastAt: '09:10',
              unread: 0,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatConversationScreen(
                    chatTitle: 'Mahesh Chaurasiya',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ChatListItem(
              avatarAsset: null,
              name: 'Sunita Gaikwad',
              lastMessage: 'Thanks for the update!',
              lastAt: '08:30',
              unread: 2,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatConversationScreen(
                    chatTitle: 'Sunita Gaikwad',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ChatListItem(
              avatarAsset: null,
              name: 'Saurav Singh',
              lastMessage: 'I will pick him up at 6pm.',
              lastAt: 'Yesterday',
              unread: 0,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatConversationScreen(
                    chatTitle: 'Saurav Singh',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final String? avatarAsset;
  final String name;
  final String lastMessage;
  final String lastAt;
  final int unread;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.avatarAsset,
    required this.name,
    required this.lastMessage,
    required this.lastAt,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFF0F0F0),
                backgroundImage: avatarAsset == null ? null : AssetImage(avatarAsset!),
                child: avatarAsset == null
                    ? const Icon(Icons.person, color: _grey700)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _grey900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lastMessage,
                      style: const TextStyle(color: _grey700, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(lastAt,
                      style: const TextStyle(color: _grey700, fontSize: 12)),
                  const SizedBox(height: 8),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _brandOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
