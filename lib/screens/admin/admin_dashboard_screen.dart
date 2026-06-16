import '../settings/settings_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Widget adminCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.secondary.withOpacity(0.12),
            child: Icon(icon, color: AppColors.secondary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Admin Dashboard'),
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(
              role: 'admin',
              email: 'armaghanmalik81@gmail.com',
            ),
          ),
        );
      },
    ),
  ],
),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Admin Panel',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage campus safety system.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.lightText,
            ),
          ),
          const SizedBox(height: 25),

          adminCard(
            icon: Icons.people,
            title: 'Manage Users',
            subtitle: 'View and manage registered students',
          ),

          const SizedBox(height: 15),

          adminCard(
            icon: Icons.warning,
            title: 'Manage Unsafe Zones',
            subtitle: 'Add or update risky campus areas',
          ),

          const SizedBox(height: 15),

          adminCard(
            icon: Icons.report_problem,
            title: 'Incident Reports',
            subtitle: 'View reports submitted by students',
          ),

          const SizedBox(height: 15),

          adminCard(
            icon: Icons.notifications_active,
            title: 'Send Safety Alert',
            subtitle: 'Notify students about campus risk',
          ),
        ],
      ),
    );
  }
}