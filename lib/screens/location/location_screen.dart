import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Location Safety'),
      ),
      body: Column(
        children: [
          // Map Placeholder (Actual Google Map will go here later)
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text('Google Map integration goes here', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Share Location Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_location),
              label: const Text('Share Live Location with Security'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nearby Safe Zones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _safeZoneTile('Main Library', '200m away', true),
                _safeZoneTile('CS Department', '450m away', true),
                _safeZoneTile('Cafeteria', '600m away', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _safeZoneTile(String title, String distance, bool isVerySafe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.verified_user,
          color: isVerySafe ? Colors.green : Colors.orange,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(distance),
        trailing: const Icon(Icons.directions, color: AppColors.primary),
      ),
    );
  }
}