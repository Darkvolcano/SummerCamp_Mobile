import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';

enum AttendanceStatus { absent, present, notYet }

class AttendanceScreen extends StatefulWidget {
  final List<Camper> campers;
  final Schedule schedule;

  const AttendanceScreen({
    super.key,
    required this.campers,
    required this.schedule,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final Map<int, AttendanceStatus> attendance = {};

  final Map<int, int> logIds = {};

  @override
  void initState() {
    super.initState();
    for (var camper in widget.campers) {
      if (camper.attendanceLogId != null) {
        logIds[camper.camperId] = camper.attendanceLogId!;
      }

      if (camper.status == "Present") {
        attendance[camper.camperId] = AttendanceStatus.present;
      } else if (camper.status == "Absent") {
        attendance[camper.camperId] = AttendanceStatus.absent;
      } else {
        attendance[camper.camperId] = AttendanceStatus.notYet;
      }
    }
  }

  Future<void> _submitAttendance() async {
    final provider = context.read<AttendanceProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    List<UpdateAttendance> requests = [];

    attendance.forEach((camperId, status) {
      if (logIds.containsKey(camperId)) {
        String statusString;
        if (status == AttendanceStatus.present) {
          statusString = "Present";
        } else {
          statusString = "Absent";
        }

        requests.add(
          UpdateAttendance(
            attendanceLogId: logIds[camperId]!,
            participantStatus: statusString,
            note: "",
          ),
        );
      }
    });

    if (requests.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Không có dữ liệu để lưu")),
      );
      return;
    }

    try {
      await provider.submitAttendance(requests);

      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Cập nhật điểm danh thành công!"),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text("Lỗi: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatusCell(int camperId, AttendanceStatus status, Color color) {
    final current = attendance[camperId];
    final isSelected = current == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          attendance[camperId] = status;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: isSelected
            ? const Icon(Icons.circle, size: 12, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double statusColWidth = 40;
    const double genderColWidth = 70;
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Điểm danh",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: StaffTheme.staffPrimary,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FixedColumnWidth(genderColWidth),
                2: FixedColumnWidth(statusColWidth),
                3: FixedColumnWidth(statusColWidth),
                4: FixedColumnWidth(statusColWidth),
              },
              children: const [
                TableRow(
                  children: [
                    Text(
                      "Tên",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Giới tính",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                        fontSize: 16,
                      ),
                    ),
                    Center(
                      child: Text(
                        "A",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Text(
                    //     "L",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: Text(
                        "P",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.campers.length,
              itemBuilder: (context, index) {
                final camper = widget.campers[index];
                return Container(
                  color: index.isEven
                      ? Colors.grey.shade100
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FixedColumnWidth(genderColWidth),
                      2: FixedColumnWidth(statusColWidth),
                      3: FixedColumnWidth(statusColWidth),
                      // 4: FixedColumnWidth(statusColWidth),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            camper.camperName,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            camper.gender == 'Female' ? 'Nữ' : 'Nam',
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 16,
                            ),
                          ),
                          Center(
                            child: _buildStatusCell(
                              camper.camperId,
                              AttendanceStatus.absent,
                              Colors.red,
                            ),
                          ),
                          Center(
                            child: _buildStatusCell(
                              camper.camperId,
                              AttendanceStatus.present,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: StaffTheme.staffAccent,
        foregroundColor: Colors.white,
        // onPressed: () {
        //   final total = widget.campers.length;
        //   final presentCount = attendance.values
        //       .where((s) => s == AttendanceStatus.present)
        //       .length;
        //   // final lateCount = attendance.values
        //   //     .where((s) => s == AttendanceStatus.late)
        //   //     .length;
        //   final absentCount = attendance.values
        //       .where((s) => s == AttendanceStatus.absent)
        //       .length;

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       backgroundColor: StaffTheme.staffPrimary,
        //       content: Text(
        //         "Kết quả: P=$presentCount, A=$absentCount / $total",
        //         style: const TextStyle(fontFamily: "Quicksand"),
        //       ),
        //       duration: const Duration(seconds: 2),
        //     ),
        //   );
        // },
        onPressed: provider.loading ? null : _submitAttendance,
        icon: const Icon(Icons.save),
        label: const Text("Lưu", style: TextStyle(fontFamily: "Quicksand")),
      ),
    );
  }
}
