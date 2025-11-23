import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/animated_gradient_background.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
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
            Text('Lỗi', style: TextStyle(fontFamily: "Quicksand")),
          ],
        ),
        content: Text(message, style: const TextStyle(fontFamily: "Quicksand")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Đóng',
              style: TextStyle(fontFamily: "Quicksand"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AuthProvider>();

    await provider.login(emailController.text.trim(), passwordController.text);

    if (!mounted) return;

    if (provider.error != null) {
      _showErrorDialog(provider.error!);
      return;
    }

    final userRole = provider.userRole ?? '';

    if (userRole == 'Staff') {
      Navigator.pushReplacementNamed(context, AppRoutes.staffHome);
    } else if (userRole == 'User' || userRole == 'Parent') {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (userRole == 'Driver') {
      Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
    } else {
      _showErrorDialog('Role không hợp lệ: $userRole');
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
              Color(0xFF854D0E),
              Color(0xFFB45309),
              Color(0xFFF59E0B),
            ],
            blobColors: [
              Color.fromARGB(45, 253, 186, 116),
              Color.fromARGB(45, 251, 146, 60),
              Color.fromARGB(45, 251, 191, 36),
            ],
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chào mừng quay trở lại trại hè!",
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            blurRadius: 6,
                            offset: Offset(0, 2),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      width: 500,
                      height: 160,
                      child: Lottie.asset(
                        "assets/mock/tent_anim.json",
                        repeat: true,
                        animate: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildInputField(
                      emailController,
                      "Email",
                      Icons.email,
                      validator: _validateEmail,
                    ),

                    _buildInputField(
                      passwordController,
                      "Mật khẩu",
                      Icons.lock,
                      obscure: _obscurePassword,
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.summerPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordEmail,
                          );
                        },
                        child: const Text(
                          "Quên mật khẩu?",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.summerPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: provider.isLoading ? null : _handleLogin,
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Đăng nhập",
                                style: textTheme.titleMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white70)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Hoặc",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white70)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              // implement Google login
                            },
                      icon: Image.asset("assets/images/google.png", height: 24),
                      label: Text(
                        "Đăng nhập bằng Google",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                        child: Text(
                          "Đăng ký tài khoản",
                          style: textTheme.titleMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: AppTheme.summerPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.driverRegister,
                                );
                              },
                        child: Text(
                          "Đăng ký với tư cách tài xế",
                          style: textTheme.titleMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: AppTheme.summerPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          color: AppTheme.summerPrimary,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          prefixIcon: Icon(icon, color: AppTheme.summerPrimary),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            color: AppTheme.summerPrimary,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppTheme.summerAccent,
              width: 1.5,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
