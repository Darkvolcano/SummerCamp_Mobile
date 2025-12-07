import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/widgets/driver_bottom_nav_bar.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().loadDriverSchedules();
    });
  }

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

  TransportSchedule? _findNextTrip(List<TransportSchedule> schedules) {
    final now = DateTime.now();

    final validTrips = schedules.where((trip) {
      // Điều kiện 1: Chưa hoàn thành (chưa có actualEndTime)
      // Hoặc kiểm tra theo status != Completed nếu muốn
      final bool isNotCompleted =
          (trip.actualEndTime == null || trip.actualEndTime!.isEmpty);

      // Điều kiện 2: Thời gian phải ở tương lai hoặc đang diễn ra
      // (EndTime chưa qua quá khứ)
      final endTime =
          DateTime.tryParse("${trip.date}T${trip.endTime}") ?? DateTime(2100);
      final bool isInFutureOrPresent = endTime.isAfter(now);

      return isNotCompleted && isInFutureOrPresent;
    }).toList();

    if (validTrips.isEmpty) return null;

    // 2. Sắp xếp theo ưu tiên: Date -> StartTime -> EndTime
    validTrips.sort((a, b) {
      final dateA = DateTime.tryParse(a.date) ?? DateTime(2100);
      final dateB = DateTime.tryParse(b.date) ?? DateTime(2100);
      int dateCompare = dateA.compareTo(dateB);
      if (dateCompare != 0) return dateCompare;

      final startA =
          DateTime.tryParse("${a.date}T${a.startTime}") ?? DateTime(2100);
      final startB =
          DateTime.tryParse("${b.date}T${b.startTime}") ?? DateTime(2100);
      int startCompare = startA.compareTo(startB);
      if (startCompare != 0) return startCompare;

      final endA =
          DateTime.tryParse("${a.date}T${a.endTime}") ?? DateTime(2100);
      final endB =
          DateTime.tryParse("${b.date}T${b.endTime}") ?? DateTime(2100);
      return endA.compareTo(endB);
    });

    // 3. Lấy chuyến đầu tiên
    return validTrips.first;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final scheduleProvider = context.watch<ScheduleProvider>();

    String userName = "Tài xế";
    if (user != null &&
        '${user.firstName} ${user.lastName}'.trim().isNotEmpty) {
      userName = '${user.firstName} ${user.lastName}'.trim();
    }

    final avatarUrl = user?.avatar;
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    final nextTrip = _findNextTrip(scheduleProvider.transportSchedules);

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
                    'Xin chào, $userName ',
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
          if (scheduleProvider.loading)
            const Center(
              child: CircularProgressIndicator(
                color: DriverTheme.driverPrimary,
              ),
            )
          else if (nextTrip != null)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today,
                      title: "Ngày",
                      content: DateFormatter.formatFromString(nextTrip.date),
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      icon: Icons.access_time_filled,
                      title: "Thời gian",
                      // Format lại startTime và endTime cho đẹp
                      content:
                          "${DateFormatter.formatTime(DateTime.parse("${nextTrip.date}T${nextTrip.startTime}"))} - ${DateFormatter.formatTime(DateTime.parse("${nextTrip.date}T${nextTrip.endTime}"))}",
                      color: DriverTheme.driverAccent,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.route, // Icon tuyến đường
                      title: "Tuyến đường",
                      content: nextTrip.routeName.routeName, // Lấy tên tuyến
                      color: DriverTheme.driverPrimary,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.directions_bus, // Icon xe
                      title: "Xe",
                      content: nextTrip.vehicleName.vehicleName, // Lấy tên xe
                      color: DriverTheme.driverPrimary,
                    ),
                  ],
                ),
              ),
            )
          else
            // Trường hợp không có chuyến đi nào
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    "Không có chuyến đi sắp tới",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      color: Colors.grey[600],
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
