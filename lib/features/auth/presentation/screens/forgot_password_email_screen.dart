import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/animated_gradient_background.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool _isSuccess = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),

            SizedBox(width: 12),

            Text('Lỗi'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AuthProvider>();
    final email = emailController.text.trim();

    try {
      await provider.forgotPasswords(email);

      if (!mounted) return;

      setState(() {
        _isSuccess = true;
      });

      Future.delayed(const Duration(seconds: 8), () {
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.forgotPasswordOTP,
            arguments: email,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(
            gradientColors: [
              Color(0xFF0F172A), // slate-900
              Color(0xFF1E293B), // slate-800
              Color(0xFF334155), // slate-700
            ],
            blobColors: [
              Color.fromARGB(40, 249, 115, 22),
              Color.fromARGB(40, 251, 146, 60),
              Color.fromARGB(40, 251, 191, 36),
            ],
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isSuccess
                    ? _buildSuccessView(textTheme)
                    : _buildFormView(textTheme, provider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(TextTheme textTheme) {
    return Column(
      key: const ValueKey('success'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: Lottie.asset("assets/mock/email_successfully_sent_anim.json"),
        ),

        const SizedBox(height: 24),

        Text(
          "Đã gửi thành công!",
          style: textTheme.headlineSmall?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "Vui lòng kiểm tra hộp thư email của bạn để lấy mã OTP đặt lại mật khẩu.",
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontFamily: "Quicksand",
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 32),

        const CircularProgressIndicator(color: Colors.white),
      ],
    );
  }

  Widget _buildFormView(TextTheme textTheme, AuthProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Quên mật khẩu?",
            style: textTheme.headlineSmall?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Đừng lo! Nhập email của bạn và chúng tôi sẽ gửi mã OTP để đặt lại mật khẩu.",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              fontFamily: "Quicksand",
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 40),

          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            style: const TextStyle(
              fontFamily: "Quicksand",
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppTheme.summerPrimary,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppTheme.summerAccent,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.summerPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: provider.isLoading ? null : _handleSubmit,
              child: provider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Gửi mã OTP",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.login),
            child: const Text(
              "Đã có tài khoản? Đăng nhập",
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
