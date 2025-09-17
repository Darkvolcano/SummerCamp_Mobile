import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_form.dart';

class CampDetailScreen extends StatelessWidget {
  final Camp camp;
  const CampDetailScreen({super.key, required this.camp});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          camp.name,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: Image.network(
                camp.image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camp.name,
                    style: textTheme.headlineSmall?.copyWith(
                      fontFamily: "Fredoka",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    camp.description,
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: "Nunito",
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(
                        camp.place,
                        style: textTheme.bodyLarge?.copyWith(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${camp.startDate.toLocal().toString().split(' ')[0]} - ${camp.endDate.toLocal().toString().split(' ')[0]}",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Nunito",
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Tối đa: ${camp.maxParticipants} người",
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Nunito",
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        PriceFormatter.format(camp.price),
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.bold,
                          color: AppTheme.summerAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.summerAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegistrationForm(camp: camp),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment),
                      label: Text(
                        "Đăng ký ngay",
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
