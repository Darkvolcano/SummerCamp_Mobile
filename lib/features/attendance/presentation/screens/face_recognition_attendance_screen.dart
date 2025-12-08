import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

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
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _attendanceList = [];
  bool _isDataReady = false;
  int _currentGroupId = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupData();
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showErrorDialog('Không tìm thấy camera trên thiết bị');
        return;
      }

      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.jpeg
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Lỗi khởi tạo camera: $e');
    }
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
    if (_isProcessing) return;

    if (_currentGroupId == 0) {
      _showErrorDialog("Chưa có thông tin Nhóm. Vui lòng thử lại.");
      _loadGroupData();
      return;
    }

    try {
      setState(() => _isProcessing = true);

      final XFile image = await _controller!.takePicture();
      final File imageFile = File(image.path);

      await _processFaceRecognition(imageFile);
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog('Lỗi chụp ảnh: $e');
    }
  }

  Future<void> _processFaceRecognition(File imageFile) async {
    final attendanceProvider = context.read<AttendanceProvider>();

    try {
      final result = await attendanceProvider.recognizeFace(
        activityScheduleId: widget.activityScheduleId,
        photo: imageFile,
        campId: widget.campId,
        groupId: _currentGroupId,
      );

      final bool success = result['success'] ?? false;
      final List<dynamic> recognizedCampers = result['recognizedCampers'] ?? [];

      if (!success || recognizedCampers.isEmpty) {
        setState(() => _isProcessing = false);
        _showNoMatchDialog();
        return;
      }

      final match = recognizedCampers.first;
      final now = DateTime.now();
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final displayResult = {
        'camperId': match['camperId'],
        'name': match['camperName'] ?? 'Unknown',
        'avatar': _findAvatar(match['camperId']),
        'confidence': (match['confidence'] ?? 0.0) * 100,
        'status': 'Có mặt',
        'time': timeStr,
      };

      setState(() {
        _isProcessing = false;
        _attendanceList.add(displayResult);
      });

      _showRecognitionResultDialog(displayResult);
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog('Lỗi nhận diện: ${e.toString()}');
    }
  }

  String? _findAvatar(int camperId) {
    try {
      final camper = widget.campers.firstWhere((c) => c.camperId == camperId);
      return camper.avatar;
    } catch (e) {
      return null;
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showCustomDialog(
        context,
        title: "Đã xảy ra lỗi",
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
        message: "Không tìm thấy camper phù hợp trong cơ sở dữ liệu.",
        type: DialogType.warning,
        btnText: "Thử lại",
      );
    }
  }

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
            if (result['avatar'] != null)
              ClipOval(
                child: Image.network(
                  result['avatar'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
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
            Text(
              'Độ chính xác: ${result['confidence'].toStringAsFixed(1)}%',
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tiếp tục quét',
              style: TextStyle(fontFamily: "Quicksand"),
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
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: StaffTheme.staffPrimary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _isCameraInitialized
                    ? AspectRatio(
                        aspectRatio: 1 / _controller!.value.aspectRatio,
                        child: CameraPreview(_controller!),
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
          ),

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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed:
                    (_isProcessing || !_isDataReady || !_isCameraInitialized)
                    ? null
                    : _takePictureAndRecognize,
                style: ElevatedButton.styleFrom(
                  backgroundColor: StaffTheme.staffAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.camera_alt, size: 28),
                label: Text(
                  _isProcessing
                      ? ' Đang xử lý...'
                      : (!_isDataReady
                            ? ' Đang tải thông tin...'
                            : ' Chụp & Quét'),
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

          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        final item = _attendanceList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: item['avatar'] != null
                                ? NetworkImage(item['avatar'])
                                : null,
                            backgroundColor: Colors.green.shade100,
                            child: item['avatar'] == null
                                ? const Icon(Icons.person, color: Colors.green)
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
                            "Độ chính xác: ${item['confidence'].toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 12,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              Text(
                                item['time'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
