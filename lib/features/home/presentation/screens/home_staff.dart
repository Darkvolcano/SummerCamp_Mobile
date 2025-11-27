import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/widgets/staff_bottom_nav_bar.dart';
import 'package:summercamp/features/home/presentation/widgets/schedule_calendar.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StaffHomeContent(),
    const _RouteWrapper(AppRoutes.staffSchedule),
    // const _RouteWrapper(AppRoutes.report),
    const _RouteWrapper(AppRoutes.staffProfile),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: StaffBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class StaffHomeContent extends StatefulWidget {
  const StaffHomeContent({super.key});

  @override
  State<StaffHomeContent> createState() => _StaffHomeContentState();
}

class _StaffHomeContentState extends State<StaffHomeContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ScheduleProvider>();
      if (provider.schedules.isEmpty) {
        provider.loadSchedules();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<ScheduleProvider>();
    final schedules = provider.schedules;

    final upcomingCamps = schedules
        .where(
          (s) =>
              s.status == CampStatus.InProgress ||
              s.status == CampStatus.OpenForRegistration,
        )
        .take(3)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [StaffTheme.staffPrimary, StaffTheme.staffAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.badge, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Chào mừng bạn trở lại!\nHãy quản lý trại hiệu quả nào 🚀",
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "Camps đang & sắp diễn ra",
            style: textTheme.titleMedium?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: StaffTheme.staffPrimary,
            ),
          ),
          const SizedBox(height: 12),

          if (provider.loading)
            const Center(child: CircularProgressIndicator())
          else if (upcomingCamps.isEmpty)
            const Text(
              "Không có trại hè nào sắp tới.",
              style: TextStyle(fontFamily: "Quicksand"),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingCamps.length,
              itemBuilder: (context, index) {
                final camp = upcomingCamps[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.staffScheduleDetail,
                        arguments: camp,
                      );
                    },
                    // leading: CircleAvatar(
                    //   backgroundColor: StaffTheme.staffAccent,
                    //   backgroundImage: camp.image.isNotEmpty
                    //       ? NetworkImage(camp.image)
                    //       : null,
                    //   child: camp.image.isEmpty
                    //       ? const Icon(Icons.terrain, color: Colors.white)
                    //       : null,
                    // ),
                    title: Text(
                      camp.name,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${DateFormatter.formatFromString(camp.startDate)} - ${DateFormatter.formatFromString(camp.endDate)}\n${camp.place}",
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 12,
                      ),
                    ),
                    trailing: _buildStatusChip(camp.status),
                  ),
                );
              },
            ),

          const SizedBox(height: 20),

          Text(
            "Lịch làm việc",
            style: textTheme.titleMedium?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: StaffTheme.staffPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ScheduleCalendar(schedules: schedules),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusChip(CampStatus status) {
    Color color;
    String text;
    switch (status) {
      case CampStatus.InProgress:
        color = Colors.green;
        text = "Đang diễn ra";
        break;
      case CampStatus.OpenForRegistration:
        color = Colors.blue;
        text = "Mở đăng ký";
        break;
      case CampStatus.Completed:
        color = Colors.grey;
        text = "Kết thúc";
        break;
      default:
        color = Colors.orange;
        text = "Sắp tới";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: "Quicksand",
        ),
      ),
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
