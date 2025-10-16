import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:videosdk/videosdk.dart';

class CampScheduleDetailScreen extends StatefulWidget {
  final Camp camp;
  const CampScheduleDetailScreen({super.key, required this.camp});

  @override
  State<CampScheduleDetailScreen> createState() =>
      _CampScheduleDetailScreenState();
}

class _CampScheduleDetailScreenState extends State<CampScheduleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActivityProvider>().loadActivities(widget.camp.campId);
        context.read<CamperProvider>().loadCampers();
      }
    });
  }

  void onJoinLivestreamPressed(BuildContext context, String roomId, Mode mode) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ILSScreen(
          liveStreamId: roomId,
          token: token,
          mode: Mode.SEND_AND_RECV,
        ),
      ),
    );
  }

  Map<String, List<Activity>> groupActivitiesByDate(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    for (var act in activities) {
      String dateKey = DateFormatter.formatDate(act.startTime);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(act);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activityProvider = context.watch<ActivityProvider>();
    final camperProvider = context.watch<CamperProvider>();
    final activities = activityProvider.activities;
    final campers = camperProvider.campers;
    final groupedActivities = groupActivitiesByDate(activities);

    final startDate = DateTime.parse(widget.camp.startDate);
    final endDate = DateTime.parse(widget.camp.endDate);
    final totalDays = endDate.difference(startDate).inDays + 1;

    final isLoading = activityProvider.loading || camperProvider.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.camp.name,
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.camp.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.camp.image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  Text(
                    widget.camp.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.camp.description.isNotEmpty)
                    Text(
                      widget.camp.description,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.camp.place,
                          style: const TextStyle(
                            fontFamily: "Quicksand",
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
                        Icons.date_range,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${DateFormatter.formatFromString(widget.camp.startDate)} - ${DateFormatter.formatFromString(widget.camp.endDate)}",
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Hoạt động",
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (activityProvider.loading)
                    const Center(child: CircularProgressIndicator())
                  else if (activities.isEmpty)
                    const Center(
                      child: Text(
                        "Chưa có hoạt động nào cho trại này.",
                        style: TextStyle(fontFamily: "Quicksand"),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: totalDays,
                      itemBuilder: (context, index) {
                        final dayDate = startDate.add(Duration(days: index));
                        final dateStr = DateFormatter.formatDate(dayDate);
                        final activitiesOfDay =
                            groupedActivities[dateStr] ?? [];

                        activitiesOfDay.sort(
                          (a, b) => a.startTime.compareTo(b.startTime),
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ngày ${index + 1} - $dateStr",
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Divider(),
                                if (activitiesOfDay.isEmpty)
                                  const Text(
                                    "Không có hoạt động",
                                    style: TextStyle(fontFamily: "Quicksand"),
                                  )
                                else
                                  Column(
                                    children: activitiesOfDay.map((act) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 18,
                                              color: StaffTheme.staffAccent,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                "${DateFormatter.formatTime(act.startTime)} - ${DateFormatter.formatTime(act.endTime)} • ${act.name} @ ${act.location}",
                                                style: const TextStyle(
                                                  fontFamily: "Quicksand",
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: StaffTheme.staffAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.attendance,
                              arguments: {
                                "camp": widget.camp,
                                "campers": campers,
                              },
                            );
                          },
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            "Điểm danh",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.uploadPhoto,
                              arguments: widget.camp,
                            );
                          },
                          icon: const Icon(Icons.photo_camera),
                          label: const Text(
                            "Photo",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: StaffTheme.staffAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // onPressed: () {
                          //   Navigator.pushNamed(context, AppRoutes.joinLivestream);
                          // },
                          // onPressed: () => onCreateButtonPressed(context),
                          onPressed: () {
                            onJoinLivestreamPressed(
                              context,
                              // camp.roomId,
                              'ic99-z3ap-2yns',
                              Mode.SEND_AND_RECV,
                            );
                          },
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            "Livestream",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.faceRecognitionAttendance,
                              arguments: campers,
                            );
                          },
                          icon: const Icon(Icons.photo_camera),
                          label: const Text(
                            "Điểm danh khuôn mặt",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
