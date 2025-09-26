import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

class CamperUpdateScreen extends StatefulWidget {
  final Camper camper;
  const CamperUpdateScreen({super.key, required this.camper});

  @override
  State<CamperUpdateScreen> createState() => _CamperUpdateScreenState();
}

class _CamperUpdateScreenState extends State<CamperUpdateScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController dobCtrl;
  late TextEditingController conditionCtrl;
  late TextEditingController allergiesCtrl;
  late TextEditingController noteCtrl;

  String? gender;
  bool? hasAllergy;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.camper.fullName);
    dobCtrl = TextEditingController(
      text: DateFormatter.formatFromString(widget.camper.dob),
    );
    conditionCtrl = TextEditingController(text: widget.camper.condition ?? "");
    allergiesCtrl = TextEditingController(text: widget.camper.allergies ?? "");
    noteCtrl = TextEditingController(text: widget.camper.note ?? "");
    gender = widget.camper.gender;
    hasAllergy = widget.camper.isAllergy;
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
        dobCtrl.text = DateFormat("dd/MM/yyyy").format(picked);
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
          "Cập nhật Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
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
            _buildTextField(nameCtrl, "Tên đầy đủ"),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: dobCtrl,
                readOnly: true,
                decoration: _inputDecoration("Ngày sinh (dd/MM/yyyy)").copyWith(
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

            _buildTextField(conditionCtrl, "Tình trạng sức khỏe"),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dị ứng",
                    style: textTheme.bodyLarge?.copyWith(
                      fontFamily: "Fredoka",
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
                      child: _buildTextField(allergiesCtrl, "Nhập loại dị ứng"),
                    ),
                ],
              ),
            ),

            _buildTextField(noteCtrl, "Ghi chú thêm"),

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
                  final updated = Camper(
                    camperId: widget.camper.camperId,
                    fullName: nameCtrl.text,
                    dob: dobCtrl.text,
                    gender: gender ?? "Nam",
                    healthRecordId: widget.camper.healthRecordId,
                    createAt: widget.camper.createAt,
                    parentId: widget.camper.parentId,
                    condition: conditionCtrl.text,
                    allergies: hasAllergy == true ? allergiesCtrl.text : null,
                    isAllergy: hasAllergy,
                    note: noteCtrl.text,
                  );
                  provider.updateCamper(widget.camper.camperId, updated);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: Text(
                  "Lưu thay đổi",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Fredoka",
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

  Widget _buildTextField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(controller: ctrl, decoration: _inputDecoration(label)),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: "Nunito",
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
