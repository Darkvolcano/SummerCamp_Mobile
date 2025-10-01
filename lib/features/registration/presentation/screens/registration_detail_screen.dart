import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:videosdk/videosdk.dart';

class RegistrationDetailScreen extends StatelessWidget {
  final Registration registration;

  final List<Activity> activities = [
    Activity(
      activityId: 1,
      name: "Team Building",
      description: "Trò chơi tập thể gắn kết",
      location: "Sân trung tâm",
      date: "2025-06-10",
      startTime: "08:00",
      endTime: "10:00",
      campId: 1,
      isLivestream: true,
      livestreamId: "abcd-efgh-ijkl",
    ),
    Activity(
      activityId: 2,
      name: "Lửa trại",
      description: "Giao lưu văn nghệ",
      location: "Khu trại chính",
      date: "2025-06-10",
      startTime: "19:00",
      endTime: "20:00",
      campId: 1,
      isLivestream: true,
      livestreamId: "mnop-qrst-uvwx",
    ),
    Activity(
      activityId: 3,
      name: "Bơi lội",
      description: "Học bơi cơ bản",
      location: "Hồ bơi",
      date: "2025-06-11",
      startTime: "10:00",
      endTime: "11:30",
      campId: 1,
      isLivestream: false,
    ),
  ];

  RegistrationDetailScreen({super.key, required this.registration});

  Map<String, List<Activity>> groupActivitiesByDate(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    for (var act in activities) {
      grouped.putIfAbsent(act.date, () => []);
      grouped[act.date]!.add(act);
    }
    return grouped;
  }

  bool isActivityLive(Activity activity) {
    final now = DateTime.now();
    final activityDate = DateTime.parse(activity.date);
    final startTimeParts = activity.startTime.split(':');
    final endTimeParts = activity.endTime.split(':');

    final startTime = DateTime(
      activityDate.year,
      activityDate.month,
      activityDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );

    final endTime = DateTime(
      activityDate.year,
      activityDate.month,
      activityDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );

    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  void joinLivestream(BuildContext context, Activity activity) {
    if (activity.livestreamId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ILSScreen(
          liveStreamId: activity.livestreamId!,
          token: "YOUR_VIDEOSDK_TOKEN",
          mode: Mode.RECV_ONLY,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final discountedPrice = registration.price - (registration.discount ?? 0);
    final groupedActivities = groupActivitiesByDate(activities);
    final totalDays =
        registration.campEndDate.difference(registration.campStartDate).inDays +
        1;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registration.campName,
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: "Fredoka",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registration.campDescription,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            registration.campPlace,
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${DateFormatter.formatDate(registration.campStartDate)} - ${DateFormatter.formatDate(registration.campEndDate)}",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin đăng ký",
                      style: textTheme.titleMedium?.copyWith(
                        fontFamily: "Fredoka",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trạng thái:",
                          style: TextStyle(fontFamily: "Nunito", fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: registration.status == "Approved"
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            registration.status,
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: registration.status == "Approved"
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Giá:",
                          style: TextStyle(fontFamily: "Nunito", fontSize: 14),
                        ),
                        Text(
                          registration.discount != null &&
                                  registration.discount! > 0
                              ? PriceFormatter.format(discountedPrice)
                              : PriceFormatter.format(registration.price),
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    if (registration.discount != null &&
                        registration.discount! > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Giảm giá:",
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "-${PriceFormatter.format(registration.discount!)}",
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ngày đăng ký:",
                          style: TextStyle(fontFamily: "Nunito", fontSize: 14),
                        ),
                        Text(
                          DateFormatter.formatFull(
                            registration.registrationCreateAt,
                          ),
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Lịch trình hoạt động",
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final dayDate = registration.campStartDate.add(
                  Duration(days: index),
                );
                final dateStr = DateFormatter.formatDate(dayDate);
                final activitiesOfDay =
                    groupedActivities[dayDate.toIso8601String().substring(
                      0,
                      10,
                    )] ??
                    [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày ${index + 1} - $dateStr",
                          style: const TextStyle(
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const Divider(),
                        if (activitiesOfDay.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Không có hoạt động",
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          ...activitiesOfDay.map((act) {
                            final isLive =
                                act.isLivestream && isActivityLive(act);

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isLive
                                      ? Colors.red.shade300
                                      : Colors.grey.shade200,
                                  width: isLive ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppTheme.summerAccent,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${act.startTime} - ${act.endTime}",
                                        style: const TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (isLive) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                "LIVE",
                                                style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    act.name,
                                    style: const TextStyle(
                                      fontFamily: "Fredoka",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        act.location,
                                        style: TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (act.isLivestream) ...[
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isLive
                                              ? Colors.red
                                              : Colors.grey.shade400,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLive
                                            ? () => joinLivestream(context, act)
                                            : null,
                                        icon: Icon(
                                          isLive
                                              ? Icons.videocam
                                              : Icons.videocam_off,
                                          size: 18,
                                        ),
                                        label: Text(
                                          isLive
                                              ? "Tham gia Livestream"
                                              : "Livestream chưa bắt đầu",
                                          style: const TextStyle(
                                            fontFamily: "Nunito",
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
