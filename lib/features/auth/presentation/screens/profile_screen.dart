import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void>? _load;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AuthProvider>();
    // If user login successful can refresh from server:
    if (provider.user != null) {
      _load = provider.fetchProfileById(provider.user!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final user = provider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('Chưa đăng nhập'))
          : RefreshIndicator(
              onRefresh: () => provider.fetchProfileById(user.id.toString()),
              child: FutureBuilder(
                future: _load,
                builder: (context, snapshot) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'ID: ${user.id}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Name: ${user.firstName} ${user.lastName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Phone: ${user.phoneNumber}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                await provider.logout();
                                if (!mounted) return;
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: const Text('Logout'),
                            ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
