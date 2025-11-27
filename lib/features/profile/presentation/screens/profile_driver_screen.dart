import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/profile/presentation/screens/edit_profile_driver_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  bool _isFetching = false;
  File? _profileImage;
  // final ImagePicker _picker = ImagePicker();

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

  Future<void> _navigateToEditProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileDriverScreen(user: authProvider.user!),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng xuất thất bại: ${e.toString()}")),
        );
      }
    }
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _profileImage = File(pickedFile.path));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: DriverTheme.driverBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tài khoản Tài xế",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: DriverTheme.driverPrimary,
        actions: [
          if (authProvider.user != null)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: _navigateToEditProfile,
            ),
        ],
        elevation: 0,
      ),
      body: _buildBody(authProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider) {
    if (_isFetching || (authProvider.isLoading && authProvider.user == null)) {
      return const Center(
        child: CircularProgressIndicator(color: DriverTheme.driverPrimary),
      );
    }

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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                onPressed: _fetchUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DriverTheme.driverAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (authProvider.user == null) {
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
                  color: DriverTheme.driverPrimary,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DriverTheme.driverAccent,
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
            ],
          ),
        ),
      );
    }
    final String staffPosition = user.role ?? "Driver";
    final String? avatarUrl = user.avatar;
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: DriverTheme.driverPrimary,
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
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (hasAvatar ? NetworkImage(avatarUrl) : null)
                                as ImageProvider?,
                      child: (_profileImage == null && !hasAvatar)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: DriverTheme.driverAccent,
                            )
                          : null,
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: InkWell(
                    //     onTap: _pickImage,
                    //     child: const CircleAvatar(
                    //       backgroundColor: DriverTheme.driverAccent,
                    //       radius: 20,
                    //       child: Icon(
                    //         Icons.camera_alt,
                    //         color: Colors.white,
                    //         size: 18,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Text(
            staffName.isEmpty ? "Tài xế" : staffName,
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: DriverTheme.driverPrimary),
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
}
