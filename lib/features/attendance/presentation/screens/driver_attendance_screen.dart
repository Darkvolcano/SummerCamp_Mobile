import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class DriverAttendanceScreen extends StatefulWidget {
  final TransportSchedule schedule;
  const DriverAttendanceScreen({super.key, required this.schedule});

  @override
  State<DriverAttendanceScreen> createState() => _DriverAttendanceScreenState();
}

class _DriverAttendanceScreenState extends State<DriverAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<int, bool> _checkInStatus = {};
  final Map<int, bool> _checkOutStatus = {};

  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      if (timeStr.isEmpty) return DateTime.parse(dateStr);
      return DateTime.parse("${dateStr}T$timeStr");
    } catch (e) {
      return DateTime.now();
    }
  }

  bool _isTimeValidToSubmit(bool isCheckOut) {
    final now = DateTime.now();
    final schedule = widget.schedule;

    final tripDate = DateTime.parse(schedule.date);
    final isToday =
        tripDate.year == now.year &&
        tripDate.month == now.month &&
        tripDate.day == now.day;

    if (!isToday) return false;

    if (!isCheckOut) {
      final start = _parseDateTime(schedule.date, schedule.startTime);
      final validStart = start.subtract(const Duration(minutes: 30));
      final validEnd = start.add(const Duration(minutes: 30));

      return now.isAfter(validStart) && now.isBefore(validEnd);
    } else {
      final end = _parseDateTime(schedule.date, schedule.endTime);
      final validStart = end.subtract(const Duration(minutes: 30));
      final validEnd = end.add(const Duration(minutes: 60));

      return now.isAfter(validStart) && now.isBefore(validEnd);
    }
  }

  void _showTimeError(bool isCheckOut) {
    final schedule = widget.schedule;
    String msg;

    if (!isCheckOut) {
      final start = _parseDateTime(schedule.date, schedule.startTime);
      final sTime = DateFormatter.formatTime(
        start.subtract(const Duration(minutes: 30)),
      );
      final eTime = DateFormatter.formatTime(
        start.add(const Duration(minutes: 30)),
      );
      msg = "Chỉ được xác nhận lên xe từ $sTime đến $eTime";
    } else {
      final end = _parseDateTime(schedule.date, schedule.endTime);
      final sTime = DateFormatter.formatTime(
        end.subtract(const Duration(minutes: 30)),
      );
      final eTime = DateFormatter.formatTime(
        end.add(const Duration(minutes: 60)),
      );
      msg = "Chỉ được xác nhận xuống xe từ $sTime đến $eTime";
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<ScheduleProvider>();
    await provider.loadCampersTransportByTransportScheduleId(
      widget.schedule.transportScheduleId,
    );

    final transports = provider.campersTransport;

    _checkInStatus.clear();
    _checkOutStatus.clear();

    for (var transport in transports) {
      _checkInStatus[transport.camperTransportId] =
          transport.checkInTime != null;
      _checkOutStatus[transport.camperTransportId] =
          transport.checkoutTime != null;
    }

    if (mounted) setState(() {});
  }

  Future<void> _submitAttendance() async {
    final isCheckOutTab = _tabController.index == 1;

    if (!_isTimeValidToSubmit(isCheckOutTab)) {
      _showTimeError(isCheckOutTab);
      return;
    }

    final currentStatusMap = isCheckOutTab ? _checkOutStatus : _checkInStatus;

    final selectedIds = currentStatusMap.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    // api update status camper transport
    // if (isCheckOutTab) provider.submitCheckOut(selectedIds);
    // else provider.submitCheckIn(selectedIds);

    final actionText = isCheckOutTab ? "xuống xe" : "lên xe";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã cập nhật danh sách $actionText (${selectedIds.length})!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final transports = provider.campersTransport;
    final isLoading = provider.loading;

    final int total = transports.length;
    final int checkedInCount = _checkInStatus.values.where((e) => e).length;
    final int checkedOutCount = _checkOutStatus.values.where((e) => e).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Camper lên/xuống xe",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: DriverTheme.driverPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DriverTheme.driverPrimary,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  color: DriverTheme.driverPrimary,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Tổng số", "$total", Colors.white70),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white24,
                          ),
                          _buildStatItem(
                            "Trên xe",
                            "${checkedInCount - checkedOutCount}",
                            Colors.white,
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white24,
                          ),
                          _buildStatItem(
                            "Đã trả",
                            "$checkedOutCount",
                            Colors.lightGreenAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: DriverTheme.driverPrimary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: DriverTheme.driverPrimary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: const [
                      Tab(text: "Lên xe"),
                      Tab(text: "Xuống xe"),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCamperList(transports, isCheckOutMode: false),
                      _buildCamperList(transports, isCheckOutMode: true),
                    ],
                  ),
                ),
              ],
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submitAttendance,
          style: ElevatedButton.styleFrom(
            backgroundColor: DriverTheme.driverPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Text(
            _tabController.index == 0 ? "Xác nhận LÊN XE" : "Xác nhận XUỐNG XE",
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCamperList(
    List<dynamic> transports, {
    required bool isCheckOutMode,
  }) {
    if (transports.isEmpty) {
      return const Center(
        child: Text(
          "Không có dữ liệu",
          style: TextStyle(fontFamily: "Quicksand"),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transport = transports[index];
        final camper = transport.camper;
        final int id = transport.camperTransportId;

        final bool isCheckedIn = _checkInStatus[id] ?? false;
        final bool isCheckedOut = _checkOutStatus[id] ?? false;

        final bool isDisabled = isCheckOutMode && !isCheckedIn;

        final bool isSelected = isCheckOutMode ? isCheckedOut : isCheckedIn;

        return Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    setState(() {
                      if (isCheckOutMode) {
                        _checkOutStatus[id] = !isCheckedOut;
                      } else {
                        _checkInStatus[id] = !isCheckedIn;
                        if (_checkInStatus[id] == false) {
                          _checkOutStatus[id] = false;
                        }
                      }
                    });
                  },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? DriverTheme.driverPrimary
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isSelected
                        ? DriverTheme.driverPrimary.withValues(alpha: 0.1)
                        : Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: isSelected
                          ? DriverTheme.driverPrimary
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camper.camperName,
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Text(
                        //   "Tại: ${transport.location.name}",
                        //   style: TextStyle(
                        //     fontFamily: "Quicksand",
                        //     color: Colors.grey[600],
                        //     fontSize: 13,
                        //   ),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        if (isDisabled)
                          const Text(
                            "Chưa lên xe",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              color: Colors.red,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),

                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? DriverTheme.driverPrimary
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? DriverTheme.driverPrimary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
