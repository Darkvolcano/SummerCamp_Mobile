import 'package:flutter/material.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import '../../../../core/config/staff_theme.dart';

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
  final Map<int, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    for (var camper in widget.campers) {
      attendance[camper.id] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Điểm danh",
          style: TextStyle(fontFamily: "Fredoka", fontWeight: FontWeight.bold),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: widget.campers.isEmpty
          ? const Center(
              child: Text(
                "Không có camper nào",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.campers.length,
              itemBuilder: (context, index) {
                final camper = widget.campers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: StaffTheme.staffAccent,
                      radius: 24,
                      child: Text(
                        camper.fullName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      camper.fullName,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "DOB: ${camper.dob} • ${camper.gender}",
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Switch(
                      activeThumbColor: StaffTheme.staffPrimary,
                      value: attendance[camper.id] ?? false,
                      onChanged: (val) {
                        setState(() {
                          attendance[camper.id] = val;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: StaffTheme.staffAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          final presentCount = attendance.values
              .where((present) => present)
              .length;
          final total = widget.campers.length;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: StaffTheme.staffPrimary,
              content: Text(
                "Đã lưu điểm danh: $presentCount/$total tham gia",
                style: const TextStyle(fontFamily: "Nunito"),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text("Lưu", style: TextStyle(fontFamily: "Nunito")),
      ),
    );
  }
}
