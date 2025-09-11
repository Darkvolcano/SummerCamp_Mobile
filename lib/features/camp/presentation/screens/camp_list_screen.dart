import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camp/presentation/widgets/camp_card.dart';

class CampListScreen extends StatelessWidget {
  const CampListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Danh sách trại hè",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Body: loading / empty / danh sách
            Expanded(
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.camps.isEmpty
                  ? const Center(
                      child: Text(
                        "Không có trại hè trong mùa hè này",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.camps.length,
                      itemBuilder: (context, index) {
                        return CampCard(camp: provider.camps[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
