import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/animated_gradient_background.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  late final AuthProvider provider;

  Timer? _timer;
  int _countdownSeconds = 120;
  bool get _isResendActive => _timer?.isActive ?? false;

  @override
  void initState() {
    super.initState();
    provider = context.read<AuthProvider>();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _countdownSeconds = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        if (mounted) {
          setState(() {
            _countdownSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        if (mounted) {
          setState(() {});
        }
      }
    });
    setState(() {});
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String get _otpCode {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isOtpComplete {
    return _otpCode.length == 6;
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  Future<void> _verifyOtp(String email) async {
    if (!_isOtpComplete) {
      showCustomDialog(
        context,
        title: "Chưa hoàn tất",
        message: "Vui lòng nhập đầy đủ 6 số OTP.",
        type: DialogType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await provider.verifyOtp(email: email, otp: _otpCode);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      showCustomDialog(
        context,
        title: "Xác thực thành công!",
        message: "Tài khoản của bạn đã được xác minh. Vui lòng đăng nhập.",
        type: DialogType.success,
        dismissible: false,
        btnText: "Đăng nhập ngay",
        onConfirm: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        },
      );
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context,
        title: "Xác thực thất bại",
        message: "Mã OTP không đúng hoặc đã hết hạn. Vui lòng thử lại.",
        type: DialogType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp(String email) async {
    startTimer();
    setState(() => _isLoading = true);

    try {
      await provider.resendOtp(email: email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã OTP mới đã được gửi đến email của bạn.'),
          backgroundColor: Colors.green,
        ),
      );

      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context,
        title: "Lỗi gửi mã",
        message: "Không thể gửi lại mã OTP. Vui lòng kiểm tra kết nối mạng.",
        type: DialogType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentEmail = widget.email;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(
            gradientColors: [
              Color(0xFF7F1D1D),
              Color(0xFFC2410C),
              Color(0xFFEA580C),
            ],
            blobColors: [
              Color.fromARGB(40, 249, 115, 22),
              Color.fromARGB(40, 251, 146, 60),
              Color.fromARGB(40, 251, 191, 36),
            ],
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.email_outlined,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Xác thực OTP",
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Mã OTP đã được gửi đến",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontFamily: "Quicksand",
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      currentEmail,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 45,
                          height: 45,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.summerPrimary,
                              fontFamily: "Quicksand",
                            ),
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isCollapsed: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onOtpChanged(index, value),
                            onTap: () {
                              _controllers[index].selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _controllers[index].text.length,
                                    ),
                                  );
                            },
                            onSubmitted: (value) {
                              if (index < 5 && value.isNotEmpty) {
                                _focusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.summerPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () => _verifyOtp(currentEmail),
                        child: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Xác thực",
                                style: textTheme.titleMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Không nhận được mã? ",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontFamily: "Quicksand",
                          ),
                        ),
                        TextButton(
                          onPressed: (_isLoading || _isResendActive)
                              ? null
                              : () => _resendOtp(currentEmail),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            disabledForegroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Gửi lại",
                                style: TextStyle(
                                  color: (_isLoading || _isResendActive)
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                              if (_isResendActive)
                                Text(
                                  " (${_formatDuration(_countdownSeconds)})",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow[200],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
