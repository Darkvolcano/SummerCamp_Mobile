import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/animated_gradient_background.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  DateTime? selectedDate;

  bool _isSuccess = false;

  bool _obscurePassword = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      locale: const Locale("vi", "VN"),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (value.length < 10) {
      return 'Số điện thoại phải có ít nhất 10 số';
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

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      _showErrorDialog('Vui lòng chọn ngày sinh');
      return;
    }

    final provider = context.read<AuthProvider>();
    final email = emailController.text.trim();

    try {
      await provider.register(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: email,
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
        dob: DateFormat("yyyy-MM-dd").format(selectedDate!),
      );

      if (!mounted) return;

      if (provider.error == null) {
        setState(() => _isSuccess = true);

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.verifyOTP,
              arguments: email,
            );
          }
        });
      } else {
        _showErrorDialog(provider.registerResponse!.message);
      }
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Đăng ký thất bại. Vui lòng thử lại.';

      if (e.toString().contains('connection error')) {
        errorMessage =
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối mạng.';
      } else if (e.toString().contains('NetworkException')) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng thử lại sau.';
      }

      _showErrorDialog(errorMessage);
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isSuccess
                    ? Column(
                        key: const ValueKey('success'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 250,
                            child: Lottie.asset(
                              "assets/mock/email_successfully_sent_anim.json",
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Đăng ký thành công!",
                            style: textTheme.headlineSmall?.copyWith(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              color: AppTheme.summerPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Mã xác thực đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.",
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              fontFamily: "Quicksand",
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const CircularProgressIndicator(
                            color: AppTheme.summerPrimary,
                          ),
                        ],
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          key: const ValueKey('form'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tạo tài khoản",
                              style: textTheme.headlineSmall?.copyWith(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w800,
                                color: AppTheme.summerPrimary,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildShadowInput(
                              controller: firstNameController,
                              label: "Họ",
                              icon: Icons.person,
                              validator: (v) => _validateRequired(v, 'họ'),
                            ),
                            _buildShadowInput(
                              controller: lastNameController,
                              label: "Tên",
                              icon: Icons.person_outline,
                              validator: (v) => _validateRequired(v, 'tên'),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.15),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: dobController,
                                readOnly: true,
                                style: const TextStyle(
                                  color: AppTheme.summerPrimary,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: AppTheme.summerPrimary,
                                  ),
                                  labelText: "Ngày sinh",
                                  labelStyle: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.summerPrimary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppTheme.summerAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                    ? 'Vui lòng chọn ngày sinh'
                                    : null,
                                onTap: () => _selectDate(context),
                              ),
                            ),
                            _buildShadowInput(
                              controller: emailController,
                              label: "Email",
                              icon: Icons.email,
                              validator: _validateEmail,
                            ),
                            _buildShadowInput(
                              controller: phoneController,
                              label: "Số điện thoại",
                              icon: Icons.phone,
                              validator: _validatePhone,
                              keyboardType: TextInputType.phone,
                            ),
                            _buildShadowInput(
                              controller: passwordController,
                              label: "Mật khẩu",
                              icon: Icons.lock,
                              obscure: _obscurePassword,
                              validator: _validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.summerPrimary,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.summerPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.summerPrimary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: provider.isLoading
                                    ? null
                                    : _handleRegister,
                                child: provider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "Đăng ký",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.35),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: AppTheme.summerPrimary,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          prefixIcon: Icon(icon, color: AppTheme.summerPrimary),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            color: AppTheme.summerPrimary.withValues(alpha: 0.7),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.summerAccent,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
