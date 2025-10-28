import 'package:flutter/material.dart';
import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class ReportCreateScreen extends StatefulWidget {
  const ReportCreateScreen({super.key});

  @override
  State<ReportCreateScreen> createState() => _ReportCreateScreenState();
}

class _ReportCreateScreenState extends State<ReportCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _camperIdController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _activityIdController = TextEditingController();

  String _status = "Pending";
  String _level = "Low";

  void _saveReport() {
    if (_formKey.currentState!.validate()) {
      final report = Report(
        reportId: DateTime.now().millisecondsSinceEpoch,
        camperId: int.tryParse(_camperIdController.text) ?? 0,
        note: _noteController.text,
        image: _imageController.text,
        createAt: DateTime.now(),
        status: _status,
        level: _level,
        activityId: int.tryParse(_activityIdController.text) ?? 0,
      );
      Navigator.pop(context, report);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tạo Báo Cáo",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _camperIdController,
                decoration: const InputDecoration(
                  labelText: "Camper ID",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập Camper ID" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập ghi chú" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _activityIdController,
                decoration: const InputDecoration(
                  labelText: "Activity ID",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: const InputDecoration(
                  labelText: "Level",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
                items: ["Low", "Medium", "High"]
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(
                          level,
                          style: const TextStyle(fontFamily: "Quicksand"),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _level = val!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(fontFamily: "Quicksand"),
                ),
                items: ["Pending", "Resolved"]
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: const TextStyle(fontFamily: "Quicksand"),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveReport,
                icon: const Icon(Icons.save),
                label: Text(
                  "Lưu báo cáo",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StaffTheme.staffAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
