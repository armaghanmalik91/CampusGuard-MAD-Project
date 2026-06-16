import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import 'set_password_screen.dart';
import 'student_login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String role;
  final String purpose;

  final String? firstName;
  final String? lastName;
  final String? password;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.role,
    required this.purpose,
    this.firstName,
    this.lastName,
    this.password,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  bool get isAdmin => widget.role.toLowerCase() == 'admin';

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
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
      counterText: '',
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

  Future<void> completeRegisterAfterOtp() async {
    final result = await ApiService.setPassword(
      email: widget.email,
      password: widget.password ?? '',
      role: widget.role,
      purpose: widget.purpose,
      firstName: widget.firstName ?? '',
      lastName: widget.lastName ?? '',
    );

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration completed'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentLoginScreen(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        errorMessage = result['message'] ?? 'Registration failed';
      });
    }
  }

  Future<void> verifyOtp() async {
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      setState(() {
        errorMessage = 'Please enter OTP code';
      });
      return;
    }

    if (otp.length != 6) {
      setState(() {
        errorMessage = 'OTP must be 6 digits';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.verifyOtp(
        email: widget.email,
        otp: otp,
        role: widget.role,
        purpose: widget.purpose,
      );

      if (result['success'] == true) {
        if (widget.purpose == 'register') {
          await completeRegisterAfterOtp();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SetPasswordScreen(
                email: widget.email,
                role: widget.role,
                purpose: widget.purpose,
              ),
            ),
          );
        }
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Invalid OTP';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Server connection failed. Check XAMPP and API.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.purpose == 'forgot'
        ? 'Verify Reset Code'
        : 'Verify Email Code';

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
                        icon: Icons.verified_user,
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
                              'Code sent to ${widget.email}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 26),

                            TextField(
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                letterSpacing: 5,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkText,
                              ),
                              decoration: inputDecoration(
                                label: '6 Digit OTP',
                                icon: Icons.password,
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
                                  ? widget.purpose == 'register'
                                      ? 'Creating Account...'
                                      : 'Verifying...'
                                  : 'Verify OTP',
                              icon: Icons.check_circle,
                              onPressed: isLoading ? () {} : verifyOtp,
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
