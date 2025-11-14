import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camp/presentation/widgets/camp_card.dart';
import 'package:summercamp/core/config/app_theme.dart';

class CampListScreen extends StatefulWidget {
  const CampListScreen({super.key});

  @override
  State<CampListScreen> createState() => _CampListScreenState();
}

class _CampListScreenState extends State<CampListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CampProvider>();
      if (provider.camps.isEmpty) {
        provider.loadCamps();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampProvider>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    const allowedStatuses = {
      CampStatus.Published,
      CampStatus.OpenForRegistration,
      CampStatus.RegistrationClosed,
    };

    final filteredCamps = provider.camps
        .where((camp) => allowedStatuses.contains(camp.status))
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Danh sách trại hè",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : filteredCamps.isEmpty
          ? Center(
              child: Text(
                "Không có trại hè trong mùa hè này",
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredCamps.length,
              itemBuilder: (context, index) {
                return CampCard(camp: filteredCamps[index]);
              },
            ),
    );
  }
}
