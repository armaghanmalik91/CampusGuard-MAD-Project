import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import 'admin_login_screen.dart';
import 'student_login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String role;
  final String purpose;

  const SetPasswordScreen({
    super.key,
    required this.email,
    required this.role,
    required this.purpose,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  bool get isAdmin => widget.role.toLowerCase() == 'admin';

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

  Future<void> savePassword() async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'Please fill both password fields';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.setPassword(
        email: widget.email,
        password: password,
        role: widget.role,
        purpose: widget.purpose,
      );

      if (result['success'] == true) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Password saved successfully'),
          ),
        );

        if (widget.role == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminLoginScreen(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentLoginScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = result['message'] ?? 'Failed to save password';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Server connection failed. Check XAMPP and API.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.purpose == 'forgot'
        ? 'Reset Password'
        : 'Set Your Password';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: AuthBackground(
        imagePath:
            isAdmin ? 'assets/images/admin_bg.jpg' : 'assets/images/register_bg.jpg',
        darkOverlayOpacity: isAdmin ? 0.58 : 0.50,
        greenOverlayOpacity: isAdmin ? 0.35 : 0.42,
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
                        icon: Icons.lock_reset,
                        backgroundColor: AppColors.primary,
                      ),

                      const SizedBox(height: 22),

                      AuthGlassCard(
                        child: Column(
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              widget.email,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 26),

                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: inputDecoration(
                                label: 'New Password',
                                icon: Icons.lock,
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: inputDecoration(
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
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

                            const SizedBox(height: 20),

                            CustomButton(
                              text: isLoading
                                  ? 'Saving...'
                                  : widget.purpose == 'forgot'
                                      ? 'Update Password'
                                      : 'Save Password',
                              icon: Icons.save,
                              onPressed: isLoading ? () {} : savePassword,
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
