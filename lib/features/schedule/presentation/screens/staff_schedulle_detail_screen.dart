// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:summercamp/core/config/app_routes.dart';
// import 'package:summercamp/core/config/staff_theme.dart';
// import 'package:summercamp/core/enum/camp_status.enum.dart';
// import 'package:summercamp/core/utils/date_formatter.dart';
// import 'package:summercamp/core/widgets/custom_dialog.dart';
// import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
// import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
// import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
// import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
// import 'package:summercamp/features/livestream/domain/entities/livestream.dart';
// import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
// import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
// import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
// import 'package:videosdk/videosdk.dart';
// import 'package:summercamp/features/camper/domain/entities/camper.dart';

// class StaffScheduleDetailScreen extends StatefulWidget {
//   final Schedule schedule;
//   const StaffScheduleDetailScreen({super.key, required this.schedule});

//   @override
//   State<StaffScheduleDetailScreen> createState() =>
//       _StaffScheduleDetailScreenState();
// }

// class _StaffScheduleDetailScreenState extends State<StaffScheduleDetailScreen> {
//   int? _fetchingActivityId;

//   int? _loadingLivestreamId;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         final activityProvider = context.read<ActivityProvider>();
//         activityProvider.loadActivitySchedulesByCampId(widget.schedule.campId);

//         _preloadFaceData();
//       }
//     });
//   }

//   Future<void> _preloadFaceData() async {
//     try {
//       final attendanceProvider = context.read<AttendanceProvider>();
//       await attendanceProvider.preloadFaceData(
//         widget.schedule.campId,
//         forceReload: false,
//       );
//       print(
//         "Preload face data initiated for Camp ID: ${widget.schedule.campId}",
//       );
//     } catch (e) {
//       print("Warning: Preload face data failed: $e");
//     }
//   }

//   void onJoinLivestreamPressed(BuildContext context, String roomId, Mode mode) {
//     if (!context.mounted) return;
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ILSScreen(
//           liveStreamId: roomId,
//           token:
//               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0ZWQzZTNmNC0zMjBlLTQ5ZGYtOWM3ZS1kZjViZWMxNmIxOTkiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1OTEzNTYwOSwiZXhwIjoxNzc0Njg3NjA5fQ.5m-pLjkx_fqpc4nYWeEl-Xkbt_8uIg8o2tlnjlY-irU",
//           mode: Mode.SEND_AND_RECV,
//         ),
//       ),
//     );
//   }

//   Future<void> _handleLivestreamPress(ActivitySchedule act) async {
//     final livestreamEntity = act.liveStream;
//     if (livestreamEntity == null) return;

//     if (livestreamEntity.roomId != null &&
//         livestreamEntity.roomId!.isNotEmpty) {
//       onJoinLivestreamPressed(
//         context,
//         livestreamEntity.roomId!,
//         Mode.SEND_AND_RECV,
//       );
//       return;
//     }

//     setState(() {
//       _loadingLivestreamId = act.activityScheduleId;
//     });

//     try {
//       final String newRoomId = await createLivestream();

//       final updatedLivestream = Livestream(
//         livestreamId: livestreamEntity.livestreamId,
//         roomId: newRoomId,
//       );

//       if (!mounted) return;
//       await context.read<LivestreamProvider>().updateLivestreamRoomId(
//         updatedLivestream,
//       );

//       if (mounted) {
//         context.read<ActivityProvider>().loadActivitySchedulesByCampId(
//           widget.schedule.campId,
//         );
//       }

//       if (!mounted) return;
//       onJoinLivestreamPressed(context, newRoomId, Mode.SEND_AND_RECV);
//     } catch (e) {
//       if (mounted) {
//         showCustomDialog(
//           context,
//           title: "Lỗi",
//           message: "Không thể tạo phòng Livestream: $e",
//           type: DialogType.error,
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _loadingLivestreamId = null;
//         });
//       }
//     }
//   }

//   void _showAttendanceOptions(
//     BuildContext context,
//     ActivitySchedule activity,
//   ) async {
//     final camperProvider = context.read<CamperProvider>();
//     final navigator = Navigator.of(context);

//     setState(() => _fetchingActivityId = activity.activityScheduleId);

//     try {
//       List<Camper> campersToShow = [];

//       if (activity.activity?.activityType == "Core" ||
//           activity.activity?.activityType == "Checkin" ||
//           activity.activity?.activityType == "Checkout" ||
//           activity.activity?.activityType == "Resting") {
//         await camperProvider.loadCampersByCoreActivityId(
//           activity.activityScheduleId,
//         );
//         campersToShow = camperProvider.campersCoreActivity;
//       } else if (activity.activity?.activityType == "Optional") {
//         await camperProvider.loadCampersByOptionalActivityId(
//           activity.activityScheduleId,
//         );
//         campersToShow = camperProvider.campersOptionalActivity;
//       } else {
//         throw Exception(
//           "Loại hoạt động không xác định: ${activity.activity?.activityType}",
//         );
//       }

//       if (!mounted) return;

//       showModalBottomSheet(
//         context: this.context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Chọn phương thức điểm danh",
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontFamily: "Quicksand",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.list_alt_rounded,
//                     color: StaffTheme.staffPrimary,
//                   ),
//                   title: const Text(
//                     "Điểm danh thủ công",
//                     style: TextStyle(fontFamily: "Quicksand"),
//                   ),
//                   onTap: () {
//                     navigator.pop();
//                     navigator.pushNamed(
//                       AppRoutes.attendance,
//                       arguments: {
//                         "schedule": widget.schedule,
//                         "campers": campersToShow,
//                       },
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.face_retouching_natural,
//                     color: StaffTheme.staffPrimary,
//                   ),
//                   title: const Text(
//                     "Điểm danh bằng khuôn mặt",
//                     style: TextStyle(fontFamily: "Quicksand"),
//                   ),
//                   onTap: () {
//                     navigator.pop();
//                     navigator.pushNamed(
//                       AppRoutes.faceRecognitionAttendance,
//                       arguments: {
//                         "campers": campersToShow,
//                         "activityScheduleId": activity.activityScheduleId,
//                         "campId": widget.schedule.campId,
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         showCustomDialog(
//           // ignore: use_build_context_synchronously
//           context,
//           title: "Lỗi",
//           message: "Lỗi tải danh sách camper: ${e.toString()}",
//           type: DialogType.error,
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _fetchingActivityId = null);
//       }
//     }
//   }

//   Widget _buildActionButton({
//     required String label,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       shadowColor: Colors.grey.withValues(alpha: 0.1),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: StaffTheme.staffPrimary, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontFamily: "Quicksand",
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Map<String, List<ActivitySchedule>> groupActivitiesByDate(
//     List<ActivitySchedule> activities,
//   ) {
//     final Map<String, List<ActivitySchedule>> grouped = {};
//     for (var act in activities) {
//       String dateKey = DateFormatter.formatDate(act.startTime);
//       grouped.putIfAbsent(dateKey, () => []);
//       grouped[dateKey]!.add(act);
//     }
//     return grouped;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final activityProvider = context.watch<ActivityProvider>();
//     final activities = activityProvider.activitySchedules;
//     final groupedActivities = groupActivitiesByDate(activities);

//     final startDate = DateTime.parse(widget.schedule.startDate);
//     final endDate = DateTime.parse(widget.schedule.endDate);
//     final totalDays = endDate.difference(startDate).inDays + 1;

//     final isLoading = activityProvider.loading;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.schedule.name,
//           style: const TextStyle(
//             fontFamily: "Quicksand",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: StaffTheme.staffPrimary,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: isLoading && activities.isEmpty
//           ? const Center(
//               child: CircularProgressIndicator(color: StaffTheme.staffPrimary),
//             )
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (widget.schedule.image.isNotEmpty)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.network(
//                         widget.schedule.image,
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 180,
//                           color: Colors.grey.shade300,
//                           child: const Center(
//                             child: Icon(Icons.image_not_supported),
//                           ),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 16),
//                   Text(
//                     widget.schedule.name,
//                     style: textTheme.titleLarge?.copyWith(
//                       fontFamily: "Quicksand",
//                       fontWeight: FontWeight.bold,
//                       color: StaffTheme.staffPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   if (widget.schedule.description.isNotEmpty)
//                     Text(
//                       widget.schedule.description,
//                       style: const TextStyle(
//                         fontFamily: "Quicksand",
//                         fontSize: 14,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const Icon(Icons.place, size: 18, color: Colors.grey),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           widget.schedule.place,
//                           style: const TextStyle(
//                             fontFamily: "Quicksand",
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.date_range,
//                         size: 18,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "${DateFormatter.formatFromString(widget.schedule.startDate)} - ${DateFormatter.formatFromString(widget.schedule.endDate)}",
//                         style: const TextStyle(
//                           fontFamily: "Quicksand",
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Hoạt động",
//                     style: textTheme.titleLarge?.copyWith(
//                       fontFamily: "Quicksand",
//                       fontWeight: FontWeight.bold,
//                       color: StaffTheme.staffPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   if (activityProvider.loading && activities.isEmpty)
//                     const Center(child: CircularProgressIndicator())
//                   else if (activities.isEmpty)
//                     const Center(
//                       child: Text(
//                         "Chưa có hoạt động nào cho trại này.",
//                         style: TextStyle(fontFamily: "Quicksand"),
//                       ),
//                     )
//                   else
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: totalDays,
//                       itemBuilder: (context, index) {
//                         final dayDate = startDate.add(Duration(days: index));
//                         final dateStr = DateFormatter.formatDate(dayDate);
//                         final activitiesOfDay =
//                             groupedActivities[dateStr] ?? [];

//                         activitiesOfDay.sort(
//                           (a, b) => a.startTime.compareTo(b.startTime),
//                         );

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 4,
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.calendar_month,
//                                     color: StaffTheme.staffPrimary,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     dateStr,
//                                     style: const TextStyle(
//                                       fontFamily: "Quicksand",
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             if (activitiesOfDay.isEmpty)
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: Colors.grey.shade200,
//                                   ),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     "Không có hoạt động nào",
//                                     style: TextStyle(
//                                       fontFamily: "Quicksand",
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             else
//                               Column(
//                                 children: activitiesOfDay.map((act) {
//                                   return _buildActivityTile(context, act);
//                                 }).toList(),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Tác vụ nhanh",
//                     style: textTheme.titleLarge?.copyWith(
//                       fontFamily: "Quicksand",
//                       fontWeight: FontWeight.bold,
//                       color: StaffTheme.staffPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 3,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     childAspectRatio: 1,
//                     children: [
//                       _buildActionButton(
//                         label: "Tải ảnh lên",
//                         icon: Icons.photo_camera_outlined,
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             AppRoutes.uploadPhoto,
//                             arguments: Schedule(
//                               campId: widget.schedule.campId,
//                               name: widget.schedule.name,
//                               description: widget.schedule.description,
//                               place: widget.schedule.place,
//                               startDate: widget.schedule.startDate,
//                               endDate: widget.schedule.endDate,
//                               image: widget.schedule.image,
//                               price: 0,
//                               status: CampStatus.InProgress,
//                             ),
//                           );
//                         },
//                       ),
//                       _buildActionButton(
//                         label: "Livestream",
//                         icon: Icons.live_tv_rounded,
//                         onTap: () {
//                           onJoinLivestreamPressed(
//                             context,
//                             'ic99-z3ap-2yns',
//                             Mode.SEND_AND_RECV,
//                           );
//                         },
//                       ),
//                       _buildActionButton(
//                         label: "Báo cáo",
//                         icon: Icons.report_problem_outlined,
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildActivityTile(BuildContext context, ActivitySchedule act) {
//     bool isLive = false;
//     final now = DateTime.now();

//     bool isHappening = now.isAfter(act.startTime) && now.isBefore(act.endTime);

//     if (act.isLivestream) {
//       isLive = isHappening;
//     }

//     final bool isAttendanceLoading =
//         _fetchingActivityId == act.activityScheduleId;

//     final bool isLivestreamLoading =
//         _loadingLivestreamId == act.activityScheduleId;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: isHappening
//               ? StaffTheme.staffPrimary.withValues(alpha: 0.5)
//               : Colors.transparent,
//           width: 1.5,
//         ),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       DateFormatter.formatTime(act.startTime),
//                       style: const TextStyle(
//                         fontFamily: "Quicksand",
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       height: 20,
//                       width: 2,
//                       color: Colors.grey.shade300,
//                     ),
//                     Text(
//                       DateFormatter.formatTime(act.endTime),
//                       style: const TextStyle(
//                         fontFamily: "Quicksand",
//                         fontSize: 13,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 16),

//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               act.activity?.name ?? 'Hoạt động',
//                               style: const TextStyle(
//                                 fontFamily: "Quicksand",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           if (isLive)
//                             Container(
//                               margin: const EdgeInsets.only(left: 8),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: const Text(
//                                 "LIVE",
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 14,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               act.location?.name ?? '',
//                               style: TextStyle(
//                                 fontFamily: "Quicksand",
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Divider(height: 1, color: Colors.grey.shade100),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _fetchingActivityId != null
//                         ? null
//                         : () => _showAttendanceOptions(context, act),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: StaffTheme.staffPrimary,
//                       side: const BorderSide(color: StaffTheme.staffPrimary),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     icon: isAttendanceLoading
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.fact_check_outlined, size: 18),
//                     label: const Text(
//                       "Điểm danh",
//                       style: TextStyle(
//                         fontFamily: "Quicksand",
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 if (act.isLivestream) ...[
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: (isLive && !isLivestreamLoading)
//                           ? () => _handleLivestreamPress(act)
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isLive
//                             ? Colors.red
//                             : Colors.grey.shade300,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       icon: isLivestreamLoading
//                           ? const SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(Icons.videocam_outlined, size: 18),
//                       label: Text(
//                         isLive ? "Vào Live" : "Chưa Live",
//                         style: const TextStyle(
//                           fontFamily: "Quicksand",
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/livestream/domain/entities/livestream.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:summercamp/features/report/presentation/screens/report_form_screen.dart';
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

class _StaffScheduleDetailScreenState extends State<StaffScheduleDetailScreen>
    with SingleTickerProviderStateMixin {
  int? _fetchingActivityId;
  int? _loadingLivestreamId;
  late TabController _tabController;
  int _totalDays = 0;
  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _startDate = DateTime.parse(widget.schedule.startDate);
    final endDate = DateTime.parse(widget.schedule.endDate);
    _totalDays = endDate.difference(_startDate).inDays + 1;
    _tabController = TabController(length: _totalDays, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final activityProvider = context.read<ActivityProvider>();
        activityProvider.loadActivitySchedulesByCampId(widget.schedule.campId);
        _preloadFaceData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _preloadFaceData() async {
    try {
      final attendanceProvider = context.read<AttendanceProvider>();
      await attendanceProvider.preloadFaceData(
        widget.schedule.campId,
        forceReload: false,
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
          token: dotenv.env['VIDEO_SDK_TOKEN'] ?? '',
          mode: mode,
        ),
      ),
    );
  }

  Future<void> _handleLivestreamPress(ActivitySchedule act) async {
    final livestreamEntity = act.liveStream;
    if (livestreamEntity == null) return;

    if (livestreamEntity.roomId != null &&
        livestreamEntity.roomId!.isNotEmpty) {
      onJoinLivestreamPressed(
        context,
        livestreamEntity.roomId!,
        Mode.SEND_AND_RECV,
      );
      return;
    }

    setState(() {
      _loadingLivestreamId = act.activityScheduleId;
    });

    try {
      final String newRoomId = await createLivestream();

      final updatedLivestream = Livestream(
        livestreamId: livestreamEntity.livestreamId,
        roomId: newRoomId,
      );

      if (!mounted) return;
      await context.read<LivestreamProvider>().updateLivestreamRoomId(
        updatedLivestream,
      );

      if (mounted) {
        context.read<ActivityProvider>().loadActivitySchedulesByCampId(
          widget.schedule.campId,
        );
      }

      if (!mounted) return;
      onJoinLivestreamPressed(context, newRoomId, Mode.SEND_AND_RECV);
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context,
          title: "Lỗi",
          message: "Không thể tạo phòng Livestream: $e",
          type: DialogType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingLivestreamId = null;
        });
      }
    }
  }

  void _showAttendanceOptions(
    BuildContext context,
    ActivitySchedule activity,
  ) async {
    final camperProvider = context.read<CamperProvider>();
    final navigator = Navigator.of(context);

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
      if (mounted) {
        showCustomDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Lỗi",
          message: "Lỗi tải danh sách camper: ${e.toString()}",
          type: DialogType.error,
        );
      }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReportCreateScreen(campId: widget.schedule.campId),
            ),
          );
        },
        backgroundColor: StaffTheme.staffAccent,
        icon: const Icon(Icons.assignment_add, color: Colors.white),
        label: const Text(
          "Sự cố",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading && activities.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: StaffTheme.staffPrimary),
            )
          : Column(
              children: [
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
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
                                          child: Icon(
                                            Icons.image_not_supported,
                                          ),
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
                                    const Icon(
                                      Icons.place,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
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
                                  "Tác vụ khác",
                                  style: textTheme.titleLarge?.copyWith(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    color: StaffTheme.staffPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.1,
                                  children: [
                                    _buildActionButton(
                                      label: "Tải ảnh lên",
                                      icon: Icons.photo_camera_outlined,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.uploadPhoto,
                                          arguments: widget.schedule,
                                        );
                                      },
                                    ),
                                    // _buildActionButton(
                                    //   label: "Livestream",
                                    //   icon: Icons.live_tv_rounded,
                                    //   onTap: () {
                                    //     onJoinLivestreamPressed(
                                    //       context,
                                    //       'ic99-z3ap-2yns',
                                    //       Mode.SEND_AND_RECV,
                                    //     );
                                    //   },
                                    // ),
                                    // _buildActionButton(
                                    //   label: "Báo cáo",
                                    //   icon: Icons.report_problem_outlined,
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                Text(
                                  "Lịch trình hoạt động",
                                  style: textTheme.titleLarge?.copyWith(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    color: StaffTheme.staffPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TabBar(
                                  controller: _tabController,
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  labelColor: StaffTheme.staffPrimary,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: StaffTheme.staffAccent,
                                  indicatorWeight: 3,
                                  labelStyle: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  tabs: List.generate(_totalDays, (index) {
                                    final date = _startDate.add(
                                      Duration(days: index),
                                    );
                                    return Tab(
                                      text:
                                          // "Ngày ${index + 1} (${date.day}/${date.month})",
                                          "${date.day}/${date.month}/${date.year}",
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: List.generate(_totalDays, (index) {
                        final date = _startDate.add(Duration(days: index));
                        final dateStr = DateFormatter.formatDate(date);
                        final activitiesOfDay =
                            groupedActivities[dateStr] ?? [];

                        activitiesOfDay.sort(
                          (a, b) => a.startTime.compareTo(b.startTime),
                        );

                        if (activitiesOfDay.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 50,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Không có hoạt động",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: activitiesOfDay.length,
                          itemBuilder: (context, i) {
                            return _buildActivityTile(
                              context,
                              activitiesOfDay[i],
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildActivityTile(BuildContext context, ActivitySchedule act) {
    bool isLive = false;
    final now = DateTime.now();
    bool isHappening = now.isAfter(act.startTime) && now.isBefore(act.endTime);

    if (act.isLivestream) {
      isLive = isHappening;
    }

    final bool isAttendanceLoading =
        _fetchingActivityId == act.activityScheduleId;
    final bool isLivestreamLoading =
        _loadingLivestreamId == act.activityScheduleId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isHappening
              ? StaffTheme.staffPrimary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      DateFormatter.formatTime(act.startTime),
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      height: 20,
                      width: 2,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      DateFormatter.formatTime(act.endTime),
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              act.activity?.name ?? 'Hoạt động',
                              style: const TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (isLive)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "LIVE",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              act.location?.name ?? 'Chưa cập nhật',
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _fetchingActivityId != null
                        ? null
                        : () => _showAttendanceOptions(context, act),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: StaffTheme.staffPrimary,
                      side: const BorderSide(color: StaffTheme.staffPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: isAttendanceLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.fact_check_outlined, size: 18),
                    label: const Text(
                      "Điểm danh",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                if (act.isLivestream) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (isLive && !isLivestreamLoading)
                          ? () => _handleLivestreamPress(act)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLive
                            ? Colors.red
                            : Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: isLivestreamLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.videocam_outlined, size: 18),
                      label: Text(
                        isLive ? "Vào Live" : "Chưa Live",
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
