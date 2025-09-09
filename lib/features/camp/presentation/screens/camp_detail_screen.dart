import 'package:flutter/material.dart';
import '../../domain/entities/camp.dart';

class CampDetailScreen extends StatelessWidget {
  final Camp camp;
  const CampDetailScreen({super.key, required this.camp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(camp.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(camp.description),
            const SizedBox(height: 8),
            Text("Địa điểm: ${camp.place}"),
            Text("Bắt đầu: ${camp.startDate}"),
            Text("Kết thúc: ${camp.endDate}"),
          ],
        ),
      ),
    );
  }
}
