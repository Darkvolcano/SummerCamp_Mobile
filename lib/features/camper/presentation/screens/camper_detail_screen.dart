import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class CamperDetailScreen extends StatelessWidget {
  final Camper camper;
  const CamperDetailScreen({super.key, required this.camper});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: const AssetImage(
                "assets/images/default_avatar.png",
              ),
              backgroundColor: AppTheme.summerPrimary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Tên", camper.fullName, textTheme),
                    _infoRow("Ngày sinh", camper.dob, textTheme),
                    _infoRow("Giới tính", camper.gender, textTheme),
                    _infoRow(
                      "Health Record",
                      camper.healthRecordId.toString(),
                      textTheme,
                    ),
                    _infoRow(
                      "Parent ID",
                      camper.parentId.toString(),
                      textTheme,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.summerAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateCamper,
                    arguments: camper,
                  );
                },
                icon: const Icon(Icons.edit),
                label: Text(
                  "Cập nhật",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: textTheme.bodyMedium?.copyWith(
              fontFamily: "Fredoka",
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: "Nunito",
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
