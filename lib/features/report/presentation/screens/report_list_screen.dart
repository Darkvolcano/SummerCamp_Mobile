import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import '../../../../core/config/staff_theme.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReportProvider>().loadReports();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh Sách Báo Cáo",
          style: TextStyle(fontFamily: "Fredoka", fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.reports.isEmpty
          ? const Center(
              child: Text(
                "Chưa có báo cáo nào",
                style: TextStyle(fontFamily: "Nunito", fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.reports.length,
              itemBuilder: (context, index) {
                final report = provider.reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: report.image.isNotEmpty
                                    ? Image.network(
                                        report.image,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.image,
                                          size: 32,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Camper #${report.camperId}",
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Nunito",
                                              ),
                                        ),
                                        const Spacer(),
                                        Chip(
                                          label: Text(report.status),
                                          backgroundColor:
                                              report.status == "Resolved"
                                              ? Colors.green.shade100
                                              : Colors.orange.shade100,
                                          labelStyle: TextStyle(
                                            fontFamily: "Nunito",
                                            color: report.status == "Resolved"
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      report.note,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: "Nunito",
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.bolt,
                                          color: Colors.redAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Level: ${report.level}",
                                          style: const TextStyle(
                                            fontFamily: "Nunito",
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          DateFormatter.formatDate(
                                            report.createAt,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Nunito",
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.cabin,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Camp ID: ${report.activityId}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Nunito",
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createReport);
        },
        backgroundColor: StaffTheme.staffAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
