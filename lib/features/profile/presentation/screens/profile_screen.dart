import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';

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
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: const TextStyle(fontFamily: "Nunito")),
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
    } else {
      _showMessageBox('Thông báo', 'Bạn chưa chọn ảnh nào.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Trang cá nhân",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: _isEditing ? _saveProfile : _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          bottom: 40,
          right: 20,
        ),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: AppTheme.summerBackground,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: AppTheme.summerAccent,
                          )
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: AppTheme.summerAccent,
                        radius: 22,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _buildSectionTitle("Thông tin cá nhân"),
            const SizedBox(height: 10),
            _buildProfileField("Họ và tên", _nameController, Icons.person),
            const SizedBox(height: 15),
            _buildProfileField("Email", _emailController, Icons.email),
            const SizedBox(height: 15),
            _buildProfileField("Số điện thoại", _phoneController, Icons.phone),
            const SizedBox(height: 15),
            _buildProfileField(
              "Địa chỉ",
              _addressController,
              Icons.location_on,
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("Tiện ích"),
            const SizedBox(height: 10),
            _buildProfileMenuItem(
              "Đăng ký trại hè",
              Icons.assignment,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegistrationListScreen(),
                ),
              ),
            ),
            _buildProfileMenuItem(
              "Hồ sơ của trẻ",
              Icons.assignment_ind,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegistrationListScreen(),
                ),
              ),
            ),
            _buildProfileMenuItem(
              "Thay đổi mật khẩu",
              Icons.lock,
              () => _showMessageBox(
                "Chức năng",
                "Chức năng thay đổi mật khẩu chưa được triển khai.",
              ),
            ),
            _buildProfileMenuItem(
              "Vé ứng dụng",
              Icons.confirmation_num,
              () => _showMessageBox(
                "Chức năng",
                "Chức năng vé ứng dụng chưa được triển khai.",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  _showMessageBox("Đăng xuất", "Bạn đã đăng xuất thành công."),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Đăng xuất",
                style: TextStyle(fontFamily: "Nunito", fontSize: 16),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Mọi thắc mắc vui lòng liên hệ CSKH:',
              style: TextStyle(
                fontFamily: "Nunito",
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Hotline: 0904918270',
              style: const TextStyle(
                fontFamily: "Fredoka",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.summerAccent,
              ),
            ),
            Text(
              'Email: khangpccse183245@fpt.edu.vn',
              style: const TextStyle(
                fontFamily: "Fredoka",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.summerAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "Fredoka",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.summerPrimary,
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: !_isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.summerPrimary),
      ),
      style: const TextStyle(fontFamily: "Nunito"),
    );
  }

  Widget _buildProfileMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.summerPrimary, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
