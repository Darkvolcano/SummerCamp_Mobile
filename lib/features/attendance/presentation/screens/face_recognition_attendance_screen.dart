// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';
// import 'package:summercamp/core/config/staff_theme.dart';
// import 'package:summercamp/core/widgets/custom_dialog.dart';
// import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
// import 'package:summercamp/features/camper/domain/entities/camper.dart';
// import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

// class FaceAttendanceScreen extends StatefulWidget {
//   final List<Camper> campers;
//   final int activityScheduleId;
//   final int campId;

//   const FaceAttendanceScreen({
//     super.key,
//     required this.campers,
//     required this.activityScheduleId,
//     required this.campId,
//   });

//   @override
//   State<FaceAttendanceScreen> createState() => _FaceAttendanceScreenState();
// }

// class _FaceAttendanceScreenState extends State<FaceAttendanceScreen> {
//   CameraController? _controller;
//   bool _isCameraInitialized = false;
//   bool _isProcessing = false;

//   File? _capturedImage;

//   final List<Map<String, dynamic>> _attendanceList = [];
//   bool _isDataReady = false;
//   int _currentGroupId = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadGroupData();
//     });
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         _showErrorDialog('Không tìm thấy camera trên thiết bị');
//         return;
//       }

//       final firstCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );

//       _controller = CameraController(
//         firstCamera,
//         ResolutionPreset.low,
//         enableAudio: false,
//         imageFormatGroup: Platform.isAndroid
//             ? ImageFormatGroup.jpeg
//             : ImageFormatGroup.bgra8888,
//       );

//       await _controller!.initialize();

//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = true;
//         });
//       }
//     } catch (e) {
//       _showErrorDialog('Lỗi khởi tạo camera: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   Future<void> _loadGroupData() async {
//     setState(() => _isDataReady = false);

//     try {
//       final camperProvider = context.read<CamperProvider>();
//       await camperProvider.loadStaffCampGroup(widget.campId);

//       if (camperProvider.group != null) {
//         _currentGroupId = camperProvider.group!.groupId;
//         if (mounted) {
//           setState(() => _isDataReady = true);
//         }
//       } else {
//         _showErrorDialog("Không tìm thấy nhóm điểm danh cho trại này.");
//       }
//     } catch (e) {
//       _showErrorDialog("Lỗi kết nối khi tải thông tin nhóm");
//     }
//   }

//   Future<void> _takePictureAndRecognize() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;
//     if (_isProcessing) return;

//     if (_currentGroupId == 0) {
//       _showErrorDialog("Chưa có thông tin Nhóm. Vui lòng thử lại.");
//       _loadGroupData();
//       return;
//     }

//     try {
//       setState(() => _isProcessing = true);

//       final XFile image = await _controller!.takePicture();
//       final File imageFile = File(image.path);

//       setState(() {
//         _capturedImage = imageFile;
//       });

//       await _processFaceRecognition(imageFile);
//     } catch (e) {
//       setState(() {
//         _isProcessing = false;
//         _capturedImage = null;
//       });
//       _showErrorDialog('Lỗi chụp ảnh: $e');
//     }
//   }

//   // Future<void> _processFaceRecognition(File imageFile) async {
//   //   final attendanceProvider = context.read<AttendanceProvider>();

//   //   try {
//   //     final result = await attendanceProvider.recognizeFace(
//   //       activityScheduleId: widget.activityScheduleId,
//   //       photo: imageFile,
//   //       campId: widget.campId,
//   //       groupId: _currentGroupId,
//   //     );

//   //     final bool success = result['success'] ?? false;
//   //     final List<dynamic> recognizedCampers = result['recognizedCampers'] ?? [];

//   //     if (!success || recognizedCampers.isEmpty) {
//   //       setState(() => _isProcessing = false);
//   //       _showNoMatchDialog();
//   //       return;
//   //     }

//   //     final match = recognizedCampers.first;
//   //     final now = DateTime.now();
//   //     final timeStr =
//   //         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

//   //     final displayResult = {
//   //       'camperId': match['camperId'],
//   //       'name': match['camperName'] ?? 'Unknown',
//   //       'avatar': _findAvatar(match['camperId']),
//   //       'confidence': (match['confidence'] ?? 0.0) * 100,
//   //       'status': 'Có mặt',
//   //       'time': timeStr,
//   //     };

//   //     setState(() {
//   //       _isProcessing = false;
//   //       _attendanceList.add(displayResult);
//   //     });

//   //     _showRecognitionResultDialog(displayResult);
//   //   } catch (e) {
//   //     setState(() => _isProcessing = false);
//   //     _showErrorDialog('Lỗi nhận diện: ${e.toString()}');
//   //   }
//   // }
//   Future<void> _processFaceRecognition(File imageFile) async {
//     final attendanceProvider = context.read<AttendanceProvider>();

//     try {
//       final result = await attendanceProvider.recognizeGroup(
//         activityScheduleId: widget.activityScheduleId,
//         photo: imageFile,
//         campId: widget.campId,
//         groupId: _currentGroupId,
//       );

//       final bool success = result['success'] ?? false;
//       final List<dynamic> recognizedCampers = result['recognizedCampers'] ?? [];

//       if (!success || recognizedCampers.isEmpty) {
//         setState(() => _isProcessing = false);
//         _showNoMatchDialog();
//         return;
//       }

//       final now = DateTime.now();
//       final timeStr =
//           '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

//       List<Map<String, dynamic>> newMatches = [];

//       // for (var match in recognizedCampers) {
//       //   final displayResult = {
//       //     'camperId': match['camperId'],
//       //     'name': match['camperName'] ?? 'Unknown',
//       //     'avatar': _findAvatar(match['camperId']),
//       //     'confidence': (match['confidence'] ?? 0.0) * 100,
//       //     'status': 'Có mặt',
//       //     'time': timeStr,
//       //   };
//       //   newMatches.add(displayResult);
//       // }
//       for (var match in recognizedCampers) {
//         final int matchedId = match['camperId'];

//         String displayName = 'Unknown';
//         String? displayAvatar;

//         try {
//           final localCamper = widget.campers.firstWhere(
//             (c) => c.camperId == matchedId,
//           );

//           displayName = localCamper.camperName;
//           displayAvatar = localCamper.avatar;
//         } catch (e) {
//           displayName = 'Unknown (ID: $matchedId)';
//         }

//         final displayResult = {
//           'camperId': matchedId,
//           'name': displayName,
//           'avatar': displayAvatar,
//           'confidence': (match['confidence'] ?? 0.0) * 100,
//           'status': 'Có mặt',
//           'time': timeStr,
//         };
//         newMatches.add(displayResult);
//       }

//       setState(() {
//         _isProcessing = false;
//         _attendanceList.insertAll(0, newMatches);
//       });

//       _showRecognitionResultDialog(newMatches);
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       String errorMessage = e.toString();

//       try {
//         errorMessage = (e as dynamic).message;
//       } catch (_) {
//         errorMessage = errorMessage
//             .replaceAll("Instance of 'NetworkException'", "")
//             .trim();
//       }

//       if (errorMessage.isEmpty || errorMessage == "null") {
//         errorMessage = "Lỗi kết nối hoặc server không phản hồi.";
//       }

//       _showErrorDialog(errorMessage);
//     } finally {
//       setState(() {
//         _isProcessing = false;
//         _capturedImage = null;
//       });
//     }
//   }

//   // String? _findAvatar(int camperId) {
//   //   try {
//   //     final camper = widget.campers.firstWhere((c) => c.camperId == camperId);
//   //     return camper.avatar;
//   //   } catch (e) {
//   //     return null;
//   //   }
//   // }

//   void _showErrorDialog(String message) {
//     if (mounted) {
//       showCustomDialog(
//         context,
//         title: "Đã xảy ra lỗi",
//         message: message,
//         type: DialogType.error,
//         btnText: "Đóng",
//       );
//     }
//   }

//   void _showNoMatchDialog() {
//     if (mounted) {
//       showCustomDialog(
//         context,
//         title: "Không tìm thấy",
//         message: "Không tìm thấy camper tham gia trại",
//         type: DialogType.warning,
//         btnText: "Thử lại",
//       );
//     }
//   }

//   // void _showRecognitionResultDialog(Map<String, dynamic> result) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Row(
//   //         children: [
//   //           const Icon(Icons.check_circle, color: Colors.green, size: 32),
//   //           const SizedBox(width: 12),
//   //           const Text(
//   //             'Nhận diện thành công',
//   //             style: TextStyle(fontFamily: "Quicksand", fontSize: 18),
//   //           ),
//   //         ],
//   //       ),
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           if (result['avatar'] != null)
//   //             ClipOval(
//   //               child: Image.network(
//   //                 result['avatar'],
//   //                 width: 80,
//   //                 height: 80,
//   //                 fit: BoxFit.cover,
//   //               ),
//   //             ),
//   //           const SizedBox(height: 16),
//   //           Text(
//   //             result['name'],
//   //             style: const TextStyle(
//   //               fontFamily: "Quicksand",
//   //               fontSize: 18,
//   //               fontWeight: FontWeight.bold,
//   //             ),
//   //             textAlign: TextAlign.center,
//   //           ),
//   //           const SizedBox(height: 12),
//   //           Text(
//   //             'Độ chính xác: ${result['confidence'].toStringAsFixed(1)}%',
//   //             style: const TextStyle(
//   //               fontFamily: "Quicksand",
//   //               fontWeight: FontWeight.bold,
//   //               color: Colors.green,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text(
//   //             'Tiếp tục quét',
//   //             style: TextStyle(fontFamily: "Quicksand"),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   void _showRecognitionResultDialog(List<Map<String, dynamic>> results) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.green, size: 32),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Đã nhận diện ${results.length} người',
//                 style: const TextStyle(fontFamily: "Quicksand", fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//         content: SizedBox(
//           width: double.maxFinite,
//           height: results.length > 1 ? 300 : null,
//           child: results.length == 1
//               ? _buildSingleResult(results.first)
//               : ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: results.length,
//                   separatorBuilder: (ctx, i) => const Divider(),
//                   itemBuilder: (ctx, index) {
//                     final item = results[index];
//                     return ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       leading: CircleAvatar(
//                         backgroundImage: item['avatar'] != null
//                             ? NetworkImage(item['avatar'])
//                             : null,
//                         child: item['avatar'] == null
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                       title: Text(
//                         item['name'],
//                         style: const TextStyle(
//                           fontFamily: "Quicksand",
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${item['confidence'].toStringAsFixed(1)}%',
//                         style: const TextStyle(color: Colors.green),
//                       ),
//                       trailing: const Icon(Icons.check, color: Colors.green),
//                     );
//                   },
//                 ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Tiếp tục quét',
//               style: TextStyle(fontFamily: "Quicksand"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSingleResult(Map<String, dynamic> result) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (result['avatar'] != null)
//           ClipOval(
//             child: Image.network(
//               result['avatar'],
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//         const SizedBox(height: 16),
//         Text(
//           result['name'],
//           style: const TextStyle(
//             fontFamily: "Quicksand",
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 12),
//         Text(
//           'Độ chính xác: ${result['confidence'].toStringAsFixed(1)}%',
//           style: const TextStyle(
//             fontFamily: "Quicksand",
//             fontWeight: FontWeight.bold,
//             color: Colors.green,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Điểm danh khuôn mặt',
//           style: TextStyle(
//             fontFamily: "Quicksand",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: StaffTheme.staffPrimary,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: StaffTheme.staffPrimary, width: 2),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(14),
//                 child: _isCameraInitialized
//                     ? AspectRatio(
//                         aspectRatio: 1 / _controller!.value.aspectRatio,
//                         // child: CameraPreview(_controller!),
//                         child: _capturedImage != null
//                             ? Image.file(_capturedImage!, fit: BoxFit.cover)
//                             : CameraPreview(_controller!),
//                       )
//                     : const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       ),
//               ),
//             ),
//           ),

//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.purple.shade50,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.purple.shade200),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.people, color: Colors.purple.shade700),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Có ${widget.campers.length} campers trong danh sách',
//                     style: TextStyle(
//                       fontFamily: "Quicksand",
//                       fontSize: 13,
//                       color: Colors.purple.shade900,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton.icon(
//                 onPressed:
//                     (_isProcessing || !_isDataReady || !_isCameraInitialized)
//                     ? null
//                     : _takePictureAndRecognize,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: StaffTheme.staffAccent,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   disabledBackgroundColor: Colors.grey,
//                 ),
//                 icon: _isProcessing
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Icon(Icons.camera_alt, size: 28),
//                 label: Text(
//                   _isProcessing
//                       ? ' Đang xử lý...'
//                       : (!_isDataReady
//                             ? ' Đang tải thông tin...'
//                             : ' Chụp & Quét'),
//                   style: const TextStyle(
//                     fontFamily: "Quicksand",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           Expanded(
//             flex: 2,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade300,
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: _attendanceList.isEmpty
//                   ? Center(
//                       child: Text(
//                         'Chưa có ai điểm danh',
//                         style: TextStyle(
//                           fontFamily: "Quicksand",
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: _attendanceList.length,
//                       itemBuilder: (context, index) {
//                         final item = _attendanceList[index];
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: item['avatar'] != null
//                                 ? NetworkImage(item['avatar'])
//                                 : null,
//                             backgroundColor: Colors.green.shade100,
//                             child: item['avatar'] == null
//                                 ? const Icon(Icons.person, color: Colors.green)
//                                 : null,
//                           ),
//                           title: Text(
//                             item['name'],
//                             style: const TextStyle(
//                               fontFamily: "Quicksand",
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             "Độ chính xác: ${item['confidence'].toStringAsFixed(1)}%",
//                             style: const TextStyle(
//                               fontFamily: "Quicksand",
//                               fontSize: 12,
//                             ),
//                           ),
//                           trailing: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green,
//                                 size: 20,
//                               ),
//                               Text(
//                                 item['time'],
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

enum AttendanceStatus { absent, present, notYet }

class FaceAttendanceScreen extends StatefulWidget {
  final List<Camper> campers;
  final int activityScheduleId;
  final int campId;

  const FaceAttendanceScreen({
    super.key,
    required this.campers,
    required this.activityScheduleId,
    required this.campId,
  });

  @override
  State<FaceAttendanceScreen> createState() => _FaceAttendanceScreenState();
}

class _FaceAttendanceScreenState extends State<FaceAttendanceScreen> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  bool isCameraInitialized = false;
  bool isCameraVisible = false;
  bool isProcessing = false;
  File? _capturedImage;
  bool _isDataReady = false;
  int _currentGroupId = 0;

  final Map<int, AttendanceStatus> attendance = {};
  final Map<int, int> logIds = {};

  @override
  void initState() {
    super.initState();
    _setupCameras();
    _initializeAttendanceData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupData();
    });
  }

  void _initializeAttendanceData() {
    for (var camper in widget.campers) {
      if (camper.attendanceLogId != null) {
        logIds[camper.camperId] = camper.attendanceLogId!;
      }

      if (camper.status == "Present") {
        attendance[camper.camperId] = AttendanceStatus.present;
      } else if (camper.status == "Absent") {
        attendance[camper.camperId] = AttendanceStatus.absent;
      } else {
        attendance[camper.camperId] = AttendanceStatus.notYet;
      }
    }
  }

  Future<void> _setupCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showErrorDialog('Không tìm thấy camera trên thiết bị');
      } else {
        int index = cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
        );
        if (index != -1) {
          selectedCameraIndex = index;
        }
      }
    } catch (e) {
      _showErrorDialog('Lỗi tìm thiết bị camera: $e');
    }
  }

  Future<void> _initCamera(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.jpeg
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Lỗi khởi tạo camera: $e');
    }
  }

  void _toggleCamera() {
    if (cameras.isEmpty) {
      _showErrorDialog("Không tìm thấy camera nào.");
      return;
    }

    setState(() {
      isCameraVisible = !isCameraVisible;
      _capturedImage = null;
    });

    if (isCameraVisible) {
      _initCamera(cameras[selectedCameraIndex]);
    } else {
      isCameraInitialized = false;
      _controller?.dispose();
      _controller = null;
    }
  }

  void _switchCamera() {
    if (cameras.length < 2) {
      _showErrorDialog("Chỉ tìm thấy 1 camera trên thiết bị này.");
      return;
    }

    setState(() {
      isCameraInitialized = false;
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    });

    _initCamera(cameras[selectedCameraIndex]);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadGroupData() async {
    setState(() => _isDataReady = false);
    try {
      final camperProvider = context.read<CamperProvider>();
      await camperProvider.loadStaffCampGroup(widget.campId);

      if (camperProvider.group != null) {
        _currentGroupId = camperProvider.group!.groupId;
        if (mounted) {
          setState(() => _isDataReady = true);
        }
      } else {
        _showErrorDialog("Không tìm thấy nhóm điểm danh cho trại này.");
      }
    } catch (e) {
      _showErrorDialog("Lỗi kết nối khi tải thông tin nhóm");
    }
  }

  Future<void> _takePictureAndRecognize() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (isProcessing) return;

    if (_currentGroupId == 0) {
      _showErrorDialog("Chưa có thông tin Nhóm. Vui lòng thử lại.");
      _loadGroupData();
      return;
    }

    try {
      setState(() => isProcessing = true);

      final XFile image = await _controller!.takePicture();
      final File imageFile = File(image.path);

      setState(() {
        _capturedImage = imageFile;
      });

      await _processFaceRecognition(imageFile);
    } catch (e) {
      setState(() {
        isProcessing = false;
        _capturedImage = null;
      });
      _showErrorDialog('Lỗi chụp ảnh: $e');
    }
  }

  Future<void> _processFaceRecognition(File imageFile) async {
    final attendanceProvider = context.read<AttendanceProvider>();

    try {
      final result = await attendanceProvider.recognizeGroup(
        activityScheduleId: widget.activityScheduleId,
        photo: imageFile,
        campId: widget.campId,
        groupId: _currentGroupId,
      );

      final bool success = result['success'] ?? false;
      final List<dynamic> recognizedCampers = result['recognizedCampers'] ?? [];

      if (!success || recognizedCampers.isEmpty) {
        _showNoMatchDialog();
        return;
      }

      List<Map<String, dynamic>> recognizedListForDialog = [];

      for (var match in recognizedCampers) {
        final int matchedId = match['camperId'];

        if (attendance.containsKey(matchedId)) {
          attendance[matchedId] = AttendanceStatus.present;
        }

        String displayName = 'Unknown';
        String? displayAvatar;
        try {
          final localCamper = widget.campers.firstWhere(
            (c) => c.camperId == matchedId,
          );
          displayName = localCamper.camperName;
          displayAvatar = localCamper.avatar;
        } catch (_) {
          displayName = 'Unknown ID: $matchedId';
        }

        recognizedListForDialog.add({
          'name': displayName,
          'avatar': displayAvatar,
          'confidence': (match['confidence'] ?? 0.0) * 100,
        });
      }

      setState(() {});

      _showRecognitionResultDialog(recognizedListForDialog);
    } catch (e) {
      String errorMessage = e.toString();
      try {
        errorMessage = (e as dynamic).message;
      } catch (_) {}
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        isProcessing = false;
        // _capturedImage = null;
      });
    }
  }

  Future<void> _submitAttendance() async {
    final provider = context.read<AttendanceProvider>();
    List<UpdateAttendance> requests = [];

    attendance.forEach((camperId, status) {
      if (logIds.containsKey(camperId)) {
        String statusString;
        if (status == AttendanceStatus.present) {
          statusString = "Present";
        } else if (status == AttendanceStatus.absent) {
          statusString = "Absent";
        } else {
          return;
        }

        requests.add(
          UpdateAttendance(
            attendanceLogId: logIds[camperId]!,
            participantStatus: statusString,
            note: "",
          ),
        );
      }
    });

    if (requests.isEmpty) {
      _showErrorDialog("Không có dữ liệu thay đổi để lưu.");
      return;
    }

    try {
      await provider.submitAttendance(requests);
      if (mounted) {
        showCustomDialog(
          context,
          title: "Thành công",
          message: "Cập nhật điểm danh thành công!",
          type: DialogType.success,
          btnText: "Đóng",
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Widget _buildStatusCell(int camperId, AttendanceStatus status, Color color) {
    final current = attendance[camperId];
    final isSelected = current == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          attendance[camperId] = status;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: isSelected
            ? const Icon(Icons.circle, size: 12, color: Colors.white)
            : null,
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showCustomDialog(
        context,
        title: "Thông báo",
        message: message,
        type: DialogType.error,
        btnText: "Đóng",
      );
    }
  }

  void _showNoMatchDialog() {
    if (mounted) {
      showCustomDialog(
        context,
        title: "Không tìm thấy",
        message: "Không nhận diện được camper nào trong ảnh.",
        type: DialogType.warning,
        btnText: "Thử lại",
      );
    }
  }

  void _showRecognitionResultDialog(List<Map<String, dynamic>> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã nhận diện ${results.length} người',
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: results.length > 1 ? 250 : null,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: results.length,
            separatorBuilder: (ctx, i) => const Divider(),
            itemBuilder: (ctx, index) {
              final item = results[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: item['avatar'] != null
                      ? NetworkImage(item['avatar'])
                      : null,
                  child: item['avatar'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Độ chính xác: ${item['confidence'].toStringAsFixed(1)}%',
                ),
                trailing: const Icon(Icons.check, color: Colors.green),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(fontFamily: "Quicksand")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double statusColWidth = 40;
    const double genderColWidth = 70;
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Điểm danh khuôn mặt',
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: StaffTheme.staffPrimary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: isCameraVisible && isCameraInitialized
                        ? AspectRatio(
                            aspectRatio: 1 / _controller!.value.aspectRatio,
                            child: _capturedImage != null
                                ? Image.file(_capturedImage!, fit: BoxFit.cover)
                                : CameraPreview(_controller!),
                          )
                        : Container(
                            color: Colors.black87,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 60,
                                  color: Colors.white54,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isCameraVisible
                                      ? "Đang khởi động..."
                                      : "Camera đang tắt",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Quicksand",
                                  ),
                                ),
                                if (!isCameraVisible)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: ElevatedButton(
                                      onPressed: _toggleCamera,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: StaffTheme.staffAccent,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Bật Camera"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),

                Positioned(
                  top: 20,
                  right: 20,
                  child: Column(
                    children: [
                      if (isCameraVisible && cameras.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FloatingActionButton.small(
                            heroTag: "switch_cam",
                            onPressed: isProcessing ? null : _switchCamera,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.8,
                            ),
                            child: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      if (isCameraVisible)
                        FloatingActionButton.small(
                          heroTag: "close_cam",
                          onPressed: isProcessing ? null : _toggleCamera,
                          backgroundColor: Colors.red.withValues(alpha: 0.8),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                    ],
                  ),
                ),

                if (isCameraVisible && _capturedImage == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed:
                          (isProcessing ||
                              !_isDataReady ||
                              !isCameraInitialized)
                          ? null
                          : _takePictureAndRecognize,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StaffTheme.staffAccent.withValues(
                          alpha: 0.9,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.camera),
                      label: Text(
                        isProcessing ? "Đang xử lý..." : "Chụp & Quét",
                      ),
                    ),
                  ),

                if (_capturedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _capturedImage = null;
                        });
                        _controller?.resumePreview();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Chụp lại"),
                    ),
                  ),
              ],
            ),
          ),

          Container(
            color: StaffTheme.staffPrimary,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FixedColumnWidth(genderColWidth),
                2: FixedColumnWidth(statusColWidth),
                3: FixedColumnWidth(statusColWidth),
              },
              children: const [
                TableRow(
                  children: [
                    Text(
                      "Tên",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    Text(
                      "Giới tính",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    Center(
                      child: Text(
                        "A",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "P",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: widget.campers.length,
              itemBuilder: (context, index) {
                final camper = widget.campers[index];
                return Container(
                  color: index.isEven
                      ? Colors.grey.shade100
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FixedColumnWidth(genderColWidth),
                      2: FixedColumnWidth(statusColWidth),
                      3: FixedColumnWidth(statusColWidth),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            camper.camperName,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            camper.gender == 'Female' ? 'Nữ' : 'Nam',
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 14,
                            ),
                          ),
                          Center(
                            child: _buildStatusCell(
                              camper.camperId,
                              AttendanceStatus.absent,
                              Colors.red,
                            ),
                          ),
                          Center(
                            child: _buildStatusCell(
                              camper.camperId,
                              AttendanceStatus.present,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: StaffTheme.staffAccent,
        foregroundColor: Colors.white,
        onPressed: provider.loading ? null : _submitAttendance,
        icon: const Icon(Icons.save),
        label: const Text(
          "Lưu điểm danh",
          style: TextStyle(fontFamily: "Quicksand"),
        ),
      ),
    );
  }
}
