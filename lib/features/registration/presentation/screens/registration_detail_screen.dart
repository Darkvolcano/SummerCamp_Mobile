import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/registration_status.enum.dart';
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
import 'package:url_launcher/url_launcher.dart';

class RegistrationDetailScreen extends StatefulWidget {
  final int registrationId;

  const RegistrationDetailScreen({super.key, required this.registrationId});

  @override
  State<RegistrationDetailScreen> createState() =>
      _RegistrationDetailScreenState();
}

class _RegistrationDetailScreenState extends State<RegistrationDetailScreen> {
  Camp? _campDetails;
  bool _isLoadingPayment = false;

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

  Future<void> _handlePayment(BuildContext context, int registrationId) async {
    setState(() => _isLoadingPayment = true);

    final provider = context.read<RegistrationProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final paymentUrl = await provider.createRegistrationPaymentLink(
        registrationId,
      );
      final uri = Uri.tryParse(paymentUrl);

      if (uri == null || !(await canLaunchUrl(uri))) {
        throw Exception('Không thể mở đường dẫn thanh toán: $paymentUrl');
      }

      if (!mounted) return;
      await _showCountdownDialog();

      await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (mounted) {
        navigator.pushNamedAndRemoveUntil(
          AppRoutes.registrationList,
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPayment = false);
      }
    }
  }

  Future<void> _showCountdownDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return const _CountdownDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final registrationProvider = context.watch<RegistrationProvider>();
    final registration = registrationProvider.selectedRegistration;

    final textTheme = Theme.of(context).textTheme;
    final activityProvider = context.watch<ActivityProvider>();
    final activities = activityProvider.activities;
    final groupedActivities = groupActivitiesByDate(activities);

    final campName = _campDetails?.name ?? registration?.campName;
    final campDescription = _campDetails?.description;
    final campPlace = _campDetails?.place;
    final startDate = _campDetails?.startDate;
    final endDate = _campDetails?.endDate;

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
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                campName!,
                                style: textTheme.titleLarge?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.summerPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(registration.status),
                          ],
                        ),

                        if (campDescription != null &&
                            campDescription.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            campDescription,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 14,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.payment,
                          "Mã đăng ký: #${registration.registrationId}",
                        ),

                        const SizedBox(height: 6),

                        if (campPlace != null)
                          _buildDetailRow(Icons.location_on, campPlace),

                        const SizedBox(height: 6),

                        if (startDate != null && endDate != null)
                          _buildDetailRow(
                            Icons.calendar_month,
                            "${DateFormatter.formatFromString(startDate)} - ${DateFormatter.formatFromString(endDate)}",
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Danh sách camper tham gia",
                          style: textTheme.titleMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 20),
                        if (registration.campers.isEmpty)
                          const Text(
                            "Không có thông tin camper.",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              color: Colors.grey,
                            ),
                          )
                        else
                          ...registration.campers.map(
                            (camper) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
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
                ),

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
                  Column(
                    children: groupedActivities.entries.map((entry) {
                      final dateStr = entry.key;
                      final activitiesOfDay = entry.value;
                      activitiesOfDay.sort(
                        (a, b) => a.startTime.compareTo(b.startTime),
                      );

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
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFab(context, registration),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _buildFab(BuildContext context, Registration? registration) {
    if (registration == null) return null;

    if (registration.status == RegistrationStatus.Approved) {
      return FloatingActionButton.extended(
        onPressed: _isLoadingPayment
            ? null
            : () => _handlePayment(context, registration.registrationId),
        backgroundColor: Colors.green,
        icon: _isLoadingPayment
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Icon(Icons.payment, color: Colors.white),
        label: Text(
          _isLoadingPayment ? "Đang xử lý..." : "Thanh toán ngay",
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (registration.status == RegistrationStatus.Confirmed ||
        registration.status == RegistrationStatus.Completed) {
      return FloatingActionButton.extended(
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
      );
    }
    return null;
  }

  // Widget _buildCampInfoCard(
  //   BuildContext context,
  //   TextTheme textTheme,
  //   Registration registration,
  // ) {
  //   final campName = _campDetails?.name ?? registration.campName;
  //   final campDescription = _campDetails?.description;
  //   final campPlace = _campDetails?.place;
  //   final startDate = _campDetails?.startDate;
  //   final endDate = _campDetails?.endDate;

  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   campName,
  //                   style: textTheme.titleLarge?.copyWith(
  //                     fontFamily: "Quicksand",
  //                     fontWeight: FontWeight.bold,
  //                     color: AppTheme.summerPrimary,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               _buildStatusChip(registration.status),
  //             ],
  //           ),

  //           if (campDescription != null && campDescription.isNotEmpty) ...[
  //             const SizedBox(height: 8),
  //             Text(
  //               campDescription,
  //               style: const TextStyle(fontFamily: "Quicksand", fontSize: 14),
  //             ),
  //           ],

  //           const SizedBox(height: 8),
  //           _buildDetailRow(
  //             Icons.payment,
  //             "Mã đăng ký: #${registration.registrationId}",
  //           ),

  //           const SizedBox(height: 6),

  //           if (campPlace != null)
  //             _buildDetailRow(Icons.location_on, campPlace),

  //           const SizedBox(height: 6),

  //           if (startDate != null && endDate != null)
  //             _buildDetailRow(
  //               Icons.calendar_month,
  //               "${DateFormatter.formatFromString(startDate)} - ${DateFormatter.formatFromString(endDate)}",
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
      case RegistrationStatus.PendingCompletion:
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        text = "Chờ hoàn thành";
        break;
      case RegistrationStatus.PendingAssignGroup:
        backgroundColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade800;
        text = "Chờ phân nhóm";
        break;
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
}

class _CountdownDialog extends StatefulWidget {
  const _CountdownDialog();

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog> {
  int _seconds = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          setState(() => _seconds--);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppTheme.summerAccent),
          const SizedBox(height: 24),
          Text(
            "Đang chuyển đến trang thanh toán sau...",
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "Quicksand", fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            "$_seconds",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: AppTheme.summerAccent,
            ),
          ),
        ],
      ),
    );
  }
}
