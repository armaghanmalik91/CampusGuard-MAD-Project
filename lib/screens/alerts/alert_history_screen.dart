import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alert History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _historyCard('Harassment Report', '12 Jun 2026 - 02:30 PM', 'Resolved', Colors.green),
          _historyCard('Suspicious Person', '10 Jun 2026 - 11:15 AM', 'Pending', Colors.orange),
          _historyCard('SOS Triggered', '05 Jun 2026 - 09:00 PM', 'Action Taken', AppColors.primary),
        ],
      ),
    );
  }

  Widget _historyCard(String title, String date, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkText),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.lightText),
                const SizedBox(width: 5),
                Text(date, style: const TextStyle(color: AppColors.lightText, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}