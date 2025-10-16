import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

class CamperCreateScreen extends StatefulWidget {
  const CamperCreateScreen({super.key});

  @override
  State<CamperCreateScreen> createState() => _CamperCreateScreenState();
}

class _CamperCreateScreenState extends State<CamperCreateScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final conditionController = TextEditingController();
  final allergiesController = TextEditingController();
  final noteController = TextEditingController();

  String? gender;
  bool? hasAllergy;
  XFile? _avatar;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _avatar = picked);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1950),
      lastDate: now,
      locale: const Locale("vi", "VN"),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CamperProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAvatar,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _avatar != null
                    ? FileImage(File(_avatar!.path))
                    : null,
                child: _avatar == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white70,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            _buildTextField(nameController, "Tên đầy đủ"),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: dobController,
                readOnly: true,
                decoration: _inputDecoration("Ngày sinh").copyWith(
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: AppTheme.summerPrimary,
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                decoration: _inputDecoration("Giới tính"),
                initialValue: gender,
                items: const [
                  DropdownMenuItem(value: "Nam", child: Text("Nam")),
                  DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                ],
                onChanged: (val) => setState(() => gender = val),
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
                          activeColor: AppTheme.summerAccent,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Không"),
                          value: hasAllergy == false,
                          onChanged: (_) => setState(() => hasAllergy = false),
                          activeColor: AppTheme.summerAccent,
                          controlAffinity: ListTileControlAffinity.leading,
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
                      ),
                    ),
                ],
              ),
            ),

            _buildTextField(noteController, "Ghi chú thêm"),

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
                onPressed: () {
                  final newCamper = Camper(
                    camperId: DateTime.now().millisecondsSinceEpoch,
                    fullName: nameController.text,
                    dob: dobController.text,
                    gender: gender ?? "Nam",
                    healthRecordId: 1,
                    createAt: DateTime.now(),
                    parentId: 1,
                    avatar: _avatar!.path,
                    condition: conditionController.text,
                    allergies: hasAllergy == true
                        ? allergiesController.text
                        : null,
                    isAllergy: hasAllergy,
                    note: noteController.text,
                  );
                  provider.createCamper(newCamper);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                label: Text(
                  "Tạo Camper",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: _inputDecoration(label),
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
    );
  }
}
