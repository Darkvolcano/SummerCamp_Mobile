import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/registration_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/album/presentation/screens/camp_album_screen.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationCard extends StatelessWidget {
  final Registration registration;
  final VoidCallback? onTap;

  const RegistrationCard({super.key, required this.registration, this.onTap});

  Widget _buildStatusChip(RegistrationStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case RegistrationStatus.PendingApproval:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = "Chờ duyệt";
        break;
      case RegistrationStatus.Approved:
        backgroundColor = Colors.lightBlue.shade100;
        textColor = Colors.lightBlue.shade800;
        text = "Đã duyệt";
        break;
      case RegistrationStatus.PendingPayment:
        backgroundColor = Colors.yellow.shade100;
        textColor = Colors.yellow.shade900;
        text = "Chờ thanh toán";
        break;
      // case RegistrationStatus.PendingCompletion:
      //   backgroundColor = Colors.purple.shade100;
      //   textColor = Colors.purple.shade800;
      //   text = "Chờ hoàn thành";
      //   break;
      // case RegistrationStatus.PendingAssignGroup:
      //   backgroundColor = Colors.indigo.shade100;
      //   textColor = Colors.indigo.shade800;
      //   text = "Chờ phân nhóm";
      //   break;
      case RegistrationStatus.Confirmed:
        backgroundColor = Colors.teal.shade100;
        textColor = Colors.teal.shade800;
        text = "Đã xác nhận";
        break;
      case RegistrationStatus.Completed:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = "Hoàn thành";
        break;
      case RegistrationStatus.Canceled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = "Đã hủy";
        break;
      case RegistrationStatus.PendingRefund:
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        text = "Chờ hoàn tiền";
        break;
      case RegistrationStatus.Refunded:
        backgroundColor = Colors.grey.shade300;
        textColor = Colors.grey.shade800;
        text = "Đã hoàn tiền";
        break;
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
          fontFamily: "Quicksand",
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
            style: const TextStyle(fontFamily: "Quicksand", fontSize: 14),
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
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
                              registration.campName,
                              style: const TextStyle(
                                fontFamily: "Quicksand",
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

                      if (registration.status == RegistrationStatus.Completed ||
                          registration.status ==
                              RegistrationStatus.Confirmed) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CampAlbumScreen(
                                    campId: registration.campId!,
                                    campName: registration.campName,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              "Xem ảnh",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.summerPrimary,
                              side: const BorderSide(
                                color: AppTheme.summerPrimary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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
