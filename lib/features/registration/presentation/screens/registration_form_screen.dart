import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RegistrationFormScreen extends StatefulWidget {
  final Camp camp;
  const RegistrationFormScreen({super.key, required this.camp});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _promotionCodeController = TextEditingController();
  int _selectedPaymentId = 1;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RegistrationProvider>();
    final camp = widget.camp;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng ký trại",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camp.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: "Fredoka",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      camp.description,
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: "Nunito",
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
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
                          "${DateFormatter.formatDate(camp.startDate)} - ${DateFormatter.formatDate(camp.endDate)}",
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Nunito",
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Phương thức thanh toán",
              style: textTheme.titleMedium?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<int>(
              groupValue: _selectedPaymentId,
              onChanged: (val) {
                if (val != null) setState(() => _selectedPaymentId = val);
              },
              child: Column(
                children: [
                  RadioMenuButton<int>(
                    value: 1,
                    groupValue: _selectedPaymentId,
                    onChanged: (val) =>
                        setState(() => _selectedPaymentId = val!),
                    child: const Text("Chuyển khoản ngân hàng"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _promotionCodeController,
              decoration: InputDecoration(
                labelText: "Mã khuyến mãi (nếu có)",
                prefixIcon: const Icon(Icons.discount),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                  final r = Registration(
                    id: DateTime.now().millisecondsSinceEpoch,
                    campId: camp.id,
                    camperId: 1,
                    paymentId: _selectedPaymentId,
                    registrationCreateAt: DateTime.now(),
                    status: "pending",
                    price: camp.price,
                    promotionId: null,
                    promotionCode: _promotionCodeController.text.isEmpty
                        ? null
                        : _promotionCodeController.text,
                    discount: 0,
                    campName: camp.name,
                    campDescription: camp.description,
                    campPlace: camp.place,
                    campStartDate: camp.startDate,
                    campEndDate: camp.endDate,
                  );

                  provider.addRegistration(r);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.assignment),
                label: Text(
                  "Hoàn tất đăng ký",
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
