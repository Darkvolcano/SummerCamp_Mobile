// import 'package:flutter/material.dart';
// import 'package:summercamp/core/config/app_routes.dart';
// import 'package:summercamp/core/config/app_theme.dart';
// import 'package:summercamp/core/widgets/custom_bottom_nav_bar.dart';
// import 'package:summercamp/core/widgets/custom_carousel_slider.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeContent(),
//     const _RouteWrapper(AppRoutes.campList),
//     Container(),
//     const _RouteWrapper(AppRoutes.blogList),
//     const _RouteWrapper(AppRoutes.profile),
//   ];

//   void _onItemTapped(int index) {
//     if (index == 2) {
//       Navigator.pushNamed(context, AppRoutes.chatAI);
//       return;
//     }

//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: _pages[_selectedIndex]),
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }

// class HomeContent extends StatelessWidget {
//   const HomeContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                     "https://i.pravatar.cc/150?img=12",
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Xin chào, Phụ huynh 👋\nHãy cùng khám phá trại hè hôm nay!",
//                     style: textTheme.bodyMedium?.copyWith(
//                       fontFamily: "Quicksand",
//                       fontWeight: FontWeight.w600,
//                       color: colorScheme.onSurface,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           CustomCarousel(
//             images: const [
//               "https://picsum.photos/800/300?summer1",
//               "https://picsum.photos/800/300?summer2",
//               "https://picsum.photos/800/300?summer3",
//             ],
//           ),
//           const SizedBox(height: 20),

//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 16),
//           //   child: GridView.count(
//           //     shrinkWrap: true,
//           //     crossAxisCount: 2,
//           //     mainAxisSpacing: 16,
//           //     crossAxisSpacing: 16,
//           //     physics: const NeverScrollableScrollPhysics(),
//           //     children: [
//           //       _buildMenuCard(
//           //         context,
//           //         icon: Icons.cabin,
//           //         label: "Danh sách trại hè",
//           //         color: AppTheme.summerPrimary,
//           //         page: const CampListScreen(),
//           //       ),
//           //       _buildMenuCard(
//           //         context,
//           //         icon: Icons.assignment,
//           //         label: "Đăng ký của tôi",
//           //         color: AppTheme.summerBlue,
//           //         page: const RegistrationListScreen(),
//           //       ),
//           //       _buildMenuCard(
//           //         context,
//           //         icon: Icons.chat_bubble,
//           //         label: "Chat AI",
//           //         color: Colors.greenAccent.shade400,
//           //         page: const AIChatScreen(),
//           //       ),
//           //       _buildMenuCard(
//           //         context,
//           //         icon: Icons.person,
//           //         label: "Hồ sơ",
//           //         color: Colors.pinkAccent,
//           //         page: const ProfileScreen(),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           // const SizedBox(height: 24),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Trại hè nổi bật",
//                   style: textTheme.titleMedium?.copyWith(
//                     fontFamily: "Quicksand",
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onSurface,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     final homeState = context
//                         .findAncestorStateOfType<_HomeState>();
//                     homeState?._onItemTapped(1);
//                   },
//                   child: Text(
//                     "Xem tất cả",
//                     style: textTheme.bodyMedium?.copyWith(
//                       fontFamily: "Quicksand",
//                       color: colorScheme.primary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 200,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: 5,
//               itemBuilder: (context, idx) {
//                 return Container(
//                   width: 160,
//                   margin: const EdgeInsets.only(right: 16),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardTheme.color,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.08),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(16),
//                         ),
//                         child: Image.network(
//                           "https://picsum.photos/200/120?random=$idx",
//                           width: 160,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Camp Adventure #$idx",
//                           style: textTheme.bodyLarge?.copyWith(
//                             fontFamily: "Quicksand",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(
//                           "Khám phá – Học hỏi – Vui chơi",
//                           style: textTheme.bodySmall?.copyWith(
//                             fontFamily: "Quicksand",
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 24),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.summerAccent,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, AppRoutes.campList);
//               },
//               icon: const Icon(Icons.assignment),
//               label: Text(
//                 "Đăng ký ngay cho bé",
//                 style: textTheme.titleMedium?.copyWith(
//                   fontFamily: "Quicksand",
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildMenuCard(
//   //   BuildContext context, {
//   //   required IconData icon,
//   //   required String label,
//   //   required Color color,
//   //   required Widget page,
//   // }) {
//   //   final textTheme = Theme.of(context).textTheme;
//   //   return GestureDetector(
//   //     onTap: () {
//   //       Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   //     },
//   //     child: Container(
//   //       decoration: BoxDecoration(
//   //         color: color.withValues(alpha: 0.15),
//   //         borderRadius: BorderRadius.circular(16),
//   //       ),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           CircleAvatar(
//   //             backgroundColor: color,
//   //             child: Icon(icon, color: Colors.white),
//   //           ),
//   //           const SizedBox(height: 8),
//   //           Text(
//   //             label,
//   //             textAlign: TextAlign.center,
//   //             style: textTheme.bodyMedium?.copyWith(
//   //               fontFamily: "Quicksand",
//   //               fontWeight: FontWeight.w600,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class _RouteWrapper extends StatelessWidget {
//   final String routeName;
//   const _RouteWrapper(this.routeName);

//   @override
//   Widget build(BuildContext context) {
//     final settings = RouteSettings(name: routeName);
//     final route = AppRoutes.generateRoute(settings);

//     if (route is MaterialPageRoute) {
//       return route.builder(context);
//     } else {
//       return const Scaffold(body: Center(child: Text("Route not found")));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const _RouteWrapper(AppRoutes.campList),
    Container(),
    const _RouteWrapper(AppRoutes.blogList),
    const _RouteWrapper(AppRoutes.profile),
  ];

  void onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.chatAI);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        "image":
            "https://res.cloudinary.com/da9zmbssb/image/upload/v1760070571/act_treasure_eujrrv.jpg",
        "title": "Truy tìm kho báu",
      },
      {
        "image":
            "https://res.cloudinary.com/da9zmbssb/image/upload/v1760070863/act_obsticle_hajyc3.jpg",
        "title": "Vượt chướng ngại vật",
      },
      {
        "image":
            "https://res.cloudinary.com/da9zmbssb/image/upload/v1760070617/act_folk_game_cn8d7z.jpg",
        "title": "Trò chơi dân gian",
      },
      {
        "image":
            "https://res.cloudinary.com/da9zmbssb/image/upload/v1760070572/act_survive_g1iga1.jpg",
        "title": "Kỹ năng sinh tồn",
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://res.cloudinary.com/da9zmbssb/image/upload/v1760079496/GroupLearn_a1codk.jpg",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black38,
                      BlendMode.darken,
                    ),
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppTheme.summerAccent,
                            AppTheme.summerYellow,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          "Khám phá, học hỏi và kết bạn",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "trong môi trường trại hè an toàn và sáng tạo.",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.campSearch,
                              );
                            },
                            child: const Text(
                              "Tìm kiếm trại hè, địa điểm...",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const Icon(
                          Icons.filter_list,
                          color: AppTheme.summerPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 60),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildActionItem(context, Icons.explore, "Khám Phá", () {}),
              _buildActionItem(context, Icons.sports_soccer, "Thể Thao", () {}),
              _buildActionItem(context, Icons.palette, "Nghệ Thuật", () {}),
              _buildActionItem(context, Icons.science, "Khoa Học", () {}),
            ],
          ),

          SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hoạt động nổi bật",
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.findAncestorStateOfType<_HomeState>()?.onItemTapped(
                      1,
                    );
                  },
                  child: const Text(
                    "Xem tất cả",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: AppTheme.summerAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(activity["image"]!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        activity["title"]!,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24),

          Container(
            color: AppTheme.summerPrimary.withValues(alpha: 0.05),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phụ huynh nói gì?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .findAncestorStateOfType<_HomeState>()
                              ?.onItemTapped(1);
                        },
                        child: const Text(
                          "Xem tất cả",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            color: AppTheme.summerAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: AppTheme.summerYellow,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '"Con tôi đã có những trải nghiệm tuyệt vời. Các hoạt động rất bổ ích và đội ngũ huấn luyện viên rất tận tâm."',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppTheme.summerAccent,
                              child: Text(
                                "M",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nguyễn Thị Mai",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Phụ huynh",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.summerAccent, AppTheme.summerPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "Sẵn sàng cho mùa hè tuyệt vời?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Đăng ký ngay để con bạn có cơ hội trải nghiệm những hoạt động bổ ích và thú vị trong mùa hè này!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context
                      .findAncestorStateOfType<_HomeState>()
                      ?.onItemTapped(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.summerPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Khám phá các trại hè",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.summerPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.summerPrimary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
