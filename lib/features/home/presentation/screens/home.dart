import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/parent_bottom_nav_bar.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/chat/presentation/state/chat_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _didReadArgs = false;

  final List<Widget> _pages = [
    const HomeContent(),
    const _RouteWrapper(AppRoutes.campList),
    Container(),
    const _RouteWrapper(AppRoutes.blogList),
    const _RouteWrapper(AppRoutes.profile),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final chatProvider = context.read<ChatProvider>();

      if (authProvider.token != null) {
        print("Parent connecting to SignalR...");
        chatProvider.connectSignalR(authProvider.token!);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didReadArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        if (args >= 0 && args < _pages.length && args != 2) {
          _selectedIndex = args;
        }
      }
      _didReadArgs = true;
    }
  }

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
      backgroundColor: Color(0xFFF5F7F8),
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

  Widget _buildHomeHeader(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    String? userName;
    if (user != null) {
      userName = '${user.firstName} ${user.lastName}'.trim();
    }

    final avatarUrl = user?.avatar;
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.summerAccent,
            child: CircleAvatar(
              radius: 26,
              backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
              backgroundColor: Colors.white,
              child: !hasAvatar
                  ? Icon(
                      Icons.person_outline,
                      size: 30,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          authProvider.user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName != null && userName.isNotEmpty
                          ? 'Xin chào, $userName'
                          : 'Xin chào, Phụ huynh',
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
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.summerAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Đăng nhập ngay",
                    softWrap: false,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppTheme.summerPrimary,
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHomeHeader(context),

          const SizedBox(height: 16),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.summerAccent.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              image: DecorationImage(
                image: const NetworkImage(
                  "https://cdnen.thesaigontimes.vn/wp-content/uploads/2022/05/At-the-summer-camps-kids-can-play-sports-to-improve-their-physical-wellness-1.jpg",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
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
                    colors: [Colors.white, Color(0xFFFFE082)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    "Mùa hè sôi động\nĐang chờ bé khám phá!",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context
                      .findAncestorStateOfType<_HomeState>()
                      ?.onItemTapped(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.summerAccent,
                    foregroundColor: Colors.white,
                    elevation: 4,
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
          ),

          const SizedBox(height: 32),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _buildActionItem(
                context,
                Icons.search,
                "Tìm Trại",
                () => Navigator.pushNamed(context, AppRoutes.campSearch),
                color: const Color(0xFFE1F5FE),
                iconColor: const Color(0xFF0288D1),
              ),
              _buildActionItem(
                context,
                Icons.assignment,
                "Đăng Ký",
                () => Navigator.pushNamed(context, AppRoutes.campList),
                color: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF388E3C),
              ),
              _buildActionItem(
                context,
                Icons.child_care,
                "Camper",
                () => Navigator.pushNamed(context, AppRoutes.camperList),
                color: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFF57C00),
              ),
              _buildActionItem(
                context,
                Icons.local_offer,
                "Ưu Đãi",
                () {},
                color: const Color(0xFFFCE4EC),
                iconColor: const Color(0xFFC2185B),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Padding(
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
                    color: AppTheme.summerPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeatureRow(
                  icon: Icons.security,
                  title: "An toàn tuyệt đối",
                  description:
                      "Môi trường giám sát 24/7, đảm bảo an toàn cho trẻ.",
                  iconBgColor: Colors.green.shade50,
                  iconColor: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  icon: Icons.groups,
                  title: "Đội ngũ chuyên nghiệp",
                  description: "Huấn luyện viên giàu kinh nghiệm, tâm huyết.",
                  iconBgColor: Colors.blue.shade50,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  icon: Icons.auto_awesome,
                  title: "Chương trình đa dạng",
                  description:
                      "Hoạt động thú vị, phát triển toàn diện kỹ năng.",
                  iconBgColor: Colors.orange.shade50,
                  iconColor: Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            context,
            title: "Trại hè nổi bật",
            viewAll: () =>
                context.findAncestorStateOfType<_HomeState>()?.onItemTapped(1),
          ),

          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titles[index],
                              style: const TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppTheme.summerAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "TP. Hồ Chí Minh",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          Container(
            color: const Color(0xFFFFF3E0),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
            child: Column(
              children: [
                _buildSectionHeader(
                  context,
                  title: "Phụ huynh nói gì?",
                  viewAll: () {},
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppTheme.summerPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Color(0xFFFFC107),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '"Con tôi đã có những trải nghiệm tuyệt vời. Các hoạt động rất bổ ích và đội ngũ huấn luyện viên rất tận tâm."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.summerBlue,
                              child: Text(
                                "M",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Phụ huynh",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    color: Colors.grey,
                                    fontSize: 14,
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

          const SizedBox(height: 32),

          _buildSectionHeader(
            context,
            title: "Khám phá hoạt động",
            viewAll: () {},
          ),

          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.6],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      activity["title"]!,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    color: Colors.grey[600],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback viewAll,
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
              color: AppTheme.summerPrimary,
            ),
          ),
          TextButton(
            onPressed: viewAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Xem tất cả",
              style: TextStyle(
                fontFamily: "Quicksand",
                color: AppTheme.summerAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
