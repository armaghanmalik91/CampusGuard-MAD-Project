import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_button.dart';
import '../dashboard/dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'student_register_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';
  bool isGoogleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginStudent() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password';
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
        role: 'student',
      );

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Server connection failed. Check XAMPP and API.';
      });
    }
  }

  List<String> splitName(String? displayName) {
    String fullName = (displayName ?? '').trim();

    if (fullName.isEmpty) {
      return ['Google', 'User'];
    }

    List<String> parts = fullName.split(' ');

    if (parts.length == 1) {
      return [parts.first, 'User'];
    }

    return [parts.first, parts.sublist(1).join(' ')];
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
      errorMessage = '';
    });

    try {
      final User? user = await GoogleAuthService.signInWithGoogle();

      if (user == null) {
        setState(() {
          isGoogleLoading = false;
        });
        return;
      }

      final names = splitName(user.displayName);

      final result = await ApiService.googleSignup(
        email: user.email ?? '',
        firstName: names[0],
        lastName: names[1],
        googleUid: user.uid,
        photoUrl: user.photoURL ?? '',
      );

      if (result['success'] == true) {
        setState(() {
          isGoogleLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        setState(() {
          isGoogleLoading = false;
          errorMessage = result['message'] ?? 'Google login failed';
        });
      }
    } catch (e) {
      setState(() {
        isGoogleLoading = false;
        errorMessage =
            'Google login failed. Check Firebase setup, SHA-1, and internet.';
      });
    }
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
        title: const Text('Student Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: AuthBackground(
        imagePath: 'assets/images/login_bg.jpg',
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
                        icon: Icons.person,
                        backgroundColor: AppColors.primary,
                      ),
                      const SizedBox(height: 22),
                      AuthGlassCard(
                        child: Column(
                          children: [
                            const Text(
                              'Student Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Login with your registered email',
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
                                label: 'Email Address',
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
                                          const ForgotPasswordScreen(
                                        role: 'student',
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
                              text: 'Login',
                              icon: Icons.login,
                              onPressed: loginStudent,
                            ),
                            const SizedBox(height: 13),
                            SocialButton(
                              text: isGoogleLoading
                                  ? 'Connecting Google...'
                                  : 'Continue with Google',
                              icon: Icons.g_mobiledata,
                              onPressed:
                                  isGoogleLoading ? () {} : signInWithGoogle,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'New student? ',
                                  style: TextStyle(
                                    color: AppColors.lightText,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentRegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Register here',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
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
