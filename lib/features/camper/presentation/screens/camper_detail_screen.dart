import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';

class CamperDetailScreen extends StatefulWidget {
  final int camperId;
  const CamperDetailScreen({super.key, required this.camperId});

  @override
  State<CamperDetailScreen> createState() => _CamperDetailScreenState();
}

class _CamperDetailScreenState extends State<CamperDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CamperProvider>().fetchCamperById(widget.camperId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<CamperProvider>();
    final camper = provider.selectedCamper;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết Camper",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : camper == null
          ? const Center(child: Text("Không có dữ liệu camper."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        (camper.avatar != null && camper.avatar!.isNotEmpty)
                        ? NetworkImage(camper.avatar!) as ImageProvider
                        : const AssetImage('assets/images/default_avatar.png'),
                    backgroundColor: AppTheme.summerPrimary.withValues(
                      alpha: 0.2,
                    ),
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
                          _infoRow("Tên", camper.camperName, textTheme),
                          _infoRow(
                            "Ngày sinh",
                            DateFormatter.formatFromString(camper.dob),
                            textTheme,
                          ),
                          _infoRow("Giới tính", camper.gender, textTheme),
                          _infoRow(
                            "Tình trạng sức khỏe",
                            camper.healthRecord?.condition ??
                                "Không có thông tin",
                            textTheme,
                          ),
                          _infoRow(
                            "Dị ứng",
                            camper.healthRecord?.allergies ??
                                "Không có thông tin",
                            textTheme,
                          ),
                          _infoRow(
                            "Note",
                            camper.healthRecord?.note ?? "Không có",
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
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.updateCamper,
                          arguments: camper,
                        );

                        if (result == true && context.mounted) {
                          // context.read<CamperProvider>().fetchCamperById(
                          //   widget.camperId,
                          // );
                          context.read<CamperProvider>().loadCampers();
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(
                        "Cập nhật",
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Quicksand",
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
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: "Quicksand",
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
