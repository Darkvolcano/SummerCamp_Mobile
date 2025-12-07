import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

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
  File? _capturedImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _attendanceList = [];

  final Map<int, int> _camperGroups = {};
  bool _isDataReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegistrationData();
    });
    _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      // Khôi phục lại ảnh đã chụp
      setState(() {
        _capturedImage = File(response.file!.path);
        _isProcessing = true;
      });
      // Gọi lại logic nhận diện
      await _processFaceRecognition();
    } else {
      // Xử lý lỗi nếu có
      _showErrorSnackBar('Lỗi khôi phục ảnh: ${response.exception?.code}');
    }
  }

  Future<void> _loadRegistrationData() async {
    setState(() => _isDataReady = false); // Bắt đầu tải

    try {
      final regProvider = context.read<RegistrationProvider>();
      await regProvider.loadRegistrationCampers();

      final regCampers = regProvider.registrationCampers;

      // Clear map cũ để tránh duplicate nếu load lại
      _camperGroups.clear();

      for (var reg in regCampers) {
        // Kiểm tra kỹ null safety ở đây
        // ignore: unnecessary_null_comparison
        if (reg.camperGroup != null && reg.camperGroup!.groupName != null) {
          // Đảm bảo truy xuất đúng cấp độ object
          _camperGroups[reg.camperId] = reg.camperGroup!.groupName.groupId;
        }
      }

      print("Đã tải xong thông tin nhóm: ${_camperGroups.length} records");
    } catch (e) {
      print("Lỗi tải data nhóm: $e");
      _showErrorSnackBar("Không tải được dữ liệu nhóm camper");
    } finally {
      if (mounted) {
        setState(() => _isDataReady = true); // Tải xong (dù lỗi hay không)
      }
    }
  }

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

        // Gọi API nhận diện
        await _processFaceRecognition();
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi camera: ${e.toString()}');
    }
  }

  Future<void> _processFaceRecognition() async {
    if (_capturedImage == null) return;

    final attendanceProvider = context.read<AttendanceProvider>();

    try {
      int targetGroupId = 0;
      for (var camper in widget.campers) {
        if (_camperGroups.containsKey(camper.camperId)) {
          targetGroupId = _camperGroups[camper.camperId]!;
          break;
        }
      }

      if (targetGroupId == 0) {
        throw Exception("Không tìm thấy thông tin nhóm của các camper này.");
      }

      // GỌI API NHẬN DIỆN
      final result = await attendanceProvider.recognizeFaceUseCase(
        activityScheduleId: widget.activityScheduleId,
        photo: _capturedImage!,
        campId: widget.campId,
        groupId: targetGroupId,
      );

      final bool success = result['success'] ?? false;
      final List<dynamic> recognizedCampers = result['recognizedCampers'] ?? [];

      if (!success || recognizedCampers.isEmpty) {
        setState(() => _isProcessing = false);
        _showNoMatchDialog();
        return;
      }

      // Giả sử lấy camper đầu tiên nhận diện được (hoặc xử lý danh sách nếu cần)
      // Trong UI hiện tại bạn đang show 1 dialog kết quả, nên ta lấy người đầu tiên
      final match = recognizedCampers.first;

      final now = DateTime.now();
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final displayResult = {
        'camperId': match['camperId'],
        'name': match['camperName'] ?? 'Unknown',
        'avatar': _findAvatar(match['camperId']),
        'confidence': (match['confidence'] ?? 0.0) * 100,
        'status': 'Có mặt', // Mặc định là có mặt nếu nhận diện thành công
        'time': timeStr,
      };

      setState(() {
        _isProcessing = false;
        _attendanceList.add(displayResult);
      });

      _showRecognitionResultDialog(displayResult);
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorSnackBar('Lỗi nhận diện: ${e.toString()}');
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

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
                onPressed: (_isProcessing || !_isDataReady)
                    ? null
                    : _openCamera,
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
                  _isProcessing
                      ? 'Đang xử lý...'
                      : (!_isDataReady
                            ? 'Đang tải dữ liệu...'
                            : 'Quét khuôn mặt'),
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
