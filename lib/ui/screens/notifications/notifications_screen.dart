import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final String petName;

  const NotificationsScreen({Key? key, required this.petName}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // false = unread, true = read
  final Map<int, bool> _readStatus = {};

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "icon": Icons.fastfood,
        "color": Colors.pinkAccent,
        "title": "It’s ${widget.petName}’s Lunch Time",
        "subtitle": "Ask Caretaker for Live Image",
      },
      {
        "icon": Icons.warning_rounded,
        "color": Colors.redAccent,
        "title": "${widget.petName} is outside Walking Boundary",
        "subtitle": "Call Caretaker for support",
      },
      {
        "icon": Icons.directions_walk_rounded,
        "color": Colors.blueAccent,
        "title": "${widget.petName} is going out for walk",
        "subtitle": "",
      },
      {
        "icon": Icons.person,
        "color": Colors.green,
        "title": "Your Caretaker has Arrived!",
        "subtitle": "",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // bottom space for nav bar
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final n = notifications[index];
            final isRead = _readStatus[index] ?? false;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isRead ? Colors.white : const Color(0xFFD7CCC8), // brown for unread
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: (n["color"] as Color).withOpacity(0.18),
                  child: Icon(n["icon"] as IconData, color: n["color"] as Color),
                ),
                title: Text(
                  n["title"] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: (n["subtitle"] != null && (n["subtitle"] as String).isNotEmpty)
                    ? Text(n["subtitle"] as String)
                    : null,
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    setState(() {
                      if (value == "read") {
                        _readStatus[index] = true;
                      } else if (value == "unread") {
                        _readStatus[index] = false;
                      }
                    });
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "read", child: Text("Mark as Read")),
                    PopupMenuItem(value: "unread", child: Text("Mark as Unread")),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
