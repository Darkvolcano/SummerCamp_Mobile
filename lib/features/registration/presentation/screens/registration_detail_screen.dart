import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/feedback_form_screen.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:videosdk/videosdk.dart';

class RegistrationDetailScreen extends StatefulWidget {
  final int registrationId;

  const RegistrationDetailScreen({super.key, required this.registrationId});

  @override
  State<RegistrationDetailScreen> createState() =>
      _RegistrationDetailScreenState();
}

class _RegistrationDetailScreenState extends State<RegistrationDetailScreen> {
  Camp? _campDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchInitialData();
      }
    });
  }

  Future<void> _fetchInitialData() async {
    final registrationProvider = context.read<RegistrationProvider>();
    await registrationProvider.loadRegistrationDetails(widget.registrationId);

    if (!mounted || registrationProvider.selectedRegistration == null) return;

    _fetchActivities(registrationProvider.selectedRegistration!);
  }

  Future<void> _fetchActivities(Registration registration) async {
    final campProvider = context.read<CampProvider>();
    final activityProvider = context.read<ActivityProvider>();

    activityProvider.setLoading();

    if (campProvider.camps.isEmpty) {
      await campProvider.loadCamps();
    }
    if (!mounted) return;

    int? campId;
    try {
      final foundCamp = campProvider.camps.firstWhere(
        (camp) => camp.name == registration.campName,
      );
      campId = foundCamp.campId;
      if (mounted) {
        setState(() => _campDetails = foundCamp);
      }
    } catch (e) {
      activityProvider.setError("Không tìm thấy thông tin trại.");
      return;
    }
    await activityProvider.loadActivities(campId);
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

  bool isActivityLive(Activity activity) {
    final now = DateTime.now();
    return now.isAfter(activity.startTime) && now.isBefore(activity.endTime);
  }
  //   bool isActivityLive(Activity activity) {
  //     final now = DateTime.now();
  //     final activityDate = DateTime.parse(activity.date);
  //     final startTimeParts = activity.startTime.split(':');
  //     final endTimeParts = activity.endTime.split(':');
  //     final startTime = DateTime(
  //       activityDate.year,
  //       activityDate.month,
  //       activityDate.day,
  //       int.parse(startTimeParts[0]),
  //       int.parse(startTimeParts[1]),
  //     );
  //     final endTime = DateTime(
  //       activityDate.year,
  //       activityDate.month,
  //       activityDate.day,
  //       int.parse(endTimeParts[0]),
  //       int.parse(endTimeParts[1]),
  //     );
  //     return now.isAfter(startTime) && now.isBefore(endTime);
  //   }

  void joinLivestream(BuildContext context, Activity activity) {
    if (activity.roomId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ILSScreen(
          liveStreamId: activity.roomId!.toString(),
          token:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0ZWQzZTNmNC0zMjBlLTQ5ZGYtOWM3ZS1kZjViZWMxNmIxOTkiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1OTEzNTYwOSwiZXhwIjoxNzc0Njg3NjA5fQ.5m-pLjkx_fqpc4nYWeEl-Xkbt_8uIg8o2tlnjlY-irU",
          mode: Mode.RECV_ONLY,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registrationProvider = context.watch<RegistrationProvider>();
    final registration = registrationProvider.selectedRegistration;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chi tiết đăng ký",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
        builder: (context) {
          if (registrationProvider.loading && registration == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (registrationProvider.error != null) {
            return Center(child: Text("Lỗi: ${registrationProvider.error}"));
          }
          if (registration == null) {
            return const Center(
              child: Text("Không tìm thấy thông tin đăng ký."),
            );
          }
          return _buildContent(context, registration);
        },
      ),
      floatingActionButton: registration != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeedbackFormScreen(
                      registrationId: registration.registrationId,
                    ),
                  ),
                );
              },
              backgroundColor: AppTheme.summerAccent,
              icon: const Icon(Icons.feedback_outlined, color: Colors.white),
              label: const Text(
                "Gửi Feedback",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContent(BuildContext context, Registration registration) {
    final textTheme = Theme.of(context).textTheme;
    final activityProvider = context.watch<ActivityProvider>();
    final activities = activityProvider.activities;
    final groupedActivities = groupActivitiesByDate(activities);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCampInfoCard(context, textTheme, registration),
          const SizedBox(height: 16),
          _buildCamperListCard(context, textTheme, registration),
          const SizedBox(height: 24),
          Text(
            "Lịch trình hoạt động",
            style: textTheme.titleLarge?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: AppTheme.summerPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (activityProvider.loading)
            const Center(child: CircularProgressIndicator())
          else if (activityProvider.error != null)
            Center(
              child: Text(
                "Lỗi: ${activityProvider.error}",
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.red,
                ),
              ),
            )
          else if (activities.isEmpty)
            const Center(
              child: Text(
                "Chưa có lịch trình hoạt động.",
                style: TextStyle(fontFamily: "Quicksand"),
              ),
            )
          else
            _buildSchedule(context, groupedActivities),
        ],
      ),
    );
  }

  Widget _buildCampInfoCard(
    BuildContext context,
    TextTheme textTheme,
    Registration registration,
  ) {
    final campName = _campDetails?.name ?? registration.campName;
    final campDescription = _campDetails?.description;
    final campPlace = _campDetails?.place;
    final startDate = _campDetails?.startDate;
    final endDate = _campDetails?.endDate;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campName,
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            if (campDescription != null && campDescription.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                campDescription,
                style: const TextStyle(fontFamily: "Quicksand", fontSize: 14),
              ),
            ],
            const SizedBox(height: 12),
            if (campPlace != null)
              _buildDetailRow(Icons.location_on, campPlace),
            const SizedBox(height: 6),
            if (startDate != null && endDate != null)
              _buildDetailRow(
                Icons.calendar_month,
                "${DateFormatter.formatFromString(startDate)} - ${DateFormatter.formatFromString(endDate)}",
              ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.payment,
              "Mã thanh toán: #${registration.paymentId}",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.info_outline,
              "Trạng thái: ${registration.status.name}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamperListCard(
    BuildContext context,
    TextTheme textTheme,
    Registration registration,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Danh sách Camper tham gia",
              style: textTheme.titleMedium?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            if (registration.campers.isEmpty)
              const Text(
                "Không có thông tin camper.",
                style: TextStyle(fontFamily: "Quicksand", color: Colors.grey),
              )
            else
              ...registration.campers.map(
                (camper) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppTheme.summerAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        camper.camperName,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(
    BuildContext context,
    Map<String, List<Activity>> groupedActivities,
  ) {
    return Column(
      children: groupedActivities.entries.map((entry) {
        final dateStr = entry.key;
        final activitiesOfDay = entry.value;
        activitiesOfDay.sort((a, b) => a.startTime.compareTo(b.startTime));

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
                  dateStr,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.summerPrimary,
                  ),
                ),
                const Divider(),
                ...activitiesOfDay.map(
                  (act) => _buildActivityTile(context, act),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityTile(BuildContext context, Activity act) {
    final isLive = act.isLivestream && isActivityLive(act);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                DateFormatter.formatTime(act.startTime),
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerAccent,
                ),
              ),
              const Text("|", style: TextStyle(color: Colors.grey)),
              Text(
                DateFormatter.formatTime(act.endTime),
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.name,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.place_outlined, act.location, size: 14),
              ],
            ),
          ),
          if (act.isLivestream)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLive ? Colors.red : Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: isLive ? () => joinLivestream(context, act) : null,
              child: const Icon(Icons.videocam, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {double size = 16}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: size, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontFamily: "Quicksand", fontSize: 14),
          ),
        ),
      ],
    );
  }
}
