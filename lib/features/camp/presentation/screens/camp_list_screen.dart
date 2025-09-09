import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camp/presentation/widgets/camp_card.dart';

class CampListScreen extends StatelessWidget {
  const CampListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách trại")),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.camps.length,
              itemBuilder: (context, index) {
                return CampCard(camp: provider.camps[index]);
              },
            ),
    );
  }
}
