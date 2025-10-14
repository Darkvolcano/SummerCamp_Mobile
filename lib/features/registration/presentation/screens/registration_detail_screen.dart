// import 'package:flutter/material.dart';
// import 'package:summercamp/core/config/app_theme.dart';
// import 'package:summercamp/core/utils/date_formatter.dart';
// import 'package:summercamp/core/utils/price_formatter.dart';
// import 'package:summercamp/features/activity/domain/entities/activity.dart';
// import 'package:summercamp/features/registration/domain/entities/registration.dart';
// import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
// import 'package:videosdk/videosdk.dart';

// class RegistrationDetailScreen extends StatelessWidget {
//   final Registration registration;

//   final List<Activity> activities = [
//     Activity(
//       activityId: 1,
//       name: "Team Building",
//       description: "Trò chơi tập thể gắn kết",
//       location: "Sân trung tâm",
//       date: "2025-06-10",
//       startTime: "08:00",
//       endTime: "10:00",
//       campId: 1,
//       isLivestream: true,
//       livestreamId: "ic99-z3ap-2yns",
//     ),
//     Activity(
//       activityId: 2,
//       name: "Lửa trại",
//       description: "Giao lưu văn nghệ",
//       location: "Khu trại chính",
//       date: "2025-06-10",
//       startTime: "19:00",
//       endTime: "20:00",
//       campId: 1,
//       isLivestream: true,
//       livestreamId: "ic99-z3ap-2yns",
//     ),
//     Activity(
//       activityId: 3,
//       name: "Bơi lội",
//       description: "Học bơi cơ bản",
//       location: "Hồ bơi",
//       date: "2025-06-11",
//       startTime: "10:00",
//       endTime: "11:30",
//       campId: 1,
//       isLivestream: false,
//     ),
//   ];

//   RegistrationDetailScreen({super.key, required this.registration});

//   Map<String, List<Activity>> groupActivitiesByDate(List<Activity> activities) {
//     final Map<String, List<Activity>> grouped = {};
//     for (var act in activities) {
//       grouped.putIfAbsent(act.date, () => []);
//       grouped[act.date]!.add(act);
//     }
//     return grouped;
//   }

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

//   void joinLivestream(BuildContext context, Activity activity) {
//     if (activity.livestreamId == null) return;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ILSScreen(
//           liveStreamId: activity.livestreamId!,
//           token:
//               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0ZWQzZTNmNC0zMjBlLTQ5ZGYtOWM3ZS1kZjViZWMxNmIxOTkiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1OTEzNTYwOSwiZXhwIjoxNzc0Njg3NjA5fQ.5m-pLjkx_fqpc4nYWeEl-Xkbt_8uIg8o2tlnjlY-irU",
//           mode: Mode.RECV_ONLY,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final discountedPrice = registration.price - (registration.discount ?? 0);
//     final groupedActivities = groupActivitiesByDate(activities);
//     final totalDays =
//         DateTime.parse(
//           registration.campEndDate!,
//         ).difference(DateTime.parse(registration.campStartDate!)).inDays +
//         1;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Chi tiết đăng ký",
//           style: TextStyle(
//             fontFamily: "Fredoka",
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppTheme.summerPrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       registration.campName!,
//                       style: textTheme.titleLarge?.copyWith(
//                         fontFamily: "Fredoka",
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.summerPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       registration.campDescription!,
//                       style: const TextStyle(
//                         fontFamily: "Nunito",
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           size: 18,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             registration.campPlace!,
//                             style: const TextStyle(
//                               fontFamily: "Nunito",
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_month,
//                           size: 18,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "${DateFormatter.formatFromString(registration.campStartDate!)} - ${DateFormatter.formatFromString(registration.campEndDate!)}",
//                           style: const TextStyle(
//                             fontFamily: "Nunito",
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Thông tin đăng ký",
//                       style: textTheme.titleMedium?.copyWith(
//                         fontFamily: "Fredoka",
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Trạng thái:",
//                           style: TextStyle(fontFamily: "Nunito", fontSize: 14),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: registration.status == "Approved"
//                                 ? Colors.green.shade100
//                                 : Colors.orange.shade100,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             registration.status,
//                             style: TextStyle(
//                               fontFamily: "Nunito",
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: registration.status == "Approved"
//                                   ? Colors.green.shade800
//                                   : Colors.orange.shade800,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Giá:",
//                           style: TextStyle(fontFamily: "Nunito", fontSize: 14),
//                         ),
//                         Text(
//                           registration.discount != null &&
//                                   registration.discount! > 0
//                               ? PriceFormatter.format(discountedPrice)
//                               : PriceFormatter.format(registration.price),
//                           style: const TextStyle(
//                             fontFamily: "Nunito",
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (registration.discount != null &&
//                         registration.discount! > 0)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Giảm giá:",
//                             style: TextStyle(
//                               fontFamily: "Nunito",
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             "-${PriceFormatter.format(registration.discount!)}",
//                             style: const TextStyle(
//                               fontFamily: "Nunito",
//                               fontSize: 14,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Ngày đăng ký:",
//                           style: TextStyle(fontFamily: "Nunito", fontSize: 14),
//                         ),
//                         Text(
//                           DateFormatter.formatFull(
//                             registration.registrationCreateAt,
//                           ),
//                           style: const TextStyle(
//                             fontFamily: "Nunito",
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             Text(
//               "Lịch trình hoạt động",
//               style: textTheme.titleLarge?.copyWith(
//                 fontFamily: "Fredoka",
//                 fontWeight: FontWeight.bold,
//                 color: AppTheme.summerPrimary,
//               ),
//             ),

//             const SizedBox(height: 12),

//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: totalDays,
//               itemBuilder: (context, index) {
//                 final dayDate = DateTime.parse(
//                   registration.campStartDate!,
//                 ).add(Duration(days: index));
//                 final dateStr = DateFormatter.formatDate(dayDate);
//                 final activitiesOfDay =
//                     groupedActivities[dayDate.toIso8601String().substring(
//                       0,
//                       10,
//                     )] ??
//                     [];

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Ngày ${index + 1} - $dateStr",
//                           style: const TextStyle(
//                             fontFamily: "Fredoka",
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const Divider(),
//                         if (activitiesOfDay.isEmpty)
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child: Text(
//                               "Không có hoạt động",
//                               style: TextStyle(
//                                 fontFamily: "Nunito",
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           )
//                         else
//                           ...activitiesOfDay.map((act) {
//                             // final isLive =
//                             //     act.isLivestream && isActivityLive(act);
//                             final isLive = act.isLivestream;

//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 6),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: isLive
//                                       ? Colors.red.shade300
//                                       : Colors.grey.shade200,
//                                   width: isLive ? 2 : 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Column 1: Activity Info
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.access_time,
//                                               size: 16,
//                                               color: AppTheme.summerAccent,
//                                             ),
//                                             const SizedBox(width: 6),
//                                             Text(
//                                               "${act.startTime} - ${act.endTime}",
//                                               style: const TextStyle(
//                                                 fontFamily: "Nunito",
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             if (isLive) ...[
//                                               const SizedBox(width: 8),
//                                               Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                       horizontal: 8,
//                                                       vertical: 2,
//                                                     ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red,
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                 ),
//                                                 child: Row(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: [
//                                                     Container(
//                                                       width: 6,
//                                                       height: 6,
//                                                       decoration:
//                                                           const BoxDecoration(
//                                                             color: Colors.white,
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                           ),
//                                                     ),
//                                                     const SizedBox(width: 4),
//                                                     const Text(
//                                                       "LIVE",
//                                                       style: TextStyle(
//                                                         fontFamily: "Nunito",
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ],
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           act.name,
//                                           style: const TextStyle(
//                                             fontFamily: "Fredoka",
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.place,
//                                               size: 14,
//                                               color: Colors.grey.shade600,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Expanded(
//                                               child: Text(
//                                                 act.location,
//                                                 style: TextStyle(
//                                                   fontFamily: "Nunito",
//                                                   fontSize: 13,
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Column 2: Livestream Button
//                                   if (act.isLivestream) ...[
//                                     Center(
//                                       child: ElevatedButton.icon(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: isLive
//                                               ? Colors.red
//                                               : Colors.grey.shade400,
//                                           foregroundColor: Colors.white,
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 6,
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               6,
//                                             ),
//                                           ),
//                                           minimumSize: Size.zero,
//                                           tapTargetSize:
//                                               MaterialTapTargetSize.shrinkWrap,
//                                         ),
//                                         onPressed: isLive
//                                             ? () => joinLivestream(context, act)
//                                             : null,
//                                         icon: Icon(
//                                           isLive
//                                               ? Icons.videocam
//                                               : Icons.videocam_off,
//                                           size: 16,
//                                         ),
//                                         label: Text(
//                                           isLive ? "Tham gia" : "Chưa bắt đầu",
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             fontFamily: "Nunito",
//                                             fontSize: 11,
//                                             fontWeight: FontWeight.bold,
//                                             height: 1.2,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             );
//                           }),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
import 'package:videosdk/videosdk.dart';

class RegistrationDetailScreen extends StatefulWidget {
  final Registration registration;

  const RegistrationDetailScreen({super.key, required this.registration});

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
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
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
        (camp) => camp.name == widget.registration.campName,
      );
      campId = foundCamp.campId;

      if (mounted) {
        setState(() {
          _campDetails = foundCamp;
        });
      }
    } catch (e) {
      print(
        "Lỗi: Không tìm thấy trại nào có tên '${widget.registration.campName}'",
      );
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
          token: "YOUR_VIDEOSDK_TOKEN", // Thay token của bạn ở đây
          mode: Mode.RECV_ONLY,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activityProvider = context.watch<ActivityProvider>();
    final activities = activityProvider.activities;
    final groupedActivities = groupActivitiesByDate(activities);

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCampInfoCard(context, textTheme),
            const SizedBox(height: 16),
            _buildCamperListCard(context, textTheme),
            const SizedBox(height: 24),
            Text(
              "Lịch trình hoạt động",
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
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
                    fontFamily: "Nunito",
                    color: Colors.red,
                  ),
                ),
              )
            else if (activities.isEmpty)
              const Center(
                child: Text(
                  "Chưa có lịch trình hoạt động.",
                  style: TextStyle(fontFamily: "Nunito"),
                ),
              )
            else
              _buildSchedule(context, groupedActivities),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedbackFormScreen(
                registrationId: widget.registration.registrationId,
              ),
            ),
          );
        },
        backgroundColor: AppTheme.summerAccent,
        icon: const Icon(Icons.feedback_outlined, color: Colors.white),
        label: const Text(
          "Gửi Feedback",
          style: TextStyle(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCampInfoCard(BuildContext context, TextTheme textTheme) {
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
              widget.registration.campName ?? 'Chưa có tên trại',
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.calendar_today,
              "${DateFormatter.formatFromString(startDate!)} - ${DateFormatter.formatFromString(endDate!)}",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.payment,
              "Mã thanh toán: #${widget.registration.paymentId}",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.info_outline,
              "Trạng thái: ${widget.registration.status.name}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamperListCard(BuildContext context, TextTheme textTheme) {
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
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            if (widget.registration.campers.isEmpty)
              const Text(
                "Không có thông tin camper.",
                style: TextStyle(fontFamily: "Nunito", color: Colors.grey),
              )
            else
              ...widget.registration.campers.map(
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
                          fontFamily: "Nunito",
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
                    fontFamily: "Fredoka",
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
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerAccent,
                ),
              ),
              const Text("|", style: TextStyle(color: Colors.grey)),
              Text(
                DateFormatter.formatTime(act.endTime),
                style: const TextStyle(
                  fontFamily: "Nunito",
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
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.place_outlined, act.location, size: 15),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: size, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
          ),
        ),
      ],
    );
  }
}
