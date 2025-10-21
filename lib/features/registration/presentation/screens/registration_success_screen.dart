import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  "assets/mock/register_successfully_anim.json",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      "Đăng ký thành công!",
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Vui lòng quay về trang lịch sử đăng ký để chờ được duyệt đơn đăng ký trong vài phút.",
                      style: textTheme.bodyLarge?.copyWith(
                        fontFamily: "Quicksand",
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.summerAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.history_rounded),
                      label: Text(
                        "Xem lịch sử đăng ký",
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.registrationList,
                          (route) => route.isFirst,
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => route.isFirst,
                        );
                      },
                      child: Text(
                        "Về Trang Chủ",
                        style: textTheme.bodyLarge?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
