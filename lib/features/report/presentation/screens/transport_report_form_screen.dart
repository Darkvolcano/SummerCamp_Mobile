import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/album/presentation/state/album_provider.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class TransportReportCreateScreen extends StatefulWidget {
  final int campId;
  final int transportScheduleId;
  const TransportReportCreateScreen({
    super.key,
    required this.campId,
    required this.transportScheduleId,
  });

  @override
  State<TransportReportCreateScreen> createState() =>
      _TransportReportCreateScreenState();
}

class _TransportReportCreateScreenState
    extends State<TransportReportCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  int? _selectedCamperId;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoadingCampers = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await context
        .read<ScheduleProvider>()
        .loadCampersTransportByTransportScheduleId(widget.transportScheduleId);

    if (mounted) {
      setState(() {
        _isLoadingCampers = false;
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Lỗi chọn ảnh: $e");
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCamperId == null) {
      showCustomDialog(
        context,
        title: "Thiếu thông tin",
        message: "Vui lòng chọn Camper",
        type: DialogType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final reportProvider = context.read<ReportProvider>();
      final albumProvider = context.read<AlbumProvider>();

      String imageUrl = "";

      if (_selectedImage != null) {
        imageUrl = await albumProvider.uploadImage(_selectedImage!);
      }

      await reportProvider.createTransportReport(
        campId: widget.campId,
        camperId: _selectedCamperId!,
        note: _noteController.text,
        transportScheduleId: widget.transportScheduleId,
        imageUrl: imageUrl,
      );

      if (mounted) {
        showCustomDialog(
          context,
          title: "Thành công",
          message: "Đã gửi báo cáo thành công",
          type: DialogType.success,
          onConfirm: () {
            Navigator.of(context).pop(true);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context,
          title: "Lỗi",
          message: "Gửi báo cáo thất bại: $e",
          type: DialogType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final transportCamperList = scheduleProvider.campersTransport;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Sự Cố",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: StaffTheme.staffPrimary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Nhấn để tải ảnh sự cố",
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () => setState(() => _selectedImage = null),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        "Xóa ảnh",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              Column(
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: _selectedCamperId,
                    decoration: InputDecoration(
                      labelText: "Chọn Camper",
                      // ... (decoration giữ nguyên)
                    ),
                    // Map dữ liệu từ transportCamperList
                    items: transportCamperList.map((transport) {
                      return DropdownMenuItem<int>(
                        // Lấy ID camper từ object transport
                        value: transport.camper.camperId,
                        child: Text(
                          transport.camper.camperName, // Tên camper
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCamperId = val),
                    validator: (value) =>
                        value == null ? "Vui lòng chọn camper" : null,
                    // Hiển thị hint dựa vào trạng thái loading
                    hint: _isLoadingCampers
                        ? const Text(
                            "Đang tải danh sách...",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 13,
                            ),
                          )
                        : (transportCamperList.isEmpty
                              ? const Text(
                                  "Không có camper nào",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 13,
                                  ),
                                )
                              : null),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildLevelDropdown(),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 4,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Chi tiết sự cố",
                    labelStyle: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey,
                    ),
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.note_alt_outlined,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Vui lòng nhập nội dung"
                      : null,
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitReport,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    _isSubmitting ? "Đang xử lý..." : "Gửi Báo Cáo",
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StaffTheme.staffAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mức độ sự cố",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
