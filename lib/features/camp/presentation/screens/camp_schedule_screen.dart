import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class CampScheduleScreen extends StatelessWidget {
  const CampScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<CampProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.camps.isEmpty && !provider.loading) {
        provider.loadCamps();
      }
    });

    return Scaffold(
      appBar: _buildStaffAppBar("Camps Quản Lý"),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.camps.isEmpty
          ? Center(
              child: Text(
                "Không có camp nào",
                style: TextStyle(fontFamily: "Quicksand", fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.camps.length,
              itemBuilder: (context, index) {
                final camp = provider.camps[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.campScheduleDetail,
                        arguments: camp,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (camp.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              camp.image,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                camp.name,
                                style: textTheme.titleMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: StaffTheme.staffPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (camp.description.isNotEmpty)
                                Text(
                                  camp.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      camp.place,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${DateFormatter.formatFromString(camp.startDate)} - ${DateFormatter.formatFromString(camp.endDate)}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Chip(
                                  label: Text(
                                    camp.status,
                                    style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 13,
                                    ),
                                  ),
                                  backgroundColor: camp.status == "Active"
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  labelStyle: TextStyle(
                                    color: camp.status == "Active"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  PreferredSizeWidget _buildStaffAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 4,
      backgroundColor: StaffTheme.staffPrimary,
      foregroundColor: Colors.white,
    );
  }
}
