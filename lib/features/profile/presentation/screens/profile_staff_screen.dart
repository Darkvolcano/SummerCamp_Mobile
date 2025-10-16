import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  File? _profileImage;

  String staffName = "Nguyễn Văn B";
  String staffEmail = "staff@example.com";
  String staffPhone = "0987654321";
  String staffPosition = "Trưởng nhóm hướng dẫn";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: staffName);
        final emailController = TextEditingController(text: staffEmail);
        final phoneController = TextEditingController(text: staffPhone);
        final positionController = TextEditingController(text: staffPosition);

        return AlertDialog(
          title: const Text(
            "Chỉnh sửa thông tin",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: StaffTheme.staffPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Họ và tên"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Số điện thoại"),
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: "Chức vụ"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffTheme.staffPrimary,
              ),
              onPressed: () {
                setState(() {
                  staffName = nameController.text;
                  staffEmail = emailController.text;
                  staffPhone = phoneController.text;
                  staffPosition = positionController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: StaffTheme.staffPrimary),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontFamily: "Quicksand", fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildStaffMenu(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: StaffTheme.staffPrimary.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: StaffTheme.staffPrimary, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffTheme.staffBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: StaffTheme.staffPrimary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: Stack(
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
                                size: 60,
                                color: StaffTheme.staffAccent,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            backgroundColor: StaffTheme.staffAccent,
                            radius: 20,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            Text(
              staffName,
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              staffPosition,
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoCard("Email", staffEmail, Icons.email),
                  _buildInfoCard("Số điện thoại", staffPhone, Icons.phone),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffTheme.staffPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(fontFamily: "Quicksand"),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chức năng Staff",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: [
                      _buildStaffMenu("Quản lý trại hè", Icons.campaign, () {}),
                      _buildStaffMenu("Điểm danh", Icons.check_circle, () {}),
                      _buildStaffMenu(
                        "Báo cáo sự cố",
                        Icons.report_problem,
                        () {},
                      ),
                      _buildStaffMenu("Quản lý camper", Icons.group, () {}),
                      _buildStaffMenu("Thống kê", Icons.bar_chart, () {}),
                      _buildStaffMenu("Tin nhắn", Icons.message, () {}),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(fontFamily: "Quicksand", fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
