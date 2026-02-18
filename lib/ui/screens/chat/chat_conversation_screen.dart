import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey300 = Color(0xFFE9E9E9);

class ChatConversationScreen extends StatefulWidget {
  final String chatTitle; // still passed, but no heading UI
  const ChatConversationScreen({super.key, required this.chatTitle});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final List<_Msg> _messages = [
    _Msg(
        text: 'Send me an update about Krypto\'s evening walk.',
        isMe: false,
        time: '09:10'),
    _Msg(text: 'Sure — he was very active today!', isMe: true, time: '09:12'),
    _Msg(
        text: 'Here is a photo from today.',
        isMe: false,
        time: '09:14',
        isImage: true),
  ];

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: t, isMe: true, time: 'Now'));
      _ctrl.clear();
    });
    // optional fake reply
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(_Msg(
            text: 'Thanks! I got it.', isMe: false, time: 'Now'));
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _grey900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.chatTitle,
          style: const TextStyle(
            color: _grey900,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final m = _messages[i];
                  if (m.isImage) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: m.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: _ImageBubble(isMe: m.isMe),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Align(
                      alignment: m.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _TextBubble(msg: m),
                    ),
                  );
                },
              ),
            ),

            // Input row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _grey300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              decoration: const InputDecoration(
                                hintText: 'Message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {}, // image picker action placeholder
                            icon: const Icon(Icons.photo_camera_outlined,
                                color: _grey700),
                          ),
                          IconButton(
                            onPressed: () {}, // attach
                            icon: const Icon(Icons.attachment_outlined,
                                color: _grey700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _brandOrange,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool isMe;
  final String time;
  final bool isImage;
  _Msg(
      {required this.text,
      required this.isMe,
      required this.time,
      this.isImage = false});
}

class _TextBubble extends StatelessWidget {
  final _Msg msg;
  const _TextBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final bg = msg.isMe ? const Color(0xFFFFF3EB) : Colors.white;
    final color = msg.isMe ? Colors.black : Colors.black87;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        crossAxisAlignment:
            msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFECECEC)),
            ),
            child: Text(msg.text, style: TextStyle(color: color)),
          ),
          const SizedBox(height: 6),
          Text(msg.time,
              style: const TextStyle(fontSize: 11, color: _grey700)),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final bool isMe;
  const _ImageBubble({this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/pet_avatar.png'), // placeholder
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 4))
        ],
      ),
    );
  }
}
