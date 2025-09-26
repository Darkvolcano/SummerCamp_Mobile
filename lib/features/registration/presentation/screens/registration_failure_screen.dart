import 'package:flutter/material.dart';

class RegistrationFailureScreen extends StatefulWidget {
  final String? errorMessage;

  const RegistrationFailureScreen({super.key, this.errorMessage});

  @override
  State<RegistrationFailureScreen> createState() =>
      _RegistrationFailureScreenState();
}

class _RegistrationFailureScreenState extends State<RegistrationFailureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  child: const Icon(Icons.error, size: 100, color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Đăng ký thất bại",
                style: textTheme.headlineSmall?.copyWith(
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                widget.errorMessage ??
                    "Đã xảy ra lỗi trong quá trình đăng ký. Vui lòng thử lại sau.",
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Nunito",
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  "Thử lại",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
