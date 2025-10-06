import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:videosdk/videosdk.dart';
import '../../../../core/config/staff_theme.dart';

class CampScheduleDetailScreen extends StatelessWidget {
  final Camp camp;

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
    ),
    Activity(
      activityId: 3,
      name: "Team Building",
      description: "Trò chơi tập thể gắn kết",
      location: "Sân trung tâm",
      date: "2025-06-10",
      startTime: "10:15",
      endTime: "11:00",
      campId: 1,
    ),
    Activity(
      activityId: 4,
      name: "Lửa trại",
      description: "Giao lưu văn nghệ",
      location: "Khu trại chính",
      date: "2025-06-10",
      startTime: "13:00",
      endTime: "14:00",
      campId: 1,
    ),
    Activity(
      activityId: 5,
      name: "Team Building",
      description: "Trò chơi tập thể gắn kết",
      location: "Sân trung tâm",
      date: "2025-06-10",
      startTime: "17:00",
      endTime: "19:00",
      campId: 1,
    ),
    Activity(
      activityId: 6,
      name: "Lửa trại",
      description: "Giao lưu văn nghệ",
      location: "Khu trại chính",
      date: "2025-06-11",
      startTime: "19:00",
      endTime: "20:00",
      campId: 1,
    ),
    Activity(
      activityId: 7,
      name: "Team Building",
      description: "Trò chơi tập thể gắn kết",
      location: "Sân trung tâm",
      date: "2025-06-11",
      startTime: "08:00",
      endTime: "10:00",
      campId: 1,
    ),
    Activity(
      activityId: 8,
      name: "Lửa trại",
      description: "Giao lưu văn nghệ",
      location: "Khu trại chính",
      date: "2025-06-11",
      startTime: "12:00",
      endTime: "13:45",
      campId: 1,
    ),
  ];

  final List<Camper> campers = [
    Camper(
      camperId: 1,
      fullName: "Nguyễn Văn A",
      dob: "2010-05-12",
      gender: "Nam",
      healthRecordId: 1,
      createAt: DateTime.now(),
      parentId: 101,
      avatar:
          "https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174669.jpg?semt=ais_hybrid&w=740&q=80",
    ),
    Camper(
      camperId: 2,
      fullName: "Trần Thị B",
      dob: "2011-09-20",
      gender: "Nữ",
      healthRecordId: 2,
      createAt: DateTime.now(),
      parentId: 102,
      avatar:
          "https://img.freepik.com/free-vector/woman-with-braided-hair-illustration_1308-174675.jpg?semt=ais_hybrid&w=740&q=80",
    ),
  ];

  void onCreateButtonPressed(BuildContext context) async {
    await createLivestream().then((liveStreamId) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ILSScreen(
            liveStreamId: liveStreamId,
            token: token,
            mode: Mode.SEND_AND_RECV,
          ),
        ),
      );
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

  CampScheduleDetailScreen({super.key, required this.camp});

  Map<String, List<Activity>> groupActivitiesByDate(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    for (var act in activities) {
      grouped.putIfAbsent(act.date, () => []);
      grouped[act.date]!.add(act);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final groupedActivities = groupActivitiesByDate(activities);

    final totalDays = camp.endDate.difference(camp.startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          camp.name,
          style: const TextStyle(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (camp.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  camp.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            Text(
              camp.name,
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: StaffTheme.staffPrimary,
              ),
            ),
            const SizedBox(height: 6),
            if (camp.description.isNotEmpty)
              Text(
                camp.description,
                style: const TextStyle(
                  fontFamily: "Nunito",
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
                    camp.place,
                    style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.date_range, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "${DateFormatter.formatDate(camp.startDate)} - ${DateFormatter.formatDate(camp.endDate)}",
                  style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Hoạt động",
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: StaffTheme.staffPrimary,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final dayDate = camp.startDate.add(Duration(days: index));
                final dateStr = DateFormatter.formatDate(dayDate);
                final activitiesOfDay =
                    groupedActivities[dayDate.toIso8601String().substring(
                      0,
                      10,
                    )] ??
                    [];

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
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const Divider(),
                        if (activitiesOfDay.isEmpty)
                          const Text(
                            "Không có hoạt động",
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 14,
                            ),
                          )
                        else
                          Column(
                            children: activitiesOfDay.map((act) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: StaffTheme.staffAccent,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "${act.startTime} - ${act.endTime} • ${act.name} @ ${act.location}",
                                        style: const TextStyle(
                                          fontFamily: "Nunito",
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
                        arguments: {"camp": camp, "campers": campers},
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      "Điểm danh",
                      style: TextStyle(fontFamily: "Nunito", fontSize: 16),
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
                        arguments: camp,
                      );
                    },
                    icon: const Icon(Icons.photo_camera),
                    label: const Text(
                      "Photo",
                      style: TextStyle(fontFamily: "Nunito", fontSize: 16),
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
                      style: TextStyle(fontFamily: "Nunito", fontSize: 16),
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
                      style: TextStyle(fontFamily: "Nunito", fontSize: 16),
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
