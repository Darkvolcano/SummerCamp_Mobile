import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/widgets/animated_gradient_background.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;

  Future<void> _handleSubmit(String email, String otp) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<AuthProvider>();

    try {
      final message = await provider.resetPasswordUseCase(
        email,
        otp,
        newPasswordController.text,
      );

      if (!mounted) return;

      showCustomDialog(
        context,
        title: "Thành công",
        message: message,
        type: DialogType.success,
        btnText: "Đăng nhập ngay",
        onConfirm: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (_) => false,
          );
        },
      );

      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args["email"];
    final otp = args["otp"];
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(
            gradientColors: [
              Color(0xFFFFFFFF),
              Color(0xFFF5F5F5),
              Color(0xFFECEFF1),
            ],
            blobColors: [
              Color.fromARGB(30, 160, 163, 167),
              Color.fromARGB(30, 255, 140, 0),
              Color.fromARGB(30, 158, 158, 158),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Đặt lại mật khẩu",
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Vui lòng nhập mật khẩu mới của bạn.",
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: "Quicksand",
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildPasswordField(
                      newPasswordController,
                      "Mật khẩu mới",
                      _obscureNewPass,
                      () => setState(() => _obscureNewPass = !_obscureNewPass),
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      confirmPasswordController,
                      "Xác nhận mật khẩu mới",
                      _obscureConfirmPass,
                      () => setState(
                        () => _obscureConfirmPass = !_obscureConfirmPass,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu';
                        }
                        if (value != newPasswordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.summerPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () => _handleSubmit(email, otp),
                        child: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Xác nhận",
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: const Text(
                        "Đã có tài khoản? Đăng nhập",
                        style: TextStyle(
                          color: Color(0xFF546E7A),
                          fontStyle: FontStyle.italic,
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

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscureText,
    VoidCallback onToggleVisibility, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontFamily: "Quicksand", color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w600,
          color: AppTheme.summerPrimary.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
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
          borderSide: const BorderSide(color: AppTheme.summerAccent, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
            if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
            return null;
          },
    );
  }
}
