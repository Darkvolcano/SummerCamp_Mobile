import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/registration_provider.dart';

class RegistrationListScreen extends StatelessWidget {
  const RegistrationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: ListView.builder(
        itemCount: provider.registrations.length,
        itemBuilder: (context, index) {
          final r = provider.registrations[index];
          return ListTile(
            title: Text("Camp ID: ${r.campId}"),
            subtitle: Text("Camper ID: ${r.camperId}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => provider.removeRegistration(r.id),
            ),
          );
        },
      ),
    );
  }
}
