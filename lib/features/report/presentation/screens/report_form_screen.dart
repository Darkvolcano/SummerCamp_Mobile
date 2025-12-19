import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';

class ReportCreateScreen extends StatefulWidget {
  final int campId;
  const ReportCreateScreen({super.key, required this.campId});

  @override
  State<ReportCreateScreen> createState() => _ReportCreateScreenState();
}

class _ReportCreateScreenState extends State<ReportCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _camperIdController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _activityIdController = TextEditingController();
  String _status = "Pending";
  String _level = "Low";
  bool _isSubmitting = false;

  @override
  void dispose() {
    _camperIdController.dispose();
    _noteController.dispose();
    _activityIdController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final provider = context.read<ReportProvider>();

      await provider.createReport(
        campId: widget.campId,
        camperId: int.tryParse(_camperIdController.text) ?? 0,
        note: _noteController.text,
        activityScheduleId: int.tryParse(_activityIdController.text) ?? 0,
        level: _level,
        imageUrl: "",
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Tạo Báo Cáo Sự Cố",
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
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _camperIdController,
                      label: "Mã Camper (ID)",
                      icon: Icons.person_outline,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _activityIdController,
                      label: "Mã Hoạt động (ID)",
                      icon: Icons.event_note,
                      isNumber: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: "Mức độ",
                      value: _level,
                      items: ["Low", "Medium", "High"],
                      icon: Icons.warning_amber_rounded,
                      onChanged: (val) => setState(() => _level = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: "Trạng thái",
                      value: _status,
                      items: ["Pending", "Resolved"],
                      icon: Icons.info_outline,
                      onChanged: (val) => setState(() => _status = val!),
                    ),
                  ),
                ],
              ),
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
                    _isSubmitting ? "Đang gửi..." : "Gửi Báo Cáo",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: "Quicksand",
          color: Colors.grey,
        ),
        prefixIcon: Icon(icon, color: StaffTheme.staffPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: StaffTheme.staffPrimary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Vui lòng nhập thông tin" : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: StaffTheme.staffPrimary,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: _getLevelColor(item)),
                      const SizedBox(width: 8),
                      Text(
                        item,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return StaffTheme.staffPrimary;
    }
  }
}
