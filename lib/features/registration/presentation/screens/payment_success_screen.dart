import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderCode;

  const PaymentSuccessScreen({super.key, required this.orderCode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/mock/register_successfully_anim.json',
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 24),
              Text(
                "Thanh toán thành công!",
                style: textTheme.headlineSmall?.copyWith(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Mã đơn hàng của bạn:",
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.grey[700],
                ),
              ),
              Text(
                orderCode,
                style: textTheme.titleLarge?.copyWith(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.summerAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.registrationList,
                    (route) => false,
                  );
                },
                child: const Text(
                  "Xem lịch sử đăng ký",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
