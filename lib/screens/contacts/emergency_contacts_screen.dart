import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Campus Authorities',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 10),
          _contactTile('Campus Security', '051-1234567', Icons.security, AppColors.primary),
          _contactTile('Medical Center', '051-7654321', Icons.local_hospital, Colors.red),
          
          const SizedBox(height: 20),
          const Text(
            'Personal Contacts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 10),
          _contactTile('Father', '+92 300 1234567', Icons.person, Colors.blueGrey),
          _contactTile('Brother', '+92 333 7654321', Icons.person, Colors.blueGrey),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact logic
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _contactTile(String name, String phone, IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.15),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(phone),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () {
            // Call logic will go here
          },
        ),
      ),
    );
  }
}