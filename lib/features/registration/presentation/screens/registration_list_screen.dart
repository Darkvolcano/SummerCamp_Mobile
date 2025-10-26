import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/registration_status.enum.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/registration/presentation/widgets/registration_card.dart';

class _TabInfo {
  final String text;
  final List<RegistrationStatus> statuses;
  const _TabInfo(this.text, this.statuses);
}

class RegistrationListScreen extends StatefulWidget {
  const RegistrationListScreen({super.key});

  @override
  State<RegistrationListScreen> createState() => _RegistrationListScreenState();
}

class _RegistrationListScreenState extends State<RegistrationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _currentPage = 1;
  final int _pageSize = 10;

  final List<_TabInfo> _tabs = const [
    _TabInfo('Tất cả', []),
    _TabInfo('Chờ duyệt', [RegistrationStatus.PendingApproval]),
    _TabInfo('Đã duyệt', [RegistrationStatus.Approved]),
    _TabInfo('Chờ hoàn thành', [RegistrationStatus.PendingCompletion]),
    _TabInfo('Chờ phân nhóm', [RegistrationStatus.PendingAssignGroup]),
    _TabInfo('Chờ thanh toán', [RegistrationStatus.PendingPayment]),
    _TabInfo('Đã xác nhận', [RegistrationStatus.Confirmed]),
    _TabInfo('Hoàn thành', [RegistrationStatus.Completed]),
    _TabInfo('Đã hủy', [RegistrationStatus.Canceled]),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentPage = 1;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RegistrationProvider>().loadRegistrations();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Registration> _getFilteredList(List<Registration> allRegistrations) {
    allRegistrations.sort(
      (a, b) => b.registrationCreateAt.compareTo(a.registrationCreateAt),
    );

    final selectedTab = _tabs[_tabController.index];
    if (selectedTab.statuses.isEmpty) {
      return allRegistrations;
    }
    return allRegistrations
        .where((reg) => selectedTab.statuses.contains(reg.status))
        .toList();
  }

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
    final textTheme = Theme.of(context).textTheme;

    final filteredRegistrations = _getFilteredList(provider.registrations);

    final totalPages = filteredRegistrations.isEmpty
        ? 1
        : (filteredRegistrations.length / _pageSize).ceil();
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = min(startIndex + _pageSize, filteredRegistrations.length);
    final paginatedList = filteredRegistrations.isNotEmpty
        ? filteredRegistrations.sublist(startIndex, endIndex)
        : <Registration>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách đăng ký",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppTheme.summerPrimary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppTheme.summerAccent,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              tabAlignment: TabAlignment.start,
              tabs: _tabs.map((tab) => Tab(text: tab.text)).toList(),
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : paginatedList.isEmpty
                ? Center(
                    child: Text(
                      "Không có đơn đăng ký nào trong mục này",
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: "Quicksand",
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) {
                      final r = paginatedList[index];
                      return RegistrationCard(
                        registration: r,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.registrationDetail,
                            arguments: r.registrationId,
                          );
                        },
                      );
                    },
                  ),
          ),

          if (!provider.loading && filteredRegistrations.length > _pageSize)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_ios, size: 14),
                    label: const Text('Trang trước'),
                    onPressed: _currentPage > 1 ? _previousPage : null,
                  ),
                  Text(
                    'Trang $_currentPage / $totalPages',
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward_ios, size: 14),
                    label: const Text('Trang sau'),
                    onPressed: _currentPage < totalPages
                        ? () => _nextPage(totalPages)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.summerAccent,
        onPressed: () => provider.loadRegistrations(),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
