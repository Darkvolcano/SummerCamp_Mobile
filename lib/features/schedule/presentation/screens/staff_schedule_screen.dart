import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class StaffScheduleScreen extends StatefulWidget {
  const StaffScheduleScreen({super.key});

  @override
  State<StaffScheduleScreen> createState() => _StaffScheduleScreenState();
}

class _StaffScheduleScreenState extends State<StaffScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().loadStaffSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<ScheduleProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.schedules.isEmpty && !provider.loading) {
        provider.loadStaffSchedules();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camps Quản Lý",
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.schedules.isEmpty
          ? Center(
              child: Text(
                "Không có camp nào",
                style: TextStyle(fontFamily: "Quicksand", fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.schedules.length,
              itemBuilder: (context, index) {
                final schedule = provider.schedules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.staffScheduleDetail,
                        arguments: schedule,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            if (schedule.image.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  schedule.image,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 160,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: _buildStatusChip(schedule.status),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule.name,
                                style: textTheme.titleMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: StaffTheme.staffPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (schedule.description.isNotEmpty)
                                Text(
                                  schedule.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      schedule.place,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${DateFormatter.formatFromString(schedule.startDate)} - ${DateFormatter.formatFromString(schedule.endDate)}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(CampStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case CampStatus.Draft:
      case CampStatus.PendingApproval:
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

    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontFamily: "Quicksand",
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
