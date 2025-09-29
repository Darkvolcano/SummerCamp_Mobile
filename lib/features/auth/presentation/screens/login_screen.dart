import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                  child: Lottie.asset(
                    "assets/mock/login_icons.json",
                    repeat: true,
                    animate: true,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Summer Camp",
                  style: textTheme.headlineSmall?.copyWith(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        offset: Offset(0, 2),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _buildInputField(emailController, "Email", Icons.email),
                _buildInputField(
                  passwordController,
                  "Mật khẩu",
                  Icons.lock,
                  obscure: true,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/forgot-password");
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                    onPressed: () {
                      provider.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: Text(
                      "Đăng nhập",
                      style: textTheme.titleMedium?.copyWith(
                        fontFamily: "Fredoka",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white70)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or", style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(child: Divider(color: Colors.white70)),
                  ],
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Đăng nhập bằng Google
                  },
                  icon: Image.asset("assets/images/google.png", height: 24),
                  label: Text(
                    "Đăng nhập bằng Google",
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(
                      "Đăng ký tài khoản",
                      style: textTheme.titleMedium?.copyWith(
                        fontFamily: "Fredoka",
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
    );
  }

  Widget _buildInputField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.summerPrimary),
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
            color: AppTheme.summerPrimary,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
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
      ),
    );
  }
}
