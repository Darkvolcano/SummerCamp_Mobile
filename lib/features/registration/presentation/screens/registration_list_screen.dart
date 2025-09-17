import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/registration/presentation/widgets/registration_card.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_detail_screen.dart';

class RegistrationListScreen extends StatefulWidget {
  const RegistrationListScreen({super.key});

  @override
  State<RegistrationListScreen> createState() => _RegistrationListScreenState();
}

class _RegistrationListScreenState extends State<RegistrationListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistrationDetailScreen(registration: r),
                      ),
                    );
                  },
                  onDelete: () => provider.removeRegistration(r.id),
                );
              },
            ),
    );
  }
}
