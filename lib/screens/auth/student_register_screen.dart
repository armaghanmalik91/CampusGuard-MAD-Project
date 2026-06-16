import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_button.dart';
import '../dashboard/dashboard_screen.dart';
import 'otp_verification_screen.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String errorMessage = '';
  String successMessage = '';
  String passwordMatchMessage = '';
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void checkPasswordMatch() {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (confirmPassword.isEmpty) {
      setState(() {
        passwordMatchMessage = '';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        passwordMatchMessage = 'Your passwords do not match';
      });
    } else {
      setState(() {
        passwordMatchMessage = '';
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

    String firstName = parts.first;
    String lastName = parts.sublist(1).join(' ');

    return [firstName, lastName];
  }

  Future<void> signUpWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
      errorMessage = '';
      successMessage = '';
      passwordMatchMessage = '';
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Google sign-up successful'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        setState(() {
          isGoogleLoading = false;
          errorMessage = result['message'] ?? 'Google sign-up failed';
        });
      }
    } catch (e) {
      setState(() {
        isGoogleLoading = false;
        errorMessage =
            'Google sign-up failed. Check Firebase setup, SHA-1, and internet.';
      });
    }
  }

  Future<void> sendOtp() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'All fields are required';
        successMessage = '';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        errorMessage = 'Please enter a valid email';
        successMessage = '';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters';
        successMessage = '';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = '';
        passwordMatchMessage = 'Your passwords do not match';
        successMessage = '';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      successMessage = 'Please wait...';
      passwordMatchMessage = '';
    });

    try {
      final result = await ApiService.sendOtp(
        email: email,
        role: 'student',
        purpose: 'register',
      );

      if (result['success'] == true) {
        setState(() {
          isLoading = false;
          errorMessage = '';
          successMessage =
              result['message'] ?? 'OTP sent successfully to your email';
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: email,
              role: 'student',
              purpose: 'register',
              firstName: firstName,
              lastName: lastName,
              password: password,
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = result['message'] ?? 'Something went wrong';
          successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Server connection failed. Check XAMPP and API.';
        successMessage = '';
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
        title: const Text('Student Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: AuthBackground(
        imagePath: 'assets/images/register_bg.jpg',
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
                        icon: Icons.person_add_alt_1,
                        backgroundColor: AppColors.primary,
                      ),

                      const SizedBox(height: 18),

                      AuthGlassCard(
                        child: Column(
                          children: [
                            const Text(
                              'Create Student Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Fill your details and verify email with OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 22),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: firstNameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: inputDecoration(
                                      label: 'First Name',
                                      icon: Icons.person,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: lastNameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: inputDecoration(
                                      label: 'Last Name',
                                      icon: Icons.person_outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: inputDecoration(
                                label: 'Email Address',
                                icon: Icons.email,
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              onChanged: (_) => checkPasswordMatch(),
                              decoration: inputDecoration(
                                label: 'Password',
                                icon: Icons.lock,
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              onChanged: (_) => checkPasswordMatch(),
                              decoration: inputDecoration(
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                              ),
                            ),

                            if (passwordMatchMessage.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  passwordMatchMessage,
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],

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

                            if (successMessage.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                successMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            SocialButton(
                              text: isGoogleLoading
                                  ? 'Connecting Google...'
                                  : 'Sign up with Google',
                              icon: Icons.g_mobiledata,
                              onPressed:
                                  isGoogleLoading ? () {} : signUpWithGoogle,
                            ),

                            const SizedBox(height: 13),

                            CustomButton(
                              text: isLoading
                                  ? 'Sending OTP...'
                                  : 'Sign up with Email',
                              icon: Icons.email,
                              onPressed: isLoading ? () {} : sendOtp,
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
