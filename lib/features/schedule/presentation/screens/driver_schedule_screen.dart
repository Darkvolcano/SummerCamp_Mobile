import 'package:flutter/material.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';

class DriverScheduleScreen extends StatefulWidget {
  const DriverScheduleScreen({super.key});

  @override
  State<DriverScheduleScreen> createState() => _DriverScheduleScreenState();
}

class _DriverScheduleScreenState extends State<DriverScheduleScreen> {
  final List<Map<String, dynamic>> _trips = [
    {
      "id": 1,
      "task": "Đón camper tại Quận 1",
      "from": "Nhà văn hóa Thanh Niên",
      "to": "Khu sinh thái FPT Campus",
      "startTime": DateTime.now().add(const Duration(hours: 1)),
      "endTime": DateTime.now().add(const Duration(hours: 2)),
      "status": "Sắp tới",
    },
    {
      "id": 2,
      "task": "Đưa camper về Quận 7",
      "from": "Khu sinh thái FPT Campus",
      "to": "Trường Đinh Thiện Lý",
      "startTime": DateTime.now().add(const Duration(hours: 8)),
      "endTime": DateTime.now().add(const Duration(hours: 9)),
      "status": "Sắp tới",
    },
    {
      "id": 3,
      "task": "Đón camper tại Gò Vấp",
      "from": "Công viên Gia Định",
      "to": "Khu sinh thái FPT Campus",
      "startTime": DateTime.now().subtract(const Duration(hours: 2)),
      "endTime": DateTime.now().subtract(const Duration(hours: 1)),
      "status": "Đã hoàn thành",
    },
  ];

  void _updateLocation(int tripId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã cập nhật vị trí cho chuyến #$tripId'),
        backgroundColor: DriverTheme.driverPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch làm việc",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: DriverTheme.driverPrimary,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          final bool isCompleted = trip['status'] == "Đã hoàn thành";

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hàng 1: Thời gian và Trạng thái
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateFormatter.formatTime(trip['startTime'])} - ${DateFormatter.formatTime(trip['endTime'])}",
                        style: textTheme.bodyLarge?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          color: DriverTheme.driverAccent,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.grey.shade200
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          trip['status'],
                          style: textTheme.bodySmall?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.grey.shade700
                                : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trip['task'],
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  // Hàng 2: Từ đâu
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: DriverTheme.driverAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Từ:",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Quicksand",
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip['from'],
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Hàng 3: Đến đâu
                  Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        color: DriverTheme.driverPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Đến:",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Quicksand",
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip['to'],
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Hàng 4: Nút hành động
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DriverTheme.driverPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      // Vô hiệu hóa nút nếu đã hoàn thành
                      onPressed: isCompleted
                          ? null
                          : () => _updateLocation(trip['id']),
                      icon: const Icon(Icons.location_on, size: 20),
                      label: Text(
                        isCompleted ? "Đã hoàn thành" : "Cập nhật vị trí",
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
