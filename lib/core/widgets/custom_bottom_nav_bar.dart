import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 91, // cao hơn để chứa bubble
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Thanh bar chính
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, "Home", 0),
                  _buildNavItem(Icons.terrain, "Camp", 1),
                  // Transform.translate(
                  //   offset: const Offset(0, -50),
                  //   child: GestureDetector(
                  //     onTap: () => onItemTapped(2),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Container(
                  //           padding: const EdgeInsets.all(
                  //             6,
                  //           ), // khoảng cách để tạo nền bao quanh
                  //           decoration: BoxDecoration(
                  //             color:
                  //                 Theme.of(context).bottomAppBarTheme.color ??
                  //                 Colors.teal,
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: Container(
                  //             width: 53,
                  //             height: 53,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: const Color(0xFFA05A2C),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Colors.black.withOpacity(0.25),
                  //                   blurRadius: 8,
                  //                   offset: const Offset(0, 4),
                  //                 ),
                  //               ],
                  //             ),
                  //             child: const Icon(
                  //               Icons.smart_toy,
                  //               color: Colors.white,
                  //               size: 30,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 4),
                  //         Text(
                  //           "AI Chat",
                  //           style: TextStyle(
                  //             fontSize: 12,
                  //             color: currentIndex == 2
                  //                 ? const Color(0xFFA05A2C)
                  //                 : Colors.grey,
                  //             fontWeight: currentIndex == 2
                  //                 ? FontWeight.bold
                  //                 : FontWeight.normal,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 60),
                  _buildNavItem(Icons.assignment, "Register", 3),
                  _buildNavItem(Icons.person, "Profile", 4),
                ],
              ),
            ),
          ),

          // Bubble AI Chat
          Positioned(
            top: -36,
            left: MediaQuery.of(context).size.width / 2 - 37,
            child: GestureDetector(
              onTap: () => onItemTapped(2),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      6,
                    ), // khoảng cách để tạo nền bao quanh
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).bottomAppBarTheme.color ??
                          Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFA05A2C),
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
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "AI Chat",
                    style: TextStyle(
                      fontSize: 12,
                      color: currentIndex == 2
                          ? const Color(0xFFA05A2C)
                          : Colors.grey,
                      fontWeight: currentIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min, // quan trọng, để Column co lại
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24, // giảm chút để an toàn
              color: isSelected ? const Color(0xFFA05A2C) : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12, // giảm 1 chút tránh tràn
                color: isSelected ? const Color(0xFFA05A2C) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
