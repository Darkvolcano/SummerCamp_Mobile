import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:summercamp/features/auth/presentation/widgets/change_password_dialog.dart';
import 'package:summercamp/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        if (mounted) {}
      } finally {
        if (mounted) {
          setState(() {
            _isFetching = false;
          });
        }
      }
    }
  }

  Future<void> _navigateToEditProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: authProvider.user!),
      ),
    );

    if (result == true) {
      _fetchUserData();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            // color: Colors.white,
            color: AppTheme.summerPrimary,
          ),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.9),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          if (authProvider.user != null && !authProvider.isLoading)
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: AppTheme.summerPrimary,
              ),
              onPressed: _navigateToEditProfile,
            ),
        ],
      ),
      body: _buildBody(authProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider) {
    if (_isFetching || (authProvider.isLoading && authProvider.user == null)) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.summerPrimary),
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
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        _buildProfileHeader(user),
        Container(
          color: Color(0xFFF5F7F8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
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
        ),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    String displayName = '${user.firstName} ${user.lastName}'.trim();
    String? displayEmail = user.email;

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
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage:
                    (user.avatar != null && user.avatar!.isNotEmpty)
                    ? NetworkImage(user.avatar!)
                    : null,
                child: (user.avatar == null || user.avatar!.isEmpty)
                    ? const Icon(
                        Icons.person,
                        size: 70,
                        color: AppTheme.summerPrimary,
                      )
                    : null,
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
            displayEmail!,
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.summerAccent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "Chưa cập nhật" : value,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(User user) {
    String dobFormatted = "Chưa cập nhật";
    if (user.dateOfBirth != null && user.dateOfBirth != "0001-01-01") {
      try {
        dobFormatted = DateFormat(
          'dd/MM/yyyy',
        ).format(DateFormat('yyyy-MM-dd').parse(user.dateOfBirth!));
      } catch (e) {
        dobFormatted = user.dateOfBirth!;
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Thông tin cá nhân",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            _buildInfoRow(
              "Họ và tên",
              '${user.firstName} ${user.lastName}'.trim(),
              Icons.person_outline,
            ),
            _buildInfoRow("Email", user.email!, Icons.email_outlined),
            _buildInfoRow(
              "Số điện thoại",
              user.phoneNumber,
              Icons.phone_outlined,
            ),
            _buildInfoRow(
              "Ngày sinh",
              dobFormatted,
              Icons.calendar_today_outlined,
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
        _buildProfileMenuItem("Thay đổi mật khẩu", Icons.lock_outline, () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ChangePasswordDialog(),
          );
        }),
        _buildProfileMenuItem(
          "Về ứng dụng",
          Icons.confirmation_number_outlined,
          () => _showMessageBox(
            "Chức năng",
            "Chức năng này chưa được triển khai.",
          ),
        ),
      ],
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
