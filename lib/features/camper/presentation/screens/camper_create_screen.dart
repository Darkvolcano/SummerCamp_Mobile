import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/entities/health_record.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class CamperCreateScreen extends StatefulWidget {
  const CamperCreateScreen({super.key});

  @override
  State<CamperCreateScreen> createState() => _CamperCreateScreenState();
}

class _CamperCreateScreenState extends State<CamperCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final conditionController = TextEditingController();
  final allergiesController = TextEditingController();
  final noteController = TextEditingController();

  DateTime? _selectedDate;
  String? gender;
  bool? hasAllergy;
  XFile? _avatar;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  String? _avatarUrl;

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    conditionController.dispose();
    allergiesController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    // Không cho phép chọn ảnh mới khi đang upload
    if (_isUploading) return;

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatar = picked; // Hiển thị ảnh local đã chọn
        _isUploading = true; // Bắt đầu hiển thị vòng xoay
      });
      // Bắt đầu tải ảnh lên
      await _uploadFile(picked);
    }
  }

  Future<void> _uploadFile(XFile file) async {
    try {
      final fileExtension = p.extension(file.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final ref = FirebaseStorage.instance
          .ref('camper_avatars')
          .child(fileName);

      await ref.putFile(File(file.path));

      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _avatarUrl = downloadUrl;
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _avatar = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload ảnh thất bại: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
      locale: const Locale("vi", "VN"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dobController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ngày sinh")));
      return;
    }
    if (gender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn giới tính")));
      return;
    }
    if (hasAllergy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn tình trạng dị ứng")),
      );
      return;
    }
    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đang tải ảnh lên, vui lòng chờ...")),
      );
      return;
    }

    final healthRecord = HealthRecord(
      condition: conditionController.text,
      allergies: allergiesController.text,
      isAllergy: hasAllergy,
      note: noteController.text,
    );

    final newCamper = Camper(
      camperId: 0,
      camperName: nameController.text,
      dob: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      gender: gender!,
      healthRecord: healthRecord,
      groupId: null,
      avatar: _avatarUrl ?? "",
    );

    final provider = context.read<CamperProvider>();

    try {
      await provider.createCamper(newCamper);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tạo camper thành công!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi khi tạo camper: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppTheme.summerPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.summerPrimary),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _avatar != null
                          ? FileImage(File(_avatar!.path))
                          : null,
                      child: (_avatar == null && !_isUploading)
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                    if (_isUploading)
                      const CircularProgressIndicator(
                        color: AppTheme.summerAccent,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, "Tên đầy đủ", isRequired: true),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: dobController,
                  readOnly: true,
                  decoration: _inputDecoration("Ngày sinh").copyWith(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppTheme.summerPrimary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn ngày sinh';
                    }
                    return null;
                  },
                  onTap: () => _selectDate(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Giới tính"),
                  initialValue: gender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Nam")),
                    DropdownMenuItem(value: "Female", child: Text("Nữ")),
                  ],
                  onChanged: (value) => setState(() => gender = value),
                  validator: (value) =>
                      (value == null) ? 'Vui lòng chọn giới tính' : null,
                ),
              ),
              _buildTextField(conditionController, "Tình trạng sức khỏe"),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dị ứng",
                      style: textTheme.bodyLarge?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              "Có",
                              style: TextStyle(fontFamily: "Quicksand"),
                            ),
                            value: hasAllergy == true,
                            onChanged: (_) => setState(() => hasAllergy = true),
                            activeColor: AppTheme.summerAccent,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              "Không",
                              style: TextStyle(fontFamily: "Quicksand"),
                            ),
                            value: hasAllergy == false,
                            onChanged: (_) =>
                                setState(() => hasAllergy = false),
                            activeColor: AppTheme.summerAccent,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    if (hasAllergy == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildTextField(
                          allergiesController,
                          "Nhập loại dị ứng (nếu có)",
                          isRequired: true,
                        ),
                      ),
                  ],
                ),
              ),
              _buildTextField(noteController, "Ghi chú thêm"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.summerAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.add),
                  label: Text(
                    "Tạo Camper",
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(label),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập $label';
                }
                return null;
              }
            : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w600,
        color: AppTheme.summerPrimary,
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.summerPrimary, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.summerAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
