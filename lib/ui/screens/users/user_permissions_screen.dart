import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey300 = Color(0xFFE9E9E9);

class UserPermissionsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(List<String>) onPermissionsChanged;

  const UserPermissionsScreen({
    super.key,
    required this.user,
    required this.onPermissionsChanged,
  });

  @override
  State<UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  late List<String> _selectedPermissions;

  final List<Map<String, dynamic>> _availablePermissions = [
    {
      'id': 'View',
      'title': 'View Pet Location',
      'description': 'Can see pet\'s current location and tracking history',
      'icon': Icons.visibility,
    },
    {
      'id': 'Share',
      'title': 'Share Location',
      'description': 'Can create and share location links with others',
      'icon': Icons.share,
    },
    {
      'id': 'Edit',
      'title': 'Edit Pet Profile',
      'description': 'Can modify pet information and settings',
      'icon': Icons.edit,
    },
    {
      'id': 'Manage',
      'title': 'Manage Routines',
      'description': 'Can create and modify pet routines and schedules',
      'icon': Icons.schedule,
    },
    {
      'id': 'Emergency',
      'title': 'Emergency Alerts',
      'description': 'Receives emergency notifications and can trigger alerts',
      'icon': Icons.warning,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedPermissions = List<String>.from(widget.user['permissions'] ?? []);
  }

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
        title: Text(
          '${widget.user['name']} - Permissions',
          style: const TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User Info Header
            Container(
              margin: const EdgeInsets.all(16),
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
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: _brandOrange.withOpacity(0.1),
                    child: Text(
                      widget.user['name'][0],
                      style: const TextStyle(
                        color: _brandOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _grey900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user['email'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: _grey700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _brandOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.user['role'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: _brandOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Permissions List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                itemCount: _availablePermissions.length,
                itemBuilder: (context, index) {
                  final permission = _availablePermissions[index];
                  final isSelected = _selectedPermissions.contains(permission['id']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _brandOrange : _grey300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? _brandOrange.withOpacity(0.1)
                              : _grey300.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          permission['icon'],
                          color: isSelected ? _brandOrange : _grey700,
                        ),
                      ),
                      title: Text(
                        permission['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? _brandOrange : _grey900,
                        ),
                      ),
                      subtitle: Text(
                        permission['description'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: _grey700,
                        ),
                      ),
                      trailing: Switch(
                        value: isSelected,
                        activeThumbColor: _brandOrange,
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              _selectedPermissions.add(permission['id']);
                            } else {
                              _selectedPermissions.remove(permission['id']);
                            }
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedPermissions.remove(permission['id']);
                          } else {
                            _selectedPermissions.add(permission['id']);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Save Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onPermissionsChanged(_selectedPermissions);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Permissions updated successfully')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Save Permissions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
