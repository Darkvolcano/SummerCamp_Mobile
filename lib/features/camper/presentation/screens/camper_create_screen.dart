import 'package:flutter/material.dart';
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
  final nameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final genderCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CamperProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm Camper",
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
                  final newCamper = Camper(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fullName: nameCtrl.text,
                    dob: dobCtrl.text,
                    gender: genderCtrl.text,
                    healthRecordId: 1,
                    createAt: DateTime.now(),
                    parentId: 1,
                  );
                  provider.createCamper(newCamper);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                label: Text(
                  "Tạo",
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
