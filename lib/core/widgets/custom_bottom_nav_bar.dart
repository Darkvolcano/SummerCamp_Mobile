import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppTheme.summerAccent;
    const Color inactiveColor = Colors.white70;

    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            color: AppTheme.summerPrimary,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: SizedBox(
              height: 56,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      Icons.home,
                      "Home",
                      0,
                      activeColor,
                      inactiveColor,
                    ),
                    _buildNavItem(
                      Icons.terrain,
                      "Camp",
                      1,
                      activeColor,
                      inactiveColor,
                    ),
                    const SizedBox(width: 50),
                    _buildNavItem(
                      Icons.event_note,
                      "Blog",
                      3,
                      activeColor,
                      inactiveColor,
                    ),
                    _buildNavItem(
                      Icons.person,
                      "Profile",
                      4,
                      activeColor,
                      inactiveColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -37,
            left: MediaQuery.of(context).size.width / 2 - 42,
            child: GestureDetector(
              onTap: () => onItemTapped(2),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.summerPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.summerAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Text(
                    "AI Chat",
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 12,
                      fontWeight: currentIndex == 2
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: currentIndex == 2 ? activeColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                fontFamily: "Nunito",
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
