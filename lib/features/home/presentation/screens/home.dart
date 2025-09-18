import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_bottom_nav_bar.dart';
import 'package:summercamp/core/widgets/custom_carousel_slider.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_list_screen.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';

import 'package:summercamp/features/ai_chat/presentation/screens/ai_chat_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    CampListScreen(),
    AIChatScreen(),
    RegistrationListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=12",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Xin chào, Phụ huynh 👋\nHãy cùng khám phá trại hè hôm nay!",
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          CustomCarousel(
            images: const [
              "https://picsum.photos/800/300?summer1",
              "https://picsum.photos/800/300?summer2",
              "https://picsum.photos/800/300?summer3",
            ],
          ),
          const SizedBox(height: 20),

          // Quick actions grid
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: GridView.count(
          //     shrinkWrap: true,
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 16,
          //     crossAxisSpacing: 16,
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [
          //       _buildMenuCard(
          //         context,
          //         icon: Icons.cabin,
          //         label: "Danh sách trại hè",
          //         color: AppTheme.summerPrimary,
          //         page: const CampListScreen(),
          //       ),
          //       _buildMenuCard(
          //         context,
          //         icon: Icons.assignment,
          //         label: "Đăng ký của tôi",
          //         color: AppTheme.summerBlue,
          //         page: const RegistrationListScreen(),
          //       ),
          //       _buildMenuCard(
          //         context,
          //         icon: Icons.chat_bubble,
          //         label: "Chat AI",
          //         color: Colors.greenAccent.shade400,
          //         page: const AIChatScreen(),
          //       ),
          //       _buildMenuCard(
          //         context,
          //         icon: Icons.person,
          //         label: "Hồ sơ",
          //         color: Colors.pinkAccent,
          //         page: const ProfileScreen(),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trại hè nổi bật",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final homeState = context
                        .findAncestorStateOfType<_HomeState>();
                    homeState?._onItemTapped(1);
                  },
                  child: Text(
                    "Xem tất cả",
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: "Nunito",
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, idx) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          "https://picsum.photos/200/120?random=$idx",
                          width: 160,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Camp Adventure #$idx",
                          style: textTheme.bodyLarge?.copyWith(
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Khám phá – Học hỏi – Vui chơi",
                          style: textTheme.bodySmall?.copyWith(
                            fontFamily: "Nunito",
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.summerAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.assignment),
              label: Text(
                "Đăng ký ngay cho bé",
                style: textTheme.titleMedium?.copyWith(
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildMenuCard(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  //   required Widget page,
  // }) {
  //   final textTheme = Theme.of(context).textTheme;
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: color.withValues(alpha: 0.15),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             backgroundColor: color,
  //             child: Icon(icon, color: Colors.white),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             label,
  //             textAlign: TextAlign.center,
  //             style: textTheme.bodyMedium?.copyWith(
  //               fontFamily: "Nunito",
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
