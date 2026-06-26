import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../services/firestore_service.dart';
import 'edit_client_screen.dart';

class ClientDetailsScreen extends StatelessWidget {
  final ClientModel client;

  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

  Future<void> _deleteClient(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Client"),
          content: const Text(
            "Are you sure you want to delete this client?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await FirestoreService().deleteClient(client.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Client deleted successfully"),
      ),
    );

    Navigator.pop(context, true);
  }

  Widget detailTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditClientScreen(
                    client: client,
                  ),
                ),
              );

              if (updated == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteClient(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            detailTile(
              "Business Name",
              client.businessName,
            ),
            detailTile(
              "Client Name",
              client.clientName,
            ),
            detailTile(
              "Mobile",
              client.mobile,
            ),
            detailTile(
              "Email",
              client.email,
            ),
            detailTile(
              "GST Number",
              client.gstNumber,
            ),
            detailTile(
              "Address",
              client.address,
            ),
            detailTile(
              "Monthly Fee",
              "₹${client.monthlyFee}",
            ),
          ],
        ),
      ),
    );
  }
}