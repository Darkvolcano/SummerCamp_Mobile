import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/enum/status.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/registration/presentation/widgets/registration_card.dart';

class _TabInfo {
  final String text;
  final List<Status> statuses;
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

  final List<_TabInfo> _tabs = const [
    _TabInfo('Tất cả', []),
    _TabInfo('Chờ xử lý', [Status.PendingApproval]),
    _TabInfo('Đang diễn ra', [Status.InProgress]),
    _TabInfo('Hoàn thành', [Status.Completed]),
    _TabInfo('Đã hủy', [Status.Canceled, Status.Rejected]),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
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
    final selectedTab = _tabs[_tabController.index];
    if (selectedTab.statuses.isEmpty) {
      return allRegistrations;
    }
    return allRegistrations
        .where((reg) => selectedTab.statuses.contains(reg.status))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
    final textTheme = Theme.of(context).textTheme;

    final filteredRegistrations = _getFilteredList(provider.registrations);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách đăng ký",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        elevation: 0,
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
                : filteredRegistrations.isEmpty
                ? Center(
                    child: Text(
                      "Không có đơn đăng ký nào trong mục này",
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: "Nunito",
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRegistrations.length,
                    itemBuilder: (context, index) {
                      final r = filteredRegistrations[index];
                      return RegistrationCard(
                        registration: r,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.registrationDetail,
                            arguments: r,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
