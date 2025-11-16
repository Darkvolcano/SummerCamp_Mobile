import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/core/widgets/driver_bottom_nav_bar.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DriverHomeContent(),
    const _RouteWrapper(AppRoutes.driverSchedule),
    const _RouteWrapper(AppRoutes.driverProfile),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: DriverBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _DriverHomeContent extends StatelessWidget {
  const _DriverHomeContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    String userName = "Tài xế";
    if (user != null &&
        '${user.firstName} ${user.lastName}'.trim().isNotEmpty) {
      userName = '${user.firstName} ${user.lastName}'.trim();
    }

    final avatarUrl = user?.avatar;
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                backgroundColor: Colors.grey.shade200,
                child: !hasAvatar
                    ? const Icon(
                        Icons.person,
                        size: 30,
                        color: DriverTheme.driverPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, $userName 👋',
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Chúc bạn một ngày làm việc an toàn!",
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: "Quicksand",
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            "Chuyến đi tiếp theo",
            style: textTheme.titleLarge?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: DriverTheme.driverPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time_filled,
                    title: "Thời gian",
                    content: "08:00 - 09:00 (Hôm nay)",
                    color: DriverTheme.driverAccent,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    context,
                    icon: Icons.pin_drop_rounded,
                    title: "Nhiệm vụ",
                    content: "Đón camper tại Quận 1",
                    color: DriverTheme.driverPrimary,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    icon: Icons.flag_rounded,
                    title: "Điểm đến",
                    content: "Khu sinh thái FPT Campus",
                    color: DriverTheme.driverPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteWrapper extends StatelessWidget {
  final String routeName;
  const _RouteWrapper(this.routeName);

  @override
  Widget build(BuildContext context) {
    final settings = RouteSettings(name: routeName);
    final route = AppRoutes.generateRoute(settings);

    if (route is MaterialPageRoute) {
      return route.builder(context);
    } else {
      return const Scaffold(body: Center(child: Text("Route not found")));
    }
  }
}
