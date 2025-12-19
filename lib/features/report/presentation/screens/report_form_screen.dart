import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/album/presentation/state/album_provider.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';

class ReportCreateScreen extends StatefulWidget {
  final int campId;
  const ReportCreateScreen({super.key, required this.campId});

  @override
  State<ReportCreateScreen> createState() => _ReportCreateScreenState();
}

class _ReportCreateScreenState extends State<ReportCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  int _level = 1;
  bool _isSubmitting = false;

  int? _selectedCamperId;
  int? _selectedActivityId;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final Map<int, String> _levelLabels = {1: "Thấp", 2: "Trung bình", 3: "Cao"};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CamperProvider>().loadStaffCampGroup(widget.campId);
      context.read<ActivityProvider>().loadActivitySchedulesByCampId(
        widget.campId,
      );
    });
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

      await reportProvider.createReport(
        campId: widget.campId,
        camperId: _selectedCamperId!,
        note: _noteController.text,
        activityScheduleId: _selectedActivityId ?? 0,
        level: _level,
        imageUrl: imageUrl,
      );

      if (mounted) {
        showCustomDialog(
          context,
          title: "Thành công",
          message: "Đã gửi báo cáo thành công",
          type: DialogType.success,
          onConfirm: () => Navigator.pop(context),
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
    final camperProvider = context.watch<CamperProvider>();
    final camperList = camperProvider.groupMembers;

    final activityProvider = context.watch<ActivityProvider>();
    final activityList = activityProvider.activitySchedules;

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
                      labelStyle: const TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: StaffTheme.staffPrimary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: camperList.map((member) {
                      return DropdownMenuItem<int>(
                        value: member.camperName.camperId,
                        child: Text(
                          member.camperName.camperName,
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
                    hint: camperList.isEmpty
                        ? const Text(
                            "Đang tải danh sách...",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 13,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    initialValue: _selectedActivityId,
                    decoration: InputDecoration(
                      labelText: "Chọn Hoạt động",
                      labelStyle: const TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.event_note,
                        color: StaffTheme.staffPrimary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: activityList.map((act) {
                      String dateStr = DateFormatter.formatDate(act.startTime);

                      return DropdownMenuItem<int>(
                        value: act.activityScheduleId,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            "${act.activity?.name ?? "Hoạt động không tên"} ($dateStr)",
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedActivityId = val),
                    hint: activityList.isEmpty
                        ? const Text(
                            "Đang tải danh sách...",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 13,
                            ),
                          )
                        : null,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _level,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: StaffTheme.staffPrimary,
              ),
              items: _levelLabels.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: _getLevelColor(entry.key),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _level = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.green;
      default:
        return StaffTheme.staffPrimary;
    }
  }
}
