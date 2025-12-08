import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  File? _profileImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _dobController = TextEditingController();

    if (widget.user.dateOfBirth != null &&
        widget.user.dateOfBirth != "0001-01-01") {
      try {
        _selectedDate = DateFormat(
          'yyyy-MM-dd',
        ).parse(widget.user.dateOfBirth!);
        _dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      } catch (e) {
        _dobController.text = '';
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale("vi", "VN"),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final authProvider = context.read<AuthProvider>();

    try {
      String? dobForApi;
      if (_selectedDate != null) {
        dobForApi = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      } else if (widget.user.dateOfBirth != "0001-01-01") {
        dobForApi = widget.user.dateOfBirth;
      }

      final updatedUser = User(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dob: dobForApi,
      );

      await authProvider.updateUserProfile(updatedUser);

      if (_profileImage != null) {
        await authProvider.updateUploadAvatar(_profileImage!);

        await authProvider.fetchProfileUser();
      }

      if (mounted) {
        showCustomDialog(
          context,
          title: "Thành công",
          message: "Cập nhật hồ sơ thành công!",
          type: DialogType.success,
          btnText: "OK",
          dismissible: false,
          onConfirm: () {
            Navigator.pop(context, true);
          },
        );
      }
    } catch (e) {
      _showMessageBox('Lỗi', 'Cập nhật thất bại: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessageBox(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.summerPrimary,
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: const TextStyle(fontFamily: "Quicksand")),
        actions: [
          TextButton(
            child: const Text(
              'Đóng',
              style: TextStyle(color: AppTheme.summerAccent),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa hồ sơ",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppTheme.summerPrimary,
          ),
        ),
        backgroundColor: Color(0xFFF5F7F8),
        iconTheme: const IconThemeData(color: AppTheme.summerPrimary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.summerPrimary.withValues(
                      alpha: 0.1,
                    ),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (widget.user.avatar != null &&
                              widget.user.avatar!.isNotEmpty)
                        ? NetworkImage(widget.user.avatar!)
                        : null as ImageProvider?,
                    child:
                        (_profileImage == null &&
                            (widget.user.avatar == null ||
                                widget.user.avatar!.isEmpty))
                        ? const Icon(
                            Icons.person,
                            size: 70,
                            color: AppTheme.summerPrimary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: AppTheme.summerAccent,
                        radius: 20,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildProfileField(
              "Họ",
              _firstNameController,
              Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildProfileField(
              "Tên",
              _lastNameController,
              Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildProfileField(
              "Số điện thoại",
              _phoneController,
              Icons.phone_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: _inputDecoration(
                "Ngày sinh",
                Icons.calendar_today_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn ngày sinh';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.summerAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Lưu thay đổi",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontFamily: "Quicksand",
        fontWeight: FontWeight.normal,
      ),
      prefixIcon: Icon(icon, color: AppTheme.summerAccent),
      filled: true,
      fillColor: Colors.white,
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
        borderSide: const BorderSide(color: AppTheme.summerPrimary, width: 2),
      ),
    );
  }
}
