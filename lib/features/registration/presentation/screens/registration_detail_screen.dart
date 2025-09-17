import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationDetailScreen extends StatelessWidget {
  final Registration registration;

  const RegistrationDetailScreen({super.key, required this.registration});

  @override
  Widget build(BuildContext context) {
    final discountedPrice = registration.price - (registration.discount ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chi tiết đăng ký",
          style: TextStyle(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              registration.campName,
              style: const TextStyle(
                fontFamily: "Fredoka",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              registration.campDescription,
              style: const TextStyle(fontFamily: "Nunito", fontSize: 16),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  registration.campPlace,
                  style: const TextStyle(fontFamily: "Nunito", fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "${DateFormatter.formatDate(registration.campStartDate)} → ${DateFormatter.formatDate(registration.campEndDate)}",
                  style: const TextStyle(fontFamily: "Nunito", fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              "Trạng thái: ${registration.status}",
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              registration.discount != null && registration.discount! > 0
                  ? "Giá: ${PriceFormatter.format(registration.price)}  →  ${PriceFormatter.format(discountedPrice)}"
                  : "Giá: ${PriceFormatter.format(registration.price)}",
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Mã khuyến mãi: ${registration.promotionCode ?? "-"}",
              style: const TextStyle(fontFamily: "Nunito", fontSize: 16),
            ),
            const SizedBox(height: 20),

            Text(
              "Ngày đăng ký: ${DateFormatter.formatFull(registration.registrationCreateAt)}",
              style: const TextStyle(fontFamily: "Nunito", fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
