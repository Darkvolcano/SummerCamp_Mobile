import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _campIdController = TextEditingController();
  final _camperIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RegistrationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký trại")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _campIdController,
              decoration: const InputDecoration(labelText: "Camp ID"),
            ),
            TextField(
              controller: _camperIdController,
              decoration: const InputDecoration(labelText: "Camper ID"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final r = Registration(
                  id: DateTime.now().toString(),
                  campId: _campIdController.text,
                  camperId: _camperIdController.text,
                  date: DateTime.now(),
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
