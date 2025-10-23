import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Nguyễn Văn A',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'nguyenvana@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0901234567',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '123 Đường ABC, Quận 1, TP.HCM',
  );

  bool _isEditing = false;
  File? _profileImage;

  void _toggleEditing() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveProfile() {
    _showMessageBox('Thành công', 'Thông tin cá nhân đã được cập nhật.');
    _toggleEditing();
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _handleLogout() async {
    final provider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    try {
      await provider.logout();

      if (mounted) {
        navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng xuất thất bại: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save_rounded : Icons.edit_rounded,
              color: Colors.white,
            ),
            onPressed: _isEditing ? _saveProfile : _toggleEditing,
          ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: const BoxDecoration(
              color: AppTheme.summerPrimary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: AppTheme.summerPrimary,
                            )
                          : null,
                    ),
                    if (_isEditing)
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
                const SizedBox(height: 15),
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _emailController.text,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin cá nhân",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.summerPrimary,
                          ),
                        ),
                        const Divider(height: 20),
                        _buildProfileField(
                          "Họ và tên",
                          _nameController,
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        _buildProfileField(
                          "Email",
                          _emailController,
                          Icons.email_outlined,
                        ),
                        const SizedBox(height: 15),
                        _buildProfileField(
                          "Số điện thoại",
                          _phoneController,
                          Icons.phone_outlined,
                        ),
                        const SizedBox(height: 15),
                        _buildProfileField(
                          "Địa chỉ",
                          _addressController,
                          Icons.location_on_outlined,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tiện ích",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildProfileMenuItem(
                      "Lịch sử đăng ký",
                      Icons.assignment_outlined,
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.registrationList,
                      ),
                    ),
                    _buildProfileMenuItem(
                      "Hồ sơ của trẻ",
                      Icons.assignment_ind_outlined,
                      () => Navigator.pushNamed(context, AppRoutes.camperList),
                    ),
                    _buildProfileMenuItem(
                      "Thay đổi mật khẩu",
                      Icons.lock_outline,
                      () => _showMessageBox(
                        "Chức năng",
                        "Chức năng này chưa được triển khai.",
                      ),
                    ),
                    _buildProfileMenuItem(
                      "Vé ứng dụng",
                      Icons.confirmation_number_outlined,
                      () => _showMessageBox(
                        "Chức năng",
                        "Chức năng này chưa được triển khai.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Đăng xuất",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isAlwaysReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isAlwaysReadOnly || !_isEditing,
      style: const TextStyle(fontFamily: "Quicksand", fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: AppTheme.summerAccent),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.summerPrimary),
        ),
        suffixIcon: _isEditing && !isAlwaysReadOnly
            ? const Icon(Icons.edit, size: 18, color: Colors.grey)
            : null,
      ),
    );
  }

  Widget _buildProfileMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.summerPrimary),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
