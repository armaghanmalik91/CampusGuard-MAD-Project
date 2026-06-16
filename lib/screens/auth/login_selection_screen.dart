import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/custom_button.dart';
import 'admin_login_screen.dart';
import 'student_login_screen.dart';

class LoginSelectionScreen extends StatefulWidget {
  const LoginSelectionScreen({super.key});

  @override
  State<LoginSelectionScreen> createState() => _LoginSelectionScreenState();
}

class _LoginSelectionScreenState extends State<LoginSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 2.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget logoBox() {
    return ScaleTransition(
      scale: _logoScale,
      child: const AuthTopIcon(
        icon: Icons.school,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget animatedContent({required Widget child}) {
    return FadeTransition(
      opacity: _contentFade,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthBackground(
        imagePath: 'assets/images/login_bg.jpg',
        child: SafeArea(
          // UI Overflow fix with CustomScrollView to keep Spacers working
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      logoBox(),

                      const SizedBox(height: 24),

                      animatedContent(
                        child: AuthGlassCard(
                          child: Column(
                            children: [
                              const Text(
                                'Welcome to CampusGuard',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.darkText,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Choose your role to continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.lightText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 28),

                              CustomButton(
                                text: 'Continue as Student/User',
                                icon: Icons.person,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const StudentLoginScreen(),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 14),

                              CustomButton(
                                text: 'Continue as Admin',
                                icon: Icons.admin_panel_settings,
                                backgroundColor: AppColors.secondary,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminLoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      animatedContent(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Context-Aware Intelligent Mobile Application',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}