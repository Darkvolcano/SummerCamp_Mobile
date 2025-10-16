import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class FaceAttendanceScreen extends StatefulWidget {
  final List<Camper> campers;

  const FaceAttendanceScreen({super.key, required this.campers});

  @override
  State<FaceAttendanceScreen> createState() => _FaceAttendanceScreenState();
}

class _FaceAttendanceScreenState extends State<FaceAttendanceScreen> {
  File? _capturedImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _attendanceList = [];

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
          _isProcessing = true;
        });

        // Process face recognition with camper avatars
        await _processFaceRecognition();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    }
  }

  Future<void> _processFaceRecognition() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // replace this with actual face recognition API call
    // Send _capturedImage and widget.campers (with avatars) to API
    // API should compare captured image with camper avatars

    // Mock: Simulate matching with first camper who hasn't been marked yet
    final unmarkedCampers = widget.campers.where((camper) {
      return !_attendanceList.any((att) => att['camperId'] == camper.camperId);
    }).toList();

    if (unmarkedCampers.isEmpty) {
      setState(() {
        _isProcessing = false;
      });
      _showNoMatchDialog();
      return;
    }

    // Simulate successful match with first unmarked camper
    final matchedCamper = unmarkedCampers.first;
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final result = {
      'camperId': matchedCamper.camperId,
      'name': matchedCamper.fullName,
      'avatar': matchedCamper.avatar,
      'confidence': unmarkedCampers.length % 5,
      'status': 'Có mặt',
      'time': timeStr,
      'timestamp': now,
    };

    setState(() {
      _isProcessing = false;
      _attendanceList.add(result);
    });

    // Show success dialog
    _showRecognitionResultDialog(result);
  }

  //   Future<void> _processFaceRecognition() async {
  //   if (!mounted) return;

  //   try {
  //     // Chuẩn bị data gửi lên API
  //     final request = {
  //       'capturedImage': _capturedImage, // Ảnh vừa chụp
  //       'camperAvatars': widget.campers.map((camper) => {
  //         'camperId': camper.camperId,
  //         'name': camper.fullName,
  //         'avatarUrl': camper.avatar,
  //       }).toList(),
  //     };

  //     // Call Face Recognition API
  //     final response = await yourFaceRecognitionAPI.comparefaces(request);

  //     // API trả về camper phù hợp nhất
  //     if (response.success && response.match != null) {
  //       final matchedCamperId = response.match.camperId;
  //       final confidence = response.match.confidence;

  //       // Tìm camper từ danh sách
  //       final matchedCamper = widget.campers.firstWhere(
  //         (c) => c.camperId == matchedCamperId,
  //       );

  //       // Check đã điểm danh chưa
  //       if (_attendanceList.any((att) => att['camperId'] == matchedCamperId)) {
  //         _showAlreadyMarkedDialog(matchedCamper.fullName);
  //         return;
  //       }

  //       // Thêm vào danh sách điểm danh
  //       final result = {
  //         'camperId': matchedCamper.camperId,
  //         'name': matchedCamper.fullName,
  //         'avatar': matchedCamper.avatar,
  //         'confidence': confidence,
  //         'status': 'Có mặt',
  //         'time': _getCurrentTime(),
  //         'timestamp': DateTime.now(),
  //       };

  //       setState(() {
  //         _isProcessing = false;
  //         _attendanceList.add(result);
  //       });

  //       _showRecognitionResultDialog(result);
  //     } else {
  //       setState(() => _isProcessing = false);
  //       _showNoMatchDialog();
  //     }
  //   } catch (e) {
  //     setState(() => _isProcessing = false);
  //     _showErrorDialog(e.toString());
  //   }
  // }

  // void _showAlreadyMarkedDialog(String name) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Row(
  //         children: [
  //           const Icon(Icons.info, color: Colors.blue, size: 32),
  //           const SizedBox(width: 12),
  //           const Text('Đã điểm danh', style: TextStyle(fontFamily: "Quicksand")),
  //         ],
  //       ),
  //       content: Text(
  //         '$name đã được điểm danh rồi!',
  //         style: const TextStyle(fontFamily: "Quicksand"),
  //       ),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             setState(() => _capturedImage = null);
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showRecognitionResultDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            const Text(
              'Nhận diện thành công',
              style: TextStyle(fontFamily: "Quicksand", fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Show matched camper avatar
            if (result['avatar'] != null && result['avatar'].isNotEmpty)
              ClipOval(
                child: Image.network(
                  result['avatar'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 40),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              result['name'],
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Độ chính xác: ${result['confidence'].toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trạng thái: ${result['status']}',
              style: const TextStyle(
                fontFamily: "Quicksand",
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _capturedImage = null;
              });
            },
            child: const Text(
              'Tiếp tục quét',
              style: TextStyle(fontFamily: "Quicksand"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _capturedImage = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: StaffTheme.staffAccent,
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: "Quicksand", color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoMatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            const Text(
              'Không tìm thấy',
              style: TextStyle(fontFamily: "Quicksand", fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Không tìm thấy camper phù hợp hoặc tất cả đã được điểm danh.',
          style: TextStyle(fontFamily: "Quicksand"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _capturedImage = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: StaffTheme.staffAccent,
            ),
            child: const Text(
              'Thử lại',
              style: TextStyle(fontFamily: "Quicksand", color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Camera Preview / Captured Image Area
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: StaffTheme.staffPrimary, width: 2),
              ),
              child: _capturedImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(_capturedImage!, fit: BoxFit.cover),
                        ),
                        if (_isProcessing)
                          Container(
                            color: Colors.black54,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Đang so sánh với database...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Quicksand",
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face_retouching_natural,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có ảnh',
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nhấn nút bên dưới để quét khuôn mặt',
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          // Camper List Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.purple.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Có ${widget.campers.length} campers trong danh sách',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 13,
                      color: Colors.purple.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Scan Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _openCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: StaffTheme.staffAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                icon: const Icon(Icons.camera_alt, size: 28),
                label: Text(
                  _isProcessing ? 'Đang xử lý...' : 'Quét khuôn mặt',
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Instructions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hệ thống sẽ so sánh khuôn mặt với avatar của campers',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Attendance List
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: StaffTheme.staffAccent),
                        const SizedBox(width: 8),
                        const Text(
                          'Đã điểm danh',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_attendanceList.length}/${widget.campers.length}',
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _attendanceList.isEmpty
                        ? Center(
                            child: Text(
                              'Chưa có ai điểm danh',
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                color: Colors.grey.shade600,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _attendanceList.length,
                            itemBuilder: (context, index) {
                              final attendance = _attendanceList[index];
                              return ListTile(
                                leading:
                                    attendance['avatar'] != null &&
                                        attendance['avatar'].isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          attendance['avatar'],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.green.shade100,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.green.shade700,
                                                ),
                                              ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.green.shade100,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                title: Text(
                                  attendance['name'],
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Độ chính xác: ${attendance['confidence'].toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      attendance['time'],
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
