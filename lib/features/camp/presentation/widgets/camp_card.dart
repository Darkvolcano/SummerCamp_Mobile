import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';

class CampCard extends StatelessWidget {
  final Camp camp;
  const CampCard({super.key, required this.camp});

  Widget _buildPrice(BuildContext context, Camp camp) {
    final textTheme = Theme.of(context).textTheme;
    final double price = camp.price;

    if (camp.promotion == null) {
      return Text(
        "${PriceFormatter.format(price)}/người",
        style: textTheme.titleLarge?.copyWith(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
          color: AppTheme.summerAccent,
          fontSize: 16,
        ),
      );
    }

    final double percent = (camp.promotion!.percent as num).toDouble();
    final double maxDiscount = (camp.promotion!.maxDiscountAmount as num)
        .toDouble();

    double discount = price * (percent / 100);
    if (discount > maxDiscount) {
      discount = maxDiscount;
    }
    final double newPrice = price - discount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${PriceFormatter.format(newPrice)}/người",
          style: textTheme.titleLarge?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: AppTheme.summerAccent,
            fontSize: 16,
          ),
        ),
        Text(
          "${PriceFormatter.format(price)}/người",
          style: textTheme.bodyMedium?.copyWith(
            fontFamily: "Quicksand",
            color: Colors.grey[600],
            fontSize: 12,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.campDetail, arguments: camp);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  camp.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildStatusBadge(camp.status),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camp.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    icon: Icons.place_outlined,
                    text: camp.place,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    text:
                        "${DateFormatter.formatFromString(camp.startDate)} - ${DateFormatter.formatFromString(camp.endDate)}",
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    context,
                    icon: Icons.child_care_outlined,
                    text:
                        "Độ tuổi: ${camp.minAge ?? '?'} - ${camp.maxAge ?? '?'} tuổi",
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Giá",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Quicksand",
                          color: Colors.grey[600],
                        ),
                      ),

                      _buildPrice(context, camp),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: "Quicksand",
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(CampStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case CampStatus.PendingApproval:
      case CampStatus.Draft:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = "Chờ duyệt";
        break;
      case CampStatus.Rejected:
      case CampStatus.Canceled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = "Đã hủy/Từ chối";
        break;
      case CampStatus.Published:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        text = "Đã công bố";
        break;
      case CampStatus.OpenForRegistration:
        backgroundColor = Colors.cyan.shade100;
        textColor = Colors.cyan.shade800;
        text = "Mở đăng ký";
        break;
      case CampStatus.RegistrationClosed:
        backgroundColor = Colors.blueGrey.shade100;
        textColor = Colors.blueGrey.shade800;
        text = "Đóng đăng ký";
        break;
      case CampStatus.InProgress:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = "Đang diễn ra";
        break;
      case CampStatus.Completed:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = "Hoàn thành";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Quicksand",
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
