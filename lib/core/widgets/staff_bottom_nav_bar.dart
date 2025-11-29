import 'package:flutter/material.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class StaffBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const StaffBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF42A5F5);
    const Color inactiveColor = Colors.white70;

    return SizedBox(
      height: 70,
      child: BottomAppBar(
        color: StaffTheme.staffPrimary,
        child: SizedBox(
          height: 56,
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  Icons.home,
                  "trang chủ",
                  0,
                  activeColor,
                  inactiveColor,
                ),
                _buildNavItem(
                  Icons.schedule,
                  "Lịch làm",
                  1,
                  activeColor,
                  inactiveColor,
                ),
                // _buildNavItem(
                //   Icons.report_problem,
                //   "Incident",
                //   2,
                //   activeColor,
                //   inactiveColor,
                // ),
                _buildNavItem(
                  Icons.person,
                  "Cá nhân",
                  2,
                  activeColor,
                  inactiveColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 12,
                height: 1.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
