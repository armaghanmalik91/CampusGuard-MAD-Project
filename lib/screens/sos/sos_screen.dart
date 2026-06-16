import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';

class SosScreen extends StatefulWidget {
  final String userEmail; // Ye email lazmi chahiye taake pata chale kisne SOS bheja

  const SosScreen({super.key, required this.userEmail});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool isLoading = false;

  // Backend par data bhejne ka function
  Future<void> triggerAlert(String alertType) async {
    setState(() {
      isLoading = true;
    });

    final result = await ApiService.sendSosAlert(
      email: widget.userEmail,
      alertType: alertType,
    );

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Alert triggered!'),
          backgroundColor: result['success'] == true ? Colors.green : AppColors.danger,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: AppColors.danger,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Press and hold the button\nin case of emergency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Giant SOS Button (Sends 'Main SOS' to Database)
                GestureDetector(
                  onLongPress: () => triggerAlert('Main SOS Emergency'),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.danger,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                
                // Quick Call Buttons (Sends specific alerts to Database)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _quickActionButton(Icons.local_police, 'Police', Colors.blue, 'Police Requested'),
                    _quickActionButton(Icons.medical_services, 'Ambulance', Colors.red, 'Ambulance Requested'),
                    _quickActionButton(Icons.security, 'Campus Guard', AppColors.primary, 'Guard Requested'),
                  ],
                )
              ],
            ),
          ),
          
          // Loading Indicator screen par tab aayega jab data database me save ho raha hoga
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String label, Color color, String alertType) {
    return InkWell(
      onTap: () => triggerAlert(alertType),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}