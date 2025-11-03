import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:summercamp/core/config/app_theme.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String orderCode;

  const PaymentFailedScreen({super.key, required this.orderCode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/mock/register_failed_anim.json',
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 24),
              Text(
                "Thanh toán thất bại",
                style: textTheme.headlineSmall?.copyWith(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Đã có lỗi xảy ra với đơn hàng:",
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
                  backgroundColor: AppTheme.summerPrimary, // Màu khác
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Thử lại",
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
