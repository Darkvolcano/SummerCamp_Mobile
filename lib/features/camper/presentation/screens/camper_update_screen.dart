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

class CamperUpdateScreen extends StatefulWidget {
  final Camper camper;
  const CamperUpdateScreen({super.key, required this.camper});

  @override
  State<CamperUpdateScreen> createState() => _CamperUpdateScreenState();
}

class _CamperUpdateScreenState extends State<CamperUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController conditionController;
  late TextEditingController allergiesController;
  late TextEditingController noteController;

  DateTime? _selectedDate;
  String? gender;
  bool? hasAllergy;
  XFile? _avatar;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false; // Loading cho upload ảnh
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.camper.fullName);

    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.camper.dob);
    dobController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_selectedDate!),
    );

    conditionController = TextEditingController(
      text: widget.camper.healthRecord?.condition ?? "",
    );
    allergiesController = TextEditingController(
      text: widget.camper.healthRecord?.allergies ?? "",
    );
    noteController = TextEditingController(
      text: widget.camper.healthRecord?.note ?? "",
    );

    // gender = widget.camper.gender;
    String apiGender = widget.camper.gender.toLowerCase();
    if (apiGender == 'male' || apiGender == 'nam') {
      gender = "Nam";
    } else if (apiGender == 'female' || apiGender == 'nữ') {
      gender = "Nữ";
    } else {
      gender = null;
    }
    hasAllergy = widget.camper.healthRecord?.isAllergy;

    _avatarUrl = widget.camper.avatar;
  }

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
    if (_isUploading) return;

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatar = picked;
        _isUploading = true;
      });
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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

    setState(() => _isLoading = true);

    final healthRecord = HealthRecord(
      condition: conditionController.text,
      allergies: allergiesController.text,
      isAllergy: hasAllergy,
      note: noteController.text,
    );

    final updatedCamper = Camper(
      camperId: widget.camper.camperId,
      fullName: nameController.text,
      dob: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      gender: gender!,
      healthRecord: healthRecord,
      groupId: widget.camper.groupId,
      avatar: _avatarUrl,
    );

    try {
      await context.read<CamperProvider>().updateCamper(
        widget.camper.camperId,
        updatedCamper,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cập nhật camper thành công!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cập nhật Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                          : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                                    ? NetworkImage(_avatarUrl!)
                                    : null)
                                as ImageProvider?,
                      child:
                          (_avatar == null &&
                              (_avatarUrl == null || _avatarUrl!.isEmpty) &&
                              !_isUploading)
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
                  onTap: () => _selectDate(context),
                  validator: (v) => v!.isEmpty ? "Vui lòng chọn ngày" : null,
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
                  validator: (v) =>
                      v == null ? "Vui lòng chọn giới tính" : null,
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
                            title: const Text("Có"),
                            value: hasAllergy == true,
                            onChanged: (_) => setState(() => hasAllergy = true),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Không"),
                            value: hasAllergy == false,
                            onChanged: (_) =>
                                setState(() => hasAllergy = false),
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
                          "Nhập loại dị ứng",
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
                  onPressed: _isLoading ? null : _handleSubmit,
                  icon: const Icon(Icons.save),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Lưu thay đổi",
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
            ? (value) => (value == null || value.isEmpty)
                  ? 'Vui lòng nhập $label'
                  : null
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
