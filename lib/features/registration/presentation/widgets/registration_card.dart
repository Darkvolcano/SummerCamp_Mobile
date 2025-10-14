import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/status.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationCard extends StatelessWidget {
  final Registration registration;
  final VoidCallback? onTap;

  const RegistrationCard({super.key, required this.registration, this.onTap});

  Widget _buildStatusChip(Status status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case Status.InProgress:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = "Đang diễn ra";
        break;
      case Status.PendingApproval:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = "Chờ xử lý";
        break;
      case Status.Completed:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = "Hoàn thành";
        break;
      case Status.Canceled:
      case Status.Rejected:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = "Đã hủy";
        break;
      case Status.OpenForRegistration:
        backgroundColor = Colors.cyan.shade100;
        textColor = Colors.cyan.shade800;
        text = "Mở đăng ký";
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        text = "Không xác định";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Nunito",
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCampers = registration.campers.length;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 8,
                color: AppTheme.summerPrimary.withValues(alpha: 0.8),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              registration.campName ??
                                  'Tên trại không xác định',
                              style: const TextStyle(
                                fontFamily: "Fredoka",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.summerPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(registration.status),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _buildInfoRow(
                        Icons.people_outline,
                        "Số lượng: $totalCampers camper",
                        iconColor: AppTheme.summerAccent,
                      ),

                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.today_outlined,
                        "Ngày đăng ký: ${DateFormatter.formatDate(registration.registrationCreateAt)}",
                      ),
                      const SizedBox(height: 8),
                      if (registration.campStartDate != null &&
                          registration.campEndDate != null)
                        _buildInfoRow(
                          Icons.date_range_outlined,
                          "${registration.campStartDate} → ${registration.campEndDate}",
                        ),
                    ],
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
