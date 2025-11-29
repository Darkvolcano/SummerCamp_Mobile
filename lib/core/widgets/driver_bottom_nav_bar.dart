import 'package:flutter/material.dart';
import 'package:summercamp/core/config/driver_theme.dart';

class DriverBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const DriverBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.white;
    const Color inactiveColor = Colors.white70;

    return SizedBox(
      height: 70,
      child: BottomAppBar(
        color: DriverTheme.driverPrimary,
        child: SizedBox(
          height: 56,
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  Icons.home_filled,
                  "Trang chủ",
                  0,
                  activeColor,
                  inactiveColor,
                ),
                _buildNavItem(
                  Icons.list_alt_rounded,
                  "Lịch làm",
                  1,
                  activeColor,
                  inactiveColor,
                ),
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
      behavior: HitTestBehavior.opaque,
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
