import 'package:flutter/material.dart';
import 'package:summercamp/core/widgets/custom_bottom_nav_bar.dart';
import 'package:summercamp/core/widgets/custom_carousel_slider.dart';
import 'package:summercamp/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_list_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/profile_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // dùng HomeContent (public) thay vì _HomeContent để tránh lỗi private across files
  final List<Widget> _pages = const [
    HomeContent(),
    CampListScreen(),
    AIChatScreen(),
    RegistrationListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // không dùng AppBar như bạn muốn
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

/// Public widget (dùng từ nhiều file an toàn)
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner carousel (custom)
          const SizedBox(height: 12),
          CustomCarousel(
            images: const [
              "https://picsum.photos/800/300?1",
              "https://picsum.photos/800/300?2",
              "https://picsum.photos/800/300?3",
            ],
          ),
          const SizedBox(height: 16),

          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Camps nổi bật",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("Xem tất cả", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Horizontal camps preview
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (_, idx) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          "https://picsum.photos/200/120?random=$idx",
                          width: 140,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Camp #$idx",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Quick registration button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA05A2C),
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
              label: const Text(
                "Xem đăng ký của tôi",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
