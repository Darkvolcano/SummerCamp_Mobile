import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
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
  late TextEditingController genderCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.camper.fullName);
    dobCtrl = TextEditingController(text: widget.camper.dob);
    genderCtrl = TextEditingController(text: widget.camper.gender);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(nameCtrl, "Tên"),
            _buildTextField(dobCtrl, "Ngày sinh"),
            _buildTextField(genderCtrl, "Giới tính"),
            const SizedBox(height: 24),
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
                    gender: genderCtrl.text,
                    healthRecordId: widget.camper.healthRecordId,
                    createAt: widget.camper.createAt,
                    parentId: widget.camper.parentId,
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
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
