import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:videosdk/videosdk.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class StaffScheduleDetailScreen extends StatefulWidget {
  final Schedule schedule;
  const StaffScheduleDetailScreen({super.key, required this.schedule});

  @override
  State<StaffScheduleDetailScreen> createState() =>
      _StaffScheduleDetailScreenState();
}

class _StaffScheduleDetailScreenState extends State<StaffScheduleDetailScreen> {
  int? _fetchingActivityId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final activityProvider = context.read<ActivityProvider>();
        activityProvider.loadActivitySchedulesByCampId(widget.schedule.campId);

        _preloadFaceData();
      }
    });
  }

  Future<void> _preloadFaceData() async {
    try {
      final attendanceProvider = context.read<AttendanceProvider>();
      await attendanceProvider.preloadFaceData(
        widget.schedule.campId,
        forceReload: false,
      );
      print(
        "Preload face data initiated for Camp ID: ${widget.schedule.campId}",
      );
    } catch (e) {
      print("Warning: Preload face data failed: $e");
    }
  }

  void onJoinLivestreamPressed(BuildContext context, String roomId, Mode mode) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ILSScreen(
          liveStreamId: roomId,
          token:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0ZWQzZTNmNC0zMjBlLTQ5ZGYtOWM3ZS1kZjViZWMxNmIxOTkiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1OTEzNTYwOSwiZXhwIjoxNzc0Njg3NjA5fQ.5m-pLjkx_fqpc4nYWeEl-Xkbt_8uIg8o2tlnjlY-irU",
          mode: Mode.SEND_AND_RECV,
        ),
      ),
    );
  }

  void _showAttendanceOptions(
    BuildContext context,
    ActivitySchedule activity,
  ) async {
    final camperProvider = context.read<CamperProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _fetchingActivityId = activity.activityScheduleId);

    try {
      List<Camper> campersToShow = [];

      if (activity.activity?.activityType == "Core" ||
          activity.activity?.activityType == "Checkin" ||
          activity.activity?.activityType == "Checkout" ||
          activity.activity?.activityType == "Resting") {
        await camperProvider.loadCampersByCoreActivityId(
          activity.activityScheduleId,
        );
        campersToShow = camperProvider.campersCoreActivity;
      } else if (activity.activity?.activityType == "Optional") {
        await camperProvider.loadCampersByOptionalActivityId(
          activity.activityScheduleId,
        );
        campersToShow = camperProvider.campersOptionalActivity;
      } else {
        throw Exception(
          "Loại hoạt động không xác định: ${activity.activity?.activityType}",
        );
      }

      if (!mounted) return;

      showModalBottomSheet(
        context: this.context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Chọn phương thức điểm danh",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.list_alt_rounded,
                    color: StaffTheme.staffPrimary,
                  ),
                  title: const Text(
                    "Điểm danh thủ công",
                    style: TextStyle(fontFamily: "Quicksand"),
                  ),
                  onTap: () {
                    navigator.pop();
                    navigator.pushNamed(
                      AppRoutes.attendance,
                      arguments: {
                        "schedule": widget.schedule,
                        "campers": campersToShow,
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.face_retouching_natural,
                    color: StaffTheme.staffPrimary,
                  ),
                  title: const Text(
                    "Điểm danh bằng khuôn mặt",
                    style: TextStyle(fontFamily: "Quicksand"),
                  ),
                  onTap: () {
                    navigator.pop();
                    navigator.pushNamed(
                      AppRoutes.faceRecognitionAttendance,
                      arguments: {
                        "campers": campersToShow,
                        "activityScheduleId": activity.activityScheduleId,
                        "campId": widget.schedule.campId,
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Lỗi tải danh sách camper: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _fetchingActivityId = null);
      }
    }
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.grey.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: StaffTheme.staffPrimary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<ActivitySchedule>> groupActivitiesByDate(
    List<ActivitySchedule> activities,
  ) {
    final Map<String, List<ActivitySchedule>> grouped = {};
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
    final activities = activityProvider.activitySchedules;
    final groupedActivities = groupActivitiesByDate(activities);

    final startDate = DateTime.parse(widget.schedule.startDate);
    final endDate = DateTime.parse(widget.schedule.endDate);
    final totalDays = endDate.difference(startDate).inDays + 1;

    final isLoading = activityProvider.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.schedule.name,
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading && activities.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: StaffTheme.staffPrimary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.schedule.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.schedule.image,
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
                    widget.schedule.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.schedule.description.isNotEmpty)
                    Text(
                      widget.schedule.description,
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
                          widget.schedule.place,
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
                        "${DateFormatter.formatFromString(widget.schedule.startDate)} - ${DateFormatter.formatFromString(widget.schedule.endDate)}",
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
                  if (activityProvider.loading && activities.isEmpty)
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
                                  dateStr,
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
                                      return _buildActivityTile(context, act);
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    "Tác vụ nhanh",
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _buildActionButton(
                        label: "Tải ảnh lên",
                        icon: Icons.photo_camera_outlined,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.uploadPhoto,
                            arguments: Schedule(
                              campId: widget.schedule.campId,
                              name: widget.schedule.name,
                              description: widget.schedule.description,
                              place: widget.schedule.place,
                              startDate: widget.schedule.startDate,
                              endDate: widget.schedule.endDate,
                              image: widget.schedule.image,
                              price: 0,
                              status: CampStatus.InProgress,
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        label: "Livestream",
                        icon: Icons.live_tv_rounded,
                        onTap: () {
                          onJoinLivestreamPressed(
                            context,
                            'ic99-z3ap-2yns',
                            Mode.SEND_AND_RECV,
                          );
                        },
                      ),
                      _buildActionButton(
                        label: "Báo cáo",
                        icon: Icons.report_problem_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActivityTile(BuildContext context, ActivitySchedule act) {
    bool isLive = false;
    if (act.isLivestream) {
      final now = DateTime.now();
      isLive = now.isAfter(act.startTime) && now.isBefore(act.endTime);
    }

    final bool isThisButtonLoading =
        _fetchingActivityId == act.activityScheduleId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 18, color: StaffTheme.staffAccent),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${DateFormatter.formatTime(act.startTime)} - ${DateFormatter.formatTime(act.endTime)}",
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "${act.activity?.name ?? 'N/A'} @ ${act.locationId ?? 'N/A'}",
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (act.isLivestream)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLive ? Colors.red : Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              onPressed: isLive
                  ? () => onJoinLivestreamPressed(
                      context,
                      act.liveStream!.roomId,
                      Mode.SEND_AND_RECV,
                    )
                  : null,
              child: const Icon(Icons.videocam, size: 20),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffTheme.staffPrimary.withValues(alpha: 0.1),
                foregroundColor: StaffTheme.staffPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              onPressed: _fetchingActivityId != null
                  ? null
                  : () => _showAttendanceOptions(context, act),
              child: isThisButtonLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline, size: 20),
            ),
        ],
      ),
    );
  }
}
