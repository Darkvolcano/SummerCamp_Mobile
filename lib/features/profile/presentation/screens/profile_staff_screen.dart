import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/profile/presentation/screens/edit_profile_staff_screen.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
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
          showCustomDialog(
            context,
            title: "Lỗi",
            message: "Lỗi tải thông tin: ${e.toString()}",
            type: DialogType.error,
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

  Future<void> _navigateToEditProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileStaffScreen(user: authProvider.user!),
      ),
    );

    if (result == true) {
      _fetchUserData();
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
        showCustomDialog(
          context,
          title: "Lỗi",
          message: "Đăng xuất thất bại: ${e.toString()}",
          type: DialogType.error,
        );
      }
    }
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
          value.isEmpty ? "Chưa cập nhật" : value,
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 13,
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
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: StaffTheme.staffBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: StaffTheme.staffPrimary,
        elevation: 0,
      ),
      body: _buildBody(authProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider) {
    final user = authProvider.user!;
    final String staffName = '${user.firstName} ${user.lastName}'.trim();
    final String? staffEmail = user.email;
    final String staffPhone = user.phoneNumber;
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: StaffTheme.staffPrimary,
                  borderRadius: BorderRadius.only(
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
                      backgroundImage:
                          (user.avatar != null && user.avatar!.isNotEmpty)
                          ? NetworkImage(user.avatar!)
                          : null,
                      child: (user.avatar == null || user.avatar!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: StaffTheme.staffPrimary,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Text(
            staffName.isEmpty ? "Staff" : staffName,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildInfoCard("Email", staffEmail!, Icons.email),
                _buildInfoCard("Số điện thoại", staffPhone, Icons.phone),
                _buildInfoCard(
                  "Ngày sinh",
                  dobFormatted,
                  Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _navigateToEditProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: StaffTheme.staffPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit, size: 20),
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
                    _buildStaffMenu("Quản lý trại hè", Icons.campaign, () {
                      Navigator.pushNamed(context, AppRoutes.staffSchedule);
                    }),
                    _buildStaffMenu("Điểm danh", Icons.check_circle, () {}),
                    _buildStaffMenu("Báo cáo sự cố", Icons.report_problem, () {
                      Navigator.pushNamed(context, AppRoutes.report);
                    }),
                    // _buildStaffMenu("Quản lý camper", Icons.group, () {
                    //   Navigator.pushNamed(context, AppRoutes.camperList);
                    // }),
                    // _buildStaffMenu("Thống kê", Icons.bar_chart, () {}),
                    // _buildStaffMenu("Tin nhắn", Icons.message, () {}),
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
              onPressed: _handleLogout,
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
    );
  }
}
