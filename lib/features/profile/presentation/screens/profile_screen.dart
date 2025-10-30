import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;
  File? _profileImage;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
    final authProvider = context.read<AuthProvider>();
    if (!_isFetching) {
      setState(() {
        _isFetching = true;
      });
      try {
        await authProvider.fetchProfileUser();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi tải thông tin: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isFetching = false;
          });
        }
      }
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        final user = context.read<AuthProvider>().user;
        if (user != null) {
          _nameController.text = '${user.firstName} ${user.lastName}'.trim();
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber;
        }
      }
    });
  }

  void _saveProfile() {
    // Gọi API cập nhật profile ở đây
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
    final authProvider = context.watch<AuthProvider>();

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
          if (authProvider.user != null && !authProvider.isLoading)
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
      body: _buildBody(authProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider) {
    if (_isFetching || authProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.summerPrimary),
      );
    }

    if (authProvider.error != null && authProvider.user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                'Lỗi tải thông tin người dùng',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontFamily: "Quicksand"),
              ),
              const SizedBox(height: 10),
              Text(
                authProvider.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                onPressed: _fetchUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.summerAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (authProvider.user != null) {
      return _buildLoggedInView(authProvider.user!);
    } else {
      return _buildLoggedOutView(context);
    }
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "Bạn chưa đăng nhập",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Vui lòng đăng nhập hoặc đăng ký để quản lý thông tin.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: "Quicksand",
                color: Colors.grey.shade600,
              ),
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
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text(
                "Đăng nhập",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.summerPrimary),
                foregroundColor: AppTheme.summerPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: const Text(
                "Tạo tài khoản",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInView(User user) {
    if (!_isEditing) {
      _nameController.text = '${user.firstName} ${user.lastName}'.trim();
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
    }

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        _buildProfileHeader(user),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(user),
              const SizedBox(height: 20),
              _buildMenuSection(),
              const SizedBox(height: 20),
              _buildLogoutButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    String displayName = _isEditing
        ? _nameController.text
        : '${user.firstName} ${user.lastName}'.trim();
    String displayEmail = _isEditing ? _emailController.text : user.email;

    return Container(
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
                    : (user.avatar != null && user.avatar!.isNotEmpty
                              ? NetworkImage(user.avatar!)
                              : null)
                          as ImageProvider?,
                child:
                    (_profileImage == null &&
                        (user.avatar == null || user.avatar!.isEmpty))
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
            displayName.isEmpty ? "Người dùng" : displayName,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            displayEmail,
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(User user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              isAlwaysReadOnly: true,
            ),
            const SizedBox(height: 15),
            _buildProfileField(
              "Số điện thoại",
              _phoneController,
              Icons.phone_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
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
          () => Navigator.pushNamed(context, AppRoutes.registrationList),
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
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: "Quicksand",
        ),
        prefixIcon: Icon(icon, color: AppTheme.summerAccent),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.summerPrimary),
        ),
        filled: !_isEditing,
        fillColor: Colors.grey.shade100.withValues(alpha: 0.5),
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
            color: Colors.black87,
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

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade700,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }
}
