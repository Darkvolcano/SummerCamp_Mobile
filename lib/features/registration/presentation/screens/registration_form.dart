import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RegistrationForm extends StatefulWidget {
  final Camp camp;
  const RegistrationForm({super.key, required this.camp});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _camperIdController = TextEditingController();
  final _paymentIdController = TextEditingController();
  final _promotionIdController = TextEditingController();
  final _promotionCodeController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RegistrationProvider>();
    final camp = widget.camp;

    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký trại")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trại: ${camp.name}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _camperIdController,
              decoration: const InputDecoration(labelText: "Camper ID"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _paymentIdController,
              decoration: const InputDecoration(labelText: "Payment ID"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _promotionIdController,
              decoration: const InputDecoration(
                labelText: "Promotion ID (không bắt buộc)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _promotionCodeController,
              decoration: const InputDecoration(
                labelText: "Promotion Code (không bắt buộc)",
              ),
            ),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: "Discount (không bắt buộc)",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final r = Registration(
                  id: DateTime.now().millisecondsSinceEpoch,
                  campId: camp.id,
                  camperId: int.tryParse(_camperIdController.text) ?? 0,
                  paymentId: int.tryParse(_paymentIdController.text) ?? 0,
                  registrationCreateAt: DateTime.now(),
                  status: "pending",
                  price: camp.price,
                  promotionId: _promotionIdController.text.isEmpty
                      ? null
                      : int.tryParse(_promotionIdController.text),
                  promotionCode: _promotionCodeController.text.isEmpty
                      ? null
                      : _promotionCodeController.text,
                  discount: _discountController.text.isEmpty
                      ? 0
                      : int.tryParse(_discountController.text) ?? 0,
                  campName: camp.name,
                  campDescription: camp.description,
                  campPlace: camp.place,
                  campStartDate: camp.startDate,
                  campEndDate: camp.endDate,
                );

                provider.addRegistration(r);
                Navigator.pop(context);
              },
              child: const Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
