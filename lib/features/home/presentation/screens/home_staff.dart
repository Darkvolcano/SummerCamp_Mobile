import 'package:flutter/material.dart';
import 'package:summercamp/core/widgets/custom_bottom_nav_bar_staff.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_schedule_screen.dart';
import 'package:summercamp/features/home/presentation/widgets/schedule_calendar.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_staff_screen.dart';
import 'package:summercamp/features/report/presentation/screens/report_list_screen.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StaffHomeContent(),
    const CampScheduleScreen(),
    const ReportListScreen(),
    const StaffProfileScreen(),
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

class StaffHomeContent extends StatelessWidget {
  const StaffHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
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

          // Text(
          //   "Chức năng nhanh",
          //   style: textTheme.titleMedium?.copyWith(
          //     fontFamily: "Quicksand",
          //     fontWeight: FontWeight.bold,
          //     color: StaffTheme.staffPrimary,
          //   ),
          // ),
          // const SizedBox(height: 12),
          // GridView.count(
          //   physics: const NeverScrollableScrollPhysics(),
          //   shrinkWrap: true,
          //   crossAxisCount: 2,
          //   mainAxisSpacing: 12,
          //   crossAxisSpacing: 12,
          //   childAspectRatio: 1.1,
          //   children: [
          //     _buildQuickAction(
          //       context,
          //       icon: Icons.cabin,
          //       label: "Camp quản lý",
          //       color: Colors.blue.shade100,
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => const CampScheduleScreen(),
          //           ),
          //         );
          //       },
          //     ),
          //     _buildQuickAction(
          //       context,
          //       icon: Icons.schedule,
          //       label: "Lịch trình",
          //       color: Colors.orange.shade100,
          //       onTap: () {},
          //     ),
          //     _buildQuickAction(
          //       context,
          //       icon: Icons.report_problem,
          //       label: "Sự cố",
          //       color: Colors.red.shade100,
          //       onTap: () {},
          //     ),
          //     _buildQuickAction(
          //       context,
          //       icon: Icons.checklist,
          //       label: "Điểm danh",
          //       color: Colors.green.shade100,
          //       onTap: () {},
          //     ),
          //   ],
          // ),

          // const SizedBox(height: 20),
          Text(
            "Camps sắp diễn ra",
            style: textTheme.titleMedium?.copyWith(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              color: StaffTheme.staffPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: StaffTheme.staffAccent,
                child: const Icon(Icons.terrain, color: Colors.white),
              ),
              title: const Text("Summer Camp 2025"),
              subtitle: const Text("20/09/2025 - 25/09/2025\nĐà Lạt"),
              trailing: Chip(
                label: const Text("Sắp diễn ra"),
                backgroundColor: Colors.green.shade100,
                labelStyle: const TextStyle(color: Colors.green),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: StaffTheme.staffAccent,
                child: const Icon(Icons.terrain, color: Colors.white),
              ),
              title: const Text("Adventure Camp"),
              subtitle: const Text("05/10/2025 - 12/10/2025\nPhan Thiết"),
              trailing: Chip(
                label: const Text("Sắp diễn ra"),
                backgroundColor: Colors.green.shade100,
                labelStyle: const TextStyle(color: Colors.green),
              ),
            ),
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
            height: 500,
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
            child: const ScheduleCalendar(),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickAction(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(16),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(icon, size: 36, color: StaffTheme.staffPrimary),
  //           const SizedBox(height: 10),
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               fontFamily: "Quicksand",
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
