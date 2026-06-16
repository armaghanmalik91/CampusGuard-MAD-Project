import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import 'otp_verification_screen.dart';

/// ----------------------
/// EMAIL MASK FUNCTION
/// ----------------------
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;

  final name = parts[0];
  final domain = parts[1];

  if (name.length <= 2) return '***@$domain';

  return '${name.substring(0, 2)}****@$domain';
}

class ForgotPasswordScreen extends StatefulWidget {
  final String role;
  final String? fixedEmail;

  const ForgotPasswordScreen({
    super.key,
    required this.role,
    this.fixedEmail,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  String errorMessage = '';
  String successMessage = '';
  bool isLoading = false;

  bool get isAdmin => widget.role.toLowerCase() == 'admin';

  @override
  void initState() {
    super.initState();

    if (widget.fixedEmail != null) {
      emailController.text = widget.fixedEmail!;
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

  Future<void> sendForgotOtp() async {
    String email = widget.fixedEmail ?? emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Email address missing';
        successMessage = '';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        errorMessage = 'Please enter a valid email address';
        successMessage = '';
      });
      return;
    }

    if (isAdmin &&
        email.toLowerCase() != 'armaghanmalik81@gmail.com') {
      setState(() {
        errorMessage = 'Invalid admin email';
        successMessage = '';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      successMessage = 'Please wait...';
    });

    try {
      final result = await ApiService.sendOtp(
        email: email,
        role: widget.role,
        purpose: 'forgot',
      );

      if (result['success'] == true) {
        setState(() {
          isLoading = false;
          successMessage =
              result['message'] ?? 'Reset code sent successfully';
          errorMessage = '';
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: email,
              role: widget.role,
              purpose: 'forgot',
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = result['message'] ?? 'Failed to send reset code';
          successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Server connection failed. Check XAMPP and API.';
        successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title =
        isAdmin ? 'Admin Forgot Password' : 'Forgot Password';

    String subtitle = isAdmin
        ? 'Reset code will be sent only to admin email'
        : 'Enter your registered email to receive reset code';

    final bool hasFixedEmail = widget.fixedEmail != null;

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
        imagePath: isAdmin
            ? 'assets/images/admin_bg.jpg'
            : 'assets/images/login_bg.jpg',
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
                      AuthTopIcon(
                        icon: isAdmin
                            ? Icons.admin_panel_settings
                            : Icons.password,
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
                              subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 26),

                            /// -------------------------
                            /// EMAIL FIELD (FIXED / INPUT)
                            /// -------------------------
                            hasFixedEmail
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputFill,
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.email,
                                            color: AppColors.primary),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            maskEmail(widget.fixedEmail!),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : TextField(
                                    controller: emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    decoration: inputDecoration(
                                      label: 'Email Address',
                                      icon: Icons.email,
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

                            CustomButton(
                              text: isLoading
                                  ? 'Sending...'
                                  : 'Send Reset Code',
                              icon: Icons.send,
                              onPressed:
                                  isLoading ? () {} : sendForgotOtp,
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