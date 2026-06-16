import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../auth/login_selection_screen.dart';

// Nayi screens import kar rahay hain
import '../sos/sos_screen.dart';
import '../location/location_screen.dart';
import '../reports/report_incident_screen.dart';
import '../alerts/alert_history_screen.dart';
import '../contacts/emergency_contacts_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Drawer ke andar logout function
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

  // Dashboard ke cards ko ab clickable (InkWell) bana diya hai
  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap, // Naya parameter click ke liye
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 28),
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
      ),
    );
  }

  // Drawer ke andar settings options ka widget
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
      ),
      // Left side se khulne wala Drawer
      drawer: Drawer(
        backgroundColor: AppColors.background,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const SizedBox(height: 10),
              // Header Card
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
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'student@campusguard.com',
                            style: TextStyle(
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
              
              // Settings Options
              settingTile(
                icon: Icons.account_circle,
                title: 'Profile',
                subtitle: 'View account details',
                onTap: () {
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile details clicked')),
                  );
                },
              ),
              settingTile(
                icon: Icons.notifications_active,
                title: 'Notifications',
                subtitle: 'Safety alerts and OTPs',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              settingTile(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'CampusGuard safety settings',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              settingTile(
                icon: Icons.info,
                title: 'About CampusGuard',
                subtitle: 'Smart Campus Safety Assistant',
                onTap: () {
                  Navigator.pop(context);
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
                      Text('Context-aware smart campus safety application.'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              settingTile(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Return to login screen',
                iconColor: AppColors.danger,
                onTap: () => logout(context),
              ),
            ],
          ),
        ),
      ),
      // Main Body
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Hi Student 👋',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Stay safe with smart campus alerts.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.lightText,
            ),
          ),
          const SizedBox(height: 25),

          dashboardCard(
            icon: Icons.sos,
            title: 'Emergency SOS',
            subtitle: 'Send emergency alert instantly',
            color: AppColors.danger,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SosScreen(userEmail: 'student@campusguard.com'),
                ),
              );
            },
          ),
          const SizedBox(height: 15),

          dashboardCard(
            icon: Icons.location_on,
            title: 'My Location Safety',
            subtitle: 'Check current campus safety status',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationScreen()),
              );
            },
          ),
          const SizedBox(height: 15),

          dashboardCard(
            icon: Icons.report,
            title: 'Report Incident',
            subtitle: 'Submit safety issue or incident',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportIncidentScreen(userEmail: 'student@campusguard.com'),
                ),
              );
            },
          ),
          const SizedBox(height: 15),

          dashboardCard(
            icon: Icons.history,
            title: 'Alert History',
            subtitle: 'View previous safety alerts',
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertHistoryScreen()),
              );
            },
          ),
          const SizedBox(height: 15),

          dashboardCard(
            icon: Icons.contacts,
            title: 'Emergency Contacts',
            subtitle: 'Manage your emergency contacts',
            color: Colors.deepPurple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
              );
            },
          ),
        ],
      ),
      // Naya Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}