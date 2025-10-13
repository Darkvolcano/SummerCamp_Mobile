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
// lib/features/registration/presentation/screens/registration_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/feedback_form_screen.dart';
import 'package:videosdk/videosdk.dart';

class RegistrationDetailScreen extends StatelessWidget {
  final Registration registration;

  // Dữ liệu hoạt động mẫu (bạn sẽ thay thế bằng API call sau này)
  final List<Activity> activities = [
    Activity(
      activityId: 1,
      name: "Team Building",
      description: "Trò chơi tập thể gắn kết",
      location: "Sân trung tâm",
      date: "2025-10-14",
      startTime: "08:00",
      endTime: "10:00",
      campId: 1,
      isLivestream: true,
      livestreamId: "ic99-z3ap-2yns",
    ),
    Activity(
      activityId: 2,
      name: "Lửa trại",
      description: "Giao lưu văn nghệ",
      location: "Khu trại chính",
      date: "2025-10-14",
      startTime: "19:00",
      endTime: "20:00",
      campId: 1,
      isLivestream: true,
      livestreamId: "ic99-z3ap-2yns",
    ),
    Activity(
      activityId: 3,
      name: "Bơi lội",
      description: "Học bơi cơ bản",
      location: "Hồ bơi",
      date: "2025-10-15",
      startTime: "10:00",
      endTime: "11:30",
      campId: 1,
      isLivestream: false,
    ),
  ];

  RegistrationDetailScreen({super.key, required this.registration});

  // --- CÁC HÀM LOGIC (không đổi) ---
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
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Thêm padding dưới
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
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // --- WIDGET HELPER CHO GỌN GÀNG ---

  Widget _buildCampInfoCard(BuildContext context, TextTheme textTheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              registration.campName ?? 'Chưa có tên trại',
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.calendar_today,
              "${registration.campStartDate ?? 'N/A'} - ${registration.campEndDate ?? 'N/A'}",
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
            ), // Dùng .name để lấy tên từ enum
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
            if (registration.campers.isEmpty)
              const Text(
                "Không có thông tin camper.",
                style: TextStyle(fontFamily: "Nunito", color: Colors.grey),
              )
            else
              ...registration.campers.map(
                (camper) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
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
    if (groupedActivities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Chưa có lịch trình."),
        ),
      );
    }

    return Column(
      children: groupedActivities.entries.map((entry) {
        final dateStr = entry.key;
        final activitiesOfDay = entry.value;

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
                  DateFormatter.formatFromString(dateStr),
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
          // Cột thời gian
          Column(
            children: [
              Text(
                act.startTime,
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerAccent,
                ),
              ),
              const Text("|", style: TextStyle(color: Colors.grey)),
              Text(
                act.endTime,
                style: const TextStyle(
                  fontFamily: "Nunito",
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Cột thông tin
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
                _buildDetailRow(Icons.place_outlined, act.location, size: 14),
              ],
            ),
          ),
          // Nút Livestream
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
            style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
          ),
        ),
      ],
    );
  }
}
