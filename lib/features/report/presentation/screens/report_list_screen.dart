import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _filterLevel = 'All';
  String _filterType = 'All';

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReportProvider>().loadReports();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore) {
        _loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    final provider = context.read<ReportProvider>();
    final totalFiltered = _getFilteredReports(provider.reports).length;
    final currentShown = _currentPage * _itemsPerPage;

    if (currentShown < totalFiltered) {
      setState(() {
        _isLoadingMore = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentPage++;
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  List<Report> _getFilteredReports(List<Report> allReports) {
    List<Report> filtered = List.from(allReports);

    filtered.sort((a, b) {
      final dateA = a.createAt ?? DateTime(2000);
      final dateB = b.createAt ?? DateTime(2000);
      return dateB.compareTo(dateA);
    });

    if (_filterLevel != 'All') {
      int level = int.parse(_filterLevel);
      // ignore: unrelated_type_equality_checks
      filtered = filtered.where((r) => r.level == level).toList();
    }

    if (_filterType != 'All') {
      filtered = filtered.where((r) => r.reportType == _filterType).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.trim().toLowerCase();
      filtered = filtered
          .where((r) => r.reportId.toString().contains(query))
          .toList();
    }

    return filtered;
  }

  String _getLevelText(String level) {
    switch (level) {
      case '1':
        return "Thấp";
      case '2':
        return "Trung bình";
      case '3':
        return "Cao";
      default:
        return "Không xác định";
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getReportTypeText(String? type) {
    if (type == 'Transport') return 'Vận chuyển';
    if (type == 'Incident') return 'Sinh hoạt';
    if (type == 'CheckOut') return 'Check-out';
    return type ?? 'Khác';
  }

  IconData _getReportTypeIcon(String? type) {
    if (type == 'Transport') return Icons.directions_bus;
    if (type == 'Incident') return Icons.home_repair_service;
    if (type == 'CheckOut') return Icons.logout;
    return Icons.article;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Bộ lọc hiển thị",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: StaffTheme.staffPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Mức độ nghiêm trọng",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                          {"value": "All", "label": "Tất cả"},
                          {"value": "1", "label": "Thấp"},
                          {"value": "2", "label": "Trung bình"},
                          {"value": "3", "label": "Cao"},
                        ].map((levelMap) {
                          final value = levelMap["value"]!;
                          final label = levelMap["label"]!;
                          final isSelected = _filterLevel == value;

                          Color chipColor;
                          if (value == "1") {
                            chipColor = Colors.green;
                          } else if (value == "2") {
                            chipColor = Colors.orange;
                          } else if (value == "3") {
                            chipColor = Colors.red;
                          } else {
                            chipColor = StaffTheme.staffPrimary;
                          }

                          return ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            selectedColor: chipColor.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              fontFamily: "Quicksand",
                              color: isSelected ? chipColor : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (bool selected) {
                              setModalState(() => _filterLevel = value);
                              setState(() {
                                _filterLevel = value;
                                _currentPage = 1;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Loại báo cáo",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                          {"value": "All", "label": "Tất cả"},
                          {"value": "Transport", "label": "Vận chuyển"},
                          {"value": "Incident", "label": "Sinh hoạt"},
                          {"value": "CheckOut", "label": "Check-out"},
                        ].map((typeMap) {
                          final value = typeMap["value"]!;
                          final label = typeMap["label"]!;
                          final isSelected = _filterType == value;
                          return ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            selectedColor: StaffTheme.staffAccent.withValues(
                              alpha: 0.2,
                            ),
                            labelStyle: TextStyle(
                              fontFamily: "Quicksand",
                              color: isSelected
                                  ? StaffTheme.staffPrimary
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (bool selected) {
                              setModalState(() => _filterType = value);
                              setState(() {
                                _filterType = value;
                                _currentPage = 1;
                              });
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StaffTheme.staffPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Áp dụng",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<ReportProvider>();

    final filteredReports = _getFilteredReports(provider.reports);

    final int endIndex = (_currentPage * _itemsPerPage).clamp(
      0,
      filteredReports.length,
    );
    final displayedReports = filteredReports.sublist(0, endIndex);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Danh Sách Sự Cố",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list_rounded),
                if (_filterLevel != 'All' || _filterType != 'All')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: StaffTheme.staffPrimary,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _currentPage = 1),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: "Quicksand"),
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo Report ID...",
                hintStyle: TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.grey.shade500,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: StaffTheme.staffPrimary,
                    ),
                  )
                : provider.error != null
                ? Center(
                    child: Text(
                      "Lỗi: ${provider.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : displayedReports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Không tìm thấy báo cáo nào",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await provider.loadReports();
                      setState(() => _currentPage = 1);
                    },
                    color: StaffTheme.staffPrimary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: displayedReports.length + 1,
                      itemBuilder: (context, index) {
                        if (index == displayedReports.length) {
                          return _isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox(height: 80);
                        }

                        final report = displayedReports[index];
                        return _buildReportCard(context, report, textTheme);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    Report report,
    TextTheme textTheme,
  ) {
    Color statusColor;
    Color statusBgColor;

    if (report.status == "Active") {
      statusColor = Colors.blue.shade700;
      statusBgColor = Colors.blue.shade50;
    } else {
      statusColor = Colors.orange.shade800;
      statusBgColor = Colors.orange.shade50;
    }

    Color levelColor = _getLevelColor(report.level);
    String levelText = _getLevelText(report.level);
    String typeText = _getReportTypeText(report.reportType);
    IconData typeIcon = _getReportTypeIcon(report.reportType);

    String camperDisplayName = report.camperName;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#${report.reportId}",
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(typeIcon, size: 12, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        Text(
                          typeText,
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: report.image.isNotEmpty
                        ? Image.network(
                            report.image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.description,
                              color: StaffTheme.staffPrimary,
                              size: 30,
                            ),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camper $camperDisplayName',
                          style: textTheme.titleMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.note.isEmpty
                              ? "Không có ghi chú"
                              : report.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: levelColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Mức độ: $levelText",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDate(report.createAt ?? DateTime.now()),
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
