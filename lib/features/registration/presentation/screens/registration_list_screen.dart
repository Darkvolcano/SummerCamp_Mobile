import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RegistrationListScreen extends StatelessWidget {
  const RegistrationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Danh sách trại hè đã đăng ký",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Body: loading / empty / danh sách
            Expanded(
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.registrations.isEmpty
                  ? const Center(
                      child: Text(
                        "Không có trại hè nào đã được đăng ký",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.registrations.length,
                      itemBuilder: (context, index) {
                        final r = provider.registrations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 4,
                          ),
                          child: ListTile(
                            title: Text("Camp ID: ${r.campId}"),
                            subtitle: Text("Camper ID: ${r.camperId}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  provider.removeRegistration(r.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
