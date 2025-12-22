import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';
// import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/report/presentation/screens/transport_report_form_screen.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

class StaffTransportScheduleAttedanceScreen extends StatefulWidget {
  final TransportSchedule schedule;
  const StaffTransportScheduleAttedanceScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<StaffTransportScheduleAttedanceScreen> createState() =>
      _StaffTransportScheduleAttedanceScreenState();
}

class _StaffTransportScheduleAttedanceScreenState
    extends State<StaffTransportScheduleAttedanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<int, bool> _checkInStatus = {};
  final Map<int, bool> _checkOutStatus = {};

  final Map<int, bool> _selectionState = {};

  final Map<int, String> _routeStopLocationMap = {};

  String _lastStopName = "Chưa cập nhật";

  bool get _isTripFinished =>
      widget.schedule.actualEndTime != null &&
      widget.schedule.actualEndTime!.isNotEmpty;

  // DateTime _parseDateTime(String dateStr, String timeStr) {
  //   try {
  //     if (timeStr.isEmpty) return DateTime.parse(dateStr);
  //     return DateTime.parse("${dateStr}T$timeStr");
  //   } catch (e) {
  //     return DateTime.now();
  //   }
  // }

  // bool _isTimeValidToSubmit(bool isCheckOut) {
  //   final now = DateTime.now();
  //   final schedule = widget.schedule;

  //   final tripDate = DateTime.parse(schedule.date);
  //   final isToday =
  //       tripDate.year == now.year &&
  //       tripDate.month == now.month &&
  //       tripDate.day == now.day;

  //   if (!isToday) return false;

  //   if (!isCheckOut) {
  //     final start = _parseDateTime(schedule.date, schedule.startTime);
  //     final validStart = start.subtract(const Duration(minutes: 60));
  //     final validEnd = start.add(const Duration(minutes: 60));

  //     return now.isAfter(validStart) && now.isBefore(validEnd);
  //   } else {
  //     final end = _parseDateTime(schedule.date, schedule.endTime);
  //     final validStart = end.subtract(const Duration(minutes: 60));
  //     final validEnd = end.add(const Duration(minutes: 60));

  //     return now.isAfter(validStart) && now.isBefore(validEnd);
  //   }
  // }

  // void _showTimeError(bool isCheckOut) {
  //   final schedule = widget.schedule;
  //   String msg;

  //   if (!isCheckOut) {
  //     final start = _parseDateTime(schedule.date, schedule.startTime);
  //     final sTime = DateFormatter.formatTime(
  //       start.subtract(const Duration(minutes: 30)),
  //     );
  //     final eTime = DateFormatter.formatTime(
  //       start.add(const Duration(minutes: 30)),
  //     );
  //     msg = "Chỉ được xác nhận lên xe từ $sTime đến $eTime";
  //   } else {
  //     final end = _parseDateTime(schedule.date, schedule.endTime);
  //     final sTime = DateFormatter.formatTime(
  //       end.subtract(const Duration(minutes: 30)),
  //     );
  //     final eTime = DateFormatter.formatTime(
  //       end.add(const Duration(minutes: 60)),
  //     );
  //     msg = "Chỉ được xác nhận xuống xe từ $sTime đến $eTime";
  //   }

  //   showCustomDialog(
  //     context,
  //     title: "Chưa đến giờ",
  //     message: msg,
  //     type: DialogType.warning,
  //     btnText: "Đã hiểu",
  //   );
  // }

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

  // Future<void> _loadData() async {
  //   final provider = context.read<ScheduleProvider>();
  //   await provider.loadCampersTransportByTransportScheduleId(
  //     widget.schedule.transportScheduleId,
  //   );

  //   final transports = provider.campersTransport;

  //   _selectionState.clear();

  //   for (var transport in transports) {
  //     _checkInStatus[transport.camperTransportId] =
  //         transport.checkInTime != null;
  //     _checkOutStatus[transport.camperTransportId] =
  //         transport.checkoutTime != null;
  //   }

  //   if (mounted) setState(() {});
  // }

  Future<void> _loadData() async {
    final provider = context.read<ScheduleProvider>();

    await provider.loadCampersTransportByTransportScheduleId(
      widget.schedule.transportScheduleId,
    );

    final int routeId = widget.schedule.routeName.routeId;

    if (routeId != 0) {
      await provider.loadRouteStopByRouteId(routeId);

      final stops = provider.routeStopsMap[routeId] ?? [];

      _routeStopLocationMap.clear();

      if (stops.isNotEmpty) {
        for (var stop in stops) {
          _routeStopLocationMap[stop.location.id] = stop.location.name;
        }

        _lastStopName = stops.last.location.name;
      }
    }

    final transports = provider.campersTransport;
    _selectionState.clear();

    for (var transport in transports) {
      _checkInStatus[transport.camperTransportId] =
          transport.checkInTime != null;
      _checkOutStatus[transport.camperTransportId] =
          transport.checkoutTime != null;
    }

    if (mounted) setState(() {});
  }

  void _showStatusDialog(String message, {bool isSuccess = true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? "Thành công" : "Thất bại",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> _submitAttendance() async {
  //   final isCheckOutTab = _tabController.index == 1;

  //   if (!_isTimeValidToSubmit(isCheckOutTab)) {
  //     _showTimeError(isCheckOutTab);
  //     return;
  //   }

  //   final provider = context.read<ScheduleProvider>();
  //   final transports = provider.campersTransport;
  //   final List<int> selectedIds = [];

  //   for (var t in transports) {
  //     bool isSelected = false;

  //     bool originalSelected = false;
  //     if (isCheckOutTab) {
  //       originalSelected = t.status == "Completed";
  //     } else {
  //       originalSelected = t.status == "Onboard" || t.status == "Completed";
  //     }

  //     if (_selectionState.containsKey(t.camperTransportId)) {
  //       isSelected = _selectionState[t.camperTransportId]!;
  //     } else {
  //       isSelected = originalSelected;
  //     }

  //     if (isSelected) {
  //       selectedIds.add(t.camperTransportId);
  //     }
  //   }

  //   if (selectedIds.isEmpty) {
  //     showCustomDialog(
  //       context,
  //       title: "Chưa chọn camper",
  //       message: "Vui lòng chọn ít nhất 1 camper để xác nhận.",
  //       type: DialogType.warning,
  //       btnText: "Đóng",
  //     );
  //     return;
  //   }

  //   final actionText = isCheckOutTab ? "xuống xe" : "lên xe";

  //   try {
  //     if (isCheckOutTab) {
  //       await provider.submitAttendanceCamperTransportCheckOut(
  //         camperTransportIds: selectedIds,
  //       );
  //     } else {
  //       await provider.submitAttendanceCamperTransportCheckIn(
  //         camperTransportIds: selectedIds,
  //       );
  //     }

  //     if (mounted) {
  //       _showStatusDialog(
  //         'Đã cập nhật danh sách $actionText thành công!',
  //         isSuccess: true,
  //       );
  //       _loadData();
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       String errorMessage = e.toString();
  //       _showStatusDialog(errorMessage, isSuccess: false);
  //     }
  //   }
  // }
  Future<void> _submitAttendance() async {
    if (_isTripFinished) {
      showCustomDialog(
        context,
        title: "Đã kết thúc",
        message: "Chuyến đi này đã kết thúc, không thể điểm danh nữa.",
        type: DialogType.warning,
      );
      return;
    }

    final isCheckOutTab = _tabController.index == 1;

    if (!isCheckOutTab) {
      final bool isTripStarted =
          widget.schedule.actualStartTime != null &&
          widget.schedule.actualStartTime!.isNotEmpty;

      if (!isTripStarted) {
        showCustomDialog(
          context,
          title: "Chưa bắt đầu",
          message:
              "Chuyến đi chưa bắt đầu. Vui lòng đợi tài xế bắt đầu chuyến đi để điểm danh lên xe.",
          type: DialogType.warning,
        );
        return;
      }
    }

    final provider = context.read<ScheduleProvider>();
    final transports = provider.campersTransport;
    final List<int> selectedIds = [];

    for (var t in transports) {
      bool isSelected = false;
      bool originalSelected = false;
      if (isCheckOutTab) {
        originalSelected = t.status == "Completed";
      } else {
        originalSelected = t.status == "Onboard" || t.status == "Completed";
      }

      if (_selectionState.containsKey(t.camperTransportId)) {
        isSelected = _selectionState[t.camperTransportId]!;
      } else {
        isSelected = originalSelected;
      }

      if (isSelected) {
        selectedIds.add(t.camperTransportId);
      }
    }

    if (selectedIds.isEmpty) {
      showCustomDialog(
        context,
        title: "Chưa chọn camper",
        message: "Vui lòng chọn ít nhất 1 camper để xác nhận.",
        type: DialogType.warning,
        btnText: "Đóng",
      );
      return;
    }

    final actionText = isCheckOutTab ? "xuống xe" : "lên xe";

    try {
      if (isCheckOutTab) {
        await provider.submitAttendanceCamperTransportCheckOut(
          camperTransportIds: selectedIds,
        );
      } else {
        await provider.submitAttendanceCamperTransportCheckIn(
          camperTransportIds: selectedIds,
        );
      }

      if (mounted) {
        _showStatusDialog(
          'Đã cập nhật danh sách $actionText thành công!',
          isSuccess: true,
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        _showStatusDialog(errorMessage, isSuccess: false);
      }
    }
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
        backgroundColor: StaffTheme.staffPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TransportReportCreateScreen(
          //       campId: widget.schedule.campName.campId,
          //       transportScheduleId: widget.schedule.transportScheduleId,
          //     ),
          //   ),
          // );
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransportReportCreateScreen(
                campId: widget.schedule.campName.campId,
                transportScheduleId: widget.schedule.transportScheduleId,
              ),
            ),
          );

          // Nếu tạo report thành công (trả về true), load lại dữ liệu
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: StaffTheme.staffAccent,
        icon: const Icon(Icons.report_problem_outlined, color: Colors.white),
        label: const Text(
          "Sự cố",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: StaffTheme.staffPrimary),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  color: StaffTheme.staffPrimary,
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
                    labelColor: StaffTheme.staffPrimary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: StaffTheme.staffPrimary,
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
            backgroundColor: StaffTheme.staffPrimary,
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
          "Không có camper tham gia",
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
        final String status = transport.status;

        String locationName = "Chưa cập nhật";

        if (isCheckOutMode) {
          locationName = _lastStopName;
        } else {
          int? camperLocationId = transport.location?.id;
          if (camperLocationId != null) {
            if (_routeStopLocationMap.containsKey(camperLocationId)) {
              locationName = _routeStopLocationMap[camperLocationId]!;
            } else {
              locationName = transport.location?.name ?? "Địa điểm lạ";
            }
          }
        }

        bool isPickedUp = status == "Onboard" || status == "Completed";

        bool isDroppedOff = status == "Completed";

        bool originalSelected = isCheckOutMode ? isDroppedOff : isPickedUp;

        bool isSelected = _selectionState.containsKey(id)
            ? _selectionState[id]!
            : originalSelected;

        bool isDisabled = false;
        if (isCheckOutMode) {
          if (status == "Assigned") isDisabled = true;
        } else {
          if (status == "Completed") isDisabled = true;
        }

        return Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    setState(() {
                      _selectionState[id] = !isSelected;
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
                      ? StaffTheme.staffPrimary
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
                        ? StaffTheme.staffPrimary.withValues(alpha: 0.1)
                        : Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: isSelected ? StaffTheme.staffPrimary : Colors.grey,
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
                        Row(
                          children: [
                            Icon(
                              isCheckOutMode ? Icons.flag : Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${isCheckOutMode ? 'Trả:' : 'Đón:'} $locationName",
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                        if (status == "Assigned" && isCheckOutMode)
                          const Text(
                            "Chưa lên xe",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (status == "Completed" && !isCheckOutMode)
                          const Text(
                            "Đã hoàn thành",
                            style: TextStyle(
                              color: Colors.green,
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
                          ? StaffTheme.staffPrimary
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? StaffTheme.staffPrimary
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
