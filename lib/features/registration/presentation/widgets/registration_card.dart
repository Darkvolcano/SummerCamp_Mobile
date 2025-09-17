import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationCard extends StatelessWidget {
  final Registration registration;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RegistrationCard({
    super.key,
    required this.registration,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice = registration.price - (registration.discount ?? 0);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      registration.campName,
                      style: const TextStyle(
                        fontFamily: "Fredoka",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.info, size: 16, color: AppTheme.summerAccent),
                  const SizedBox(width: 6),
                  Text(
                    "Trạng thái: ${registration.status}",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    registration.campPlace,
                    style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${DateFormatter.formatDate(registration.campStartDate)} → ${DateFormatter.formatDate(registration.campEndDate)}",
                    style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    registration.discount != null && registration.discount! > 0
                        ? "${PriceFormatter.format(registration.price)}  →  ${PriceFormatter.format(discountedPrice)}"
                        : PriceFormatter.format(registration.price),
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
