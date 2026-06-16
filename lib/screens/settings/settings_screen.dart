import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../auth/login_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String role;
  final String email;

  const SettingsScreen({
    super.key,
    required this.role,
    required this.email,
  });

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.lightText,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = role.toLowerCase() == 'admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    isAdmin ? Icons.admin_panel_settings : Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAdmin ? 'Admin Account' : 'Student Account',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          settingTile(
            icon: Icons.account_circle,
            title: 'Profile',
            subtitle: 'View account role and email',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged in as $role'),
                ),
              );
            },
          ),

          settingTile(
            icon: Icons.notifications_active,
            title: 'Notifications',
            subtitle: 'Safety alerts and OTP notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications are enabled'),
                ),
              );
            },
          ),

          settingTile(
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'CampusGuard account safety settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings will be added later'),
                ),
              );
            },
          ),

          settingTile(
            icon: Icons.info,
            title: 'About CampusGuard',
            subtitle: 'Smart Campus Safety Assistant',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'CampusGuard',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.security,
                  color: AppColors.primary,
                  size: 40,
                ),
                children: const [
                  Text(
                    'CampusGuard is a context-aware smart campus safety application for students and administrators.',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          settingTile(
            icon: Icons.logout,
            title: 'Logout / Sign out',
            subtitle: 'Return to login screen',
            iconColor: AppColors.danger,
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}