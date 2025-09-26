import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/registration/presentation/widgets/registration_card.dart';

class RegistrationListScreen extends StatefulWidget {
  const RegistrationListScreen({super.key});

  @override
  State<RegistrationListScreen> createState() => _RegistrationListScreenState();
}

class _RegistrationListScreenState extends State<RegistrationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RegistrationProvider>().loadRegistrations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách đăng ký",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.registrations.isEmpty
          ? Center(
              child: Text(
                "Bạn chưa đăng ký trại hè nào",
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Nunito",
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.registrations.length,
              itemBuilder: (context, index) {
                final r = provider.registrations[index];
                return RegistrationCard(
                  registration: r,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.registrationDetail,
                      arguments: r,
                    );
                  },
                );
              },
            ),
    );
  }
}
