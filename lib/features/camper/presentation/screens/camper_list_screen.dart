import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

class CamperListScreen extends StatefulWidget {
  const CamperListScreen({super.key});

  @override
  State<CamperListScreen> createState() => _CamperListScreenState();
}

class _CamperListScreenState extends State<CamperListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CamperProvider>().loadCampers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CamperProvider>();
    final campers = provider.campers;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: campers.length,
              itemBuilder: (context, index) {
                final camper = campers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.camperDetail,
                      arguments: camper,
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                NetworkImage(camper.avatar) as ImageProvider,
                            backgroundColor: AppTheme.summerPrimary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            camper.fullName,
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              color: AppTheme.summerAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "DOB: ${DateFormatter.formatFromString(camper.dob)}",
                            style: textTheme.bodySmall?.copyWith(
                              fontFamily: "Quicksand",
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.summerAccent,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createCamper);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
