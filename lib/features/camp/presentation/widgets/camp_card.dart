import 'package:flutter/material.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_detail_screen.dart';

class CampCard extends StatelessWidget {
  final Camp camp;
  const CampCard({super.key, required this.camp});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(camp.name),
        subtitle: Text(camp.place),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CampDetailScreen(camp: camp)),
          );
        },
      ),
    );
  }
}
