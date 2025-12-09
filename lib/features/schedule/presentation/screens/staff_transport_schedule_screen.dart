import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/enum/transport_schedule_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class StaffTransportScheduleScreen extends StatefulWidget {
  const StaffTransportScheduleScreen({super.key});

  @override
  State<StaffTransportScheduleScreen> createState() =>
      _StaffTransportScheduleScreenState();
}

class _StaffTransportScheduleScreenState
    extends State<StaffTransportScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().loadStaffTransportSchedules();
    });
  }

  void _showStatusDialog(String message, {bool isSuccess = true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 4500), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? "Thành công" : "Thất bại",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleUpdateStatus(TransportSchedule trip) async {
    final provider = context.read<ScheduleProvider>();

    try {
      if (trip.status == TransportScheduleStatus.NotYet) {
        // if not start call this API
        await provider.updateTransportScheduleStartTrip(
          trip.transportScheduleId,
        );
        if (mounted) {
          _showStatusDialog('Đã bắt đầu chuyến đi!', isSuccess: true);
        }
      } else if (trip.status == TransportScheduleStatus.InProgress) {
        // if in progress call this API
        await provider.updateTransportScheduleEndTrip(trip.transportScheduleId);
        if (mounted) {
          _showStatusDialog('Đã hoàn thành chuyến đi!', isSuccess: true);
        }
      }

      if (mounted) {
        provider.loadStaffTransportSchedules();
      }
    } catch (e) {
      if (mounted) {
        _showStatusDialog('Lỗi cập nhật: ${e.toString()}', isSuccess: false);
      }
    }
  }

  String _getStatusText(TransportScheduleStatus status) {
    switch (status) {
      case TransportScheduleStatus.NotYet:
        return "Chưa bắt đầu";
      case TransportScheduleStatus.InProgress:
        return "Đang đi";
      case TransportScheduleStatus.Completed:
        return "Hoàn thành";
      case TransportScheduleStatus.Canceled:
        return "Đã hủy";
      default:
        return "Không xác định";
    }
  }

  Color _getStatusColor(TransportScheduleStatus status) {
    switch (status) {
      case TransportScheduleStatus.NotYet:
        return Colors.orange;
      case TransportScheduleStatus.InProgress:
        return Colors.blue;
      case TransportScheduleStatus.Completed:
        return Colors.green;
      case TransportScheduleStatus.Canceled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      if (timeStr.isEmpty) return DateTime.parse(dateStr);

      return DateTime.parse("${dateStr}T$timeStr");
    } catch (e) {
      print("Lỗi parse ngày giờ: $e");
      return DateTime.now();
    }
  }

  bool _isActionAllowed(TransportSchedule trip) {
    final now = DateTime.now();

    final tripDate = DateTime.parse(trip.date);
    final isToday =
        tripDate.year == now.year &&
        tripDate.month == now.month &&
        tripDate.day == now.day;

    if (!isToday) return false;

    final startDateTime = _parseDateTime(trip.date, trip.startTime);
    final endDateTime = _parseDateTime(trip.date, trip.endTime);

    if (trip.status == TransportScheduleStatus.NotYet) {
      final allowedStartWindow = startDateTime.subtract(
        const Duration(minutes: 30),
      );
      final allowedEndWindow = startDateTime.add(const Duration(minutes: 60));
      return now.isAfter(allowedStartWindow) && now.isBefore(allowedEndWindow);
    } else if (trip.status == TransportScheduleStatus.InProgress) {
      final earliestEndTime = endDateTime.subtract(const Duration(minutes: 30));
      final latestEndTime = endDateTime.add(const Duration(minutes: 90));

      return now.isAfter(earliestEndTime) && now.isBefore(latestEndTime);
    }

    return false;
  }

  void _showDisabledReason(TransportSchedule trip) {
    final now = DateTime.now();
    final tripDate = DateTime.parse(trip.date);
    final isToday =
        tripDate.year == now.year &&
        tripDate.month == now.month &&
        tripDate.day == now.day;

    if (!isToday) {
      _showStatusDialog("Chuyến đi không phải ngày hôm nay!", isSuccess: false);
      return;
    }

    final startDateTime = _parseDateTime(trip.date, trip.startTime);
    final endDateTime = _parseDateTime(trip.date, trip.endTime);
    String message = "";

    if (trip.status == TransportScheduleStatus.NotYet) {
      message =
          "Chỉ được bắt đầu từ ${DateFormatter.formatTime(startDateTime.subtract(const Duration(minutes: 30)))} đến ${DateFormatter.formatTime(startDateTime.add(const Duration(minutes: 60)))}";
    } else if (trip.status == TransportScheduleStatus.InProgress) {
      message =
          "Đã quá thời gian cho phép kết thúc chuyến đi (${DateFormatter.formatTime(endDateTime.add(const Duration(minutes: 120)))})";
    }

    if (message.isNotEmpty) {
      _showStatusDialog(message, isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<ScheduleProvider>();
    final schedules = provider.transportSchedules;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch làm việc",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        automaticallyImplyLeading: false,
      ),
      body: provider.loading && schedules.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : schedules.isEmpty
          ? const Center(
              child: Text(
                "Chưa có lịch trình nào.",
                style: TextStyle(fontFamily: "Quicksand"),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final trip = schedules[index];
                final isCompleted =
                    trip.status == TransportScheduleStatus.Completed;
                final isCanceled =
                    trip.status == TransportScheduleStatus.Canceled;

                // final canUpdate = !isCompleted && !isCanceled;

                String buttonLabel = "Cập nhật";
                IconData buttonIcon = Icons.update;

                if (trip.status == TransportScheduleStatus.NotYet) {
                  buttonLabel = "Bắt đầu chuyến đi";
                  buttonIcon = Icons.play_arrow;
                } else if (trip.status == TransportScheduleStatus.InProgress) {
                  buttonLabel = "Kết thúc chuyến đi";
                  buttonIcon = Icons.stop;
                } else if (isCompleted) {
                  buttonLabel = "Đã hoàn thành";
                  buttonIcon = Icons.check_circle;
                }

                final startDateTime = _parseDateTime(trip.date, trip.startTime);
                final endDateTime = _parseDateTime(trip.date, trip.endTime);
                final actualStartDateTime = _parseDateTime(
                  trip.date,
                  trip.actualStartTime ?? '',
                );
                final actualEndDateTime = _parseDateTime(
                  trip.date,
                  trip.actualEndTime ?? '',
                );

                final bool isTimeAllowed = _isActionAllowed(trip);
                final bool canUpdate =
                    !isCompleted && !isCanceled && isTimeAllowed;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormatter.formatTime(startDateTime)} - ${DateFormatter.formatTime(endDateTime)}",
                              style: textTheme.bodyLarge?.copyWith(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold,
                                color: StaffTheme.staffAccent,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  trip.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(
                                    trip.status,
                                  ).withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                _getStatusText(trip.status),
                                style: textTheme.bodySmall?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(trip.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Tuyến: ${trip.routeName.routeName}",
                          style: textTheme.titleMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Ngày: ${DateFormatter.formatFromString(trip.date)}",
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                            color: Colors.grey[600],
                          ),
                        ),

                        const Divider(height: 24),

                        Row(
                          children: [
                            const Icon(
                              Icons.directions_bus,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Xe: ${trip.vehicleName.vehicleName}",
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: "Quicksand",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        if ((trip.actualStartTime ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_outline,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Bắt đầu lúc: ${(DateFormatter.formatTime(actualStartDateTime))}",
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontFamily: "Quicksand",
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if ((trip.actualEndTime ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.stop_circle_outlined,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Kết thúc lúc: ${(DateFormatter.formatTime(actualEndDateTime))}",
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontFamily: "Quicksand",
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canUpdate
                                  ? StaffTheme.staffPrimary
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // onPressed: canUpdate
                            //     ? () => _handleUpdateStatus(trip)
                            //     : null,
                            onPressed: canUpdate
                                ? () => _handleUpdateStatus(trip)
                                : () {
                                    if (!isCompleted && !isCanceled) {
                                      _showDisabledReason(trip);
                                    }
                                  },
                            icon: Icon(
                              buttonIcon,
                              size: 20,
                              color: Colors.white,
                            ),
                            label: Text(
                              buttonLabel,
                              style: const TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(
                                color: StaffTheme.staffPrimary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.staffTransportScheduleAttendance,
                                arguments: trip,
                              );
                            },
                            icon: const Icon(
                              Icons.people_alt_outlined,
                              size: 20,
                              color: StaffTheme.staffPrimary,
                            ),
                            label: const Text(
                              "Danh sách camper",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold,
                                color: StaffTheme.staffPrimary,
                              ),
                            ),
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
}
