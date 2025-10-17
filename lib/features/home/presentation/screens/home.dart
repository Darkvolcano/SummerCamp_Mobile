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
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_bottom_nav_bar.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

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
      backgroundColor: AppTheme.summerBackground,
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildHeroSection(context),
          const SizedBox(height: 24),
          _buildQuickActionsGrid(context),
          const SizedBox(height: 32),
          _buildWhyChooseUsSection(context),
          const SizedBox(height: 32),
          _buildSectionHeader(
            context,
            title: "Trại hè nổi bật",
            onSeeAll: () =>
                context.findAncestorStateOfType<_HomeState>()?.onItemTapped(1),
          ),
          _buildFeaturedCamps(context),
          // const SizedBox(height: 32),
          // _buildOfferSection(context),
          const SizedBox(height: 32),
          _buildSectionHeader(
            context,
            title: "Khám phá hoạt động",
            onSeeAll: () {},
          ),
          _buildActivitiesCarousel(context),
          const SizedBox(height: 32),
          _buildTestimonialsSection(context),
          const SizedBox(height: 24),
          _buildCtaSection(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.name;
    final greeting = userName != null && userName.isNotEmpty
        ? 'Xin chào, $userName 👋'
        : 'Xin chào, Phụ huynh 👋';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              "https://joesch.moe/api/v1/male/random",
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.grey[600],
                ),
              ),
              const Text(
                "Khám phá mùa hè!",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey[700],
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      height: 200,
      width: 2000,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage(
            // "https://resources.finalsite.net/images/f_auto,q_auto,t_image_size_6/v1640708880/bishopscollegeschoolcom/xmbpayzzcyzujovpr4o4/SummerCamp-4.jpg",
            "https://cdnen.thesaigontimes.vn/wp-content/uploads/2022/05/At-the-summer-camps-kids-can-play-sports-to-improve-their-physical-wellness-1.jpg",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppTheme.summerAccent, AppTheme.summerYellow],
            ).createShader(bounds),
            child: const Text(
              "Mùa hè sôi động\nĐang chờ bé khám phá!",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.findAncestorStateOfType<_HomeState>()?.onItemTapped(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.summerAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Xem ngay",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildActionItem(
          context,
          Icons.search,
          "Tìm Trại",
          () => Navigator.pushNamed(context, AppRoutes.campSearch),
        ),
        _buildActionItem(
          context,
          Icons.assignment,
          "Đăng Ký",
          () => Navigator.pushNamed(context, AppRoutes.registrationList),
        ),
        _buildActionItem(
          context,
          Icons.child_care,
          "Bé Yêu",
          () => Navigator.pushNamed(context, AppRoutes.camperList),
        ),
        _buildActionItem(context, Icons.local_offer, "Ưu Đãi", () {}),
      ],
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
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

  Widget _buildWhyChooseUsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tại sao nên chọn chúng tôi?",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            icon: Icons.security,
            title: "An toàn tuyệt đối",
            description: "Môi trường giám sát 24/7, đảm bảo an toàn cho trẻ.",
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            icon: Icons.groups,
            title: "Đội ngũ chuyên nghiệp",
            description: "Huấn luyện viên giàu kinh nghiệm, tâm huyết.",
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            icon: Icons.auto_awesome,
            title: "Chương trình đa dạng",
            description: "Hoạt động thú vị, phát triển toàn diện kỹ năng.",
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.summerAccent, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
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
    );
  }

  Widget _buildFeaturedCamps(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5;
    final images = [
      "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?q=80&w=2070",
      "https://images.unsplash.com/photo-1576764432653-57a4174b59b6?q=80&w=1935",
      "https://images.unsplash.com/photo-1556382216-a43453389531?q=80&w=2070",
      "https://images.unsplash.com/photo-1616012480718-918e9a69a4a7?q=80&w=2070",
    ];
    final titles = [
      "Trại hè Sáng tạo",
      "Trại hè Thể thao",
      "Khám phá Khoa học",
      "Kỹ năng Sinh tồn",
    ];

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    titles[index],
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "TP. Hồ Chí Minh",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildOfferSection(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [AppTheme.summerYellow, AppTheme.summerPrimary],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: const Row(
  //       children: [
  //         Icon(Icons.star, color: Colors.white, size: 40),
  //         SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Ưu đãi đặc biệt",
  //                 style: TextStyle(
  //                   fontFamily: "Quicksand",
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               Text(
  //                 "Giảm giá 20% cho thành viên cũ!",
  //                 style: TextStyle(
  //                   fontFamily: "Quicksand",
  //                   color: Colors.white70,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActivitiesCarousel(BuildContext context) {
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

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(activity["image"]!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  activity["title"]!,
                  style: const TextStyle(
                    fontFamily: "Quicksand",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    return Container(
      color: AppTheme.summerPrimary.withValues(alpha: 0.05),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader(
            context,
            title: "Phụ huynh nói gì?",
            onSeeAll: () {},
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
    );
  }

  Widget _buildCtaSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            style: TextStyle(fontFamily: "Quicksand", color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                context.findAncestorStateOfType<_HomeState>()?.onItemTapped(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.summerPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
