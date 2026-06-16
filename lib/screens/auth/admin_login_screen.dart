import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import '../admin/admin_dashboard_screen.dart';
import 'forgot_password_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Is khali line ko:
  // final String defaultAdminEmail = ''; 

  // Is se replace kar dein:
  final String defaultAdminEmail = 'armaghanmalik81@gmail.com';

  String errorMessage = '';

  Future<void> loginAdmin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password';
      });
      return;
    }

    if (email.toLowerCase() != defaultAdminEmail.toLowerCase()) {
      setState(() {
        errorMessage = 'Invalid admin email';
      });
      return;
    }

    setState(() {
      errorMessage = '';
    });

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
        role: 'admin',
      );

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboardScreen(),
          ),
        );
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Invalid admin login';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Server connection failed. Check XAMPP and API.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.text = defaultAdminEmail;
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: AuthBackground(
        imagePath: 'assets/images/admin_bg.jpg',
        darkOverlayOpacity: 0.58,
        greenOverlayOpacity: 0.35,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthTopIcon(
                        icon: Icons.admin_panel_settings,
                        backgroundColor: AppColors.primary,
                      ),

                      const SizedBox(height: 22),

                      AuthGlassCard(
                        child: Column(
                          children: [
                            const Text(
                              'Admin Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Only authorized admin can access this panel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 26),

                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: inputDecoration(
                                label: 'Admin Email',
                                icon: Icons.email,
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: inputDecoration(
                                label: 'Password',
                                icon: Icons.lock,
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(top: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen(
                                        role: 'admin',
                                        fixedEmail: defaultAdminEmail,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),

                            if (errorMessage.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],

                            const SizedBox(height: 18),

                            CustomButton(
                              text: 'Login as Admin',
                              icon: Icons.login,
                              onPressed: loginAdmin,
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '',
                                style: TextStyle(
                                  color: AppColors.lightText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
