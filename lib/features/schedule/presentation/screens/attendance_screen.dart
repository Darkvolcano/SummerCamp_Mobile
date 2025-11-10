import 'package:flutter/material.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

enum AttendanceStatus { absent, late, present }

class AttendanceScreen extends StatefulWidget {
  final List<Camper> campers;
  final Camp camp;

  const AttendanceScreen({
    super.key,
    required this.campers,
    required this.camp,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final Map<int, AttendanceStatus> attendance = {};

  @override
  void initState() {
    super.initState();
    for (var camper in widget.campers) {
      attendance[camper.camperId] = AttendanceStatus.absent;
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
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: isSelected
            ? const Icon(Icons.circle, size: 10, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double statusColWidth = 40;
    const double genderColWidth = 70;

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
                    Center(
                      child: Text(
                        "L",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
                      : Colors.transparent, // zebra row
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
                      4: FixedColumnWidth(statusColWidth),
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
                            camper.gender,
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
                              AttendanceStatus.late,
                              Colors.orange,
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
        onPressed: () {
          final total = widget.campers.length;
          final presentCount = attendance.values
              .where((s) => s == AttendanceStatus.present)
              .length;
          final lateCount = attendance.values
              .where((s) => s == AttendanceStatus.late)
              .length;
          final absentCount = attendance.values
              .where((s) => s == AttendanceStatus.absent)
              .length;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: StaffTheme.staffPrimary,
              content: Text(
                "Kết quả: P=$presentCount, L=$lateCount, A=$absentCount / $total",
                style: const TextStyle(fontFamily: "Quicksand"),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text("Lưu", style: TextStyle(fontFamily: "Quicksand")),
      ),
    );
  }
}
