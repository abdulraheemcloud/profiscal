import 'package:flutter/material.dart';

import '../../models/invoice_model.dart';
import '../../services/invoice_service.dart';
import 'add_invoice_screen.dart';
import 'invoice_details_screen.dart';

class InvoicesScreen extends StatelessWidget {
  InvoicesScreen({super.key});

  final InvoiceService invoiceService = InvoiceService();

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoices"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddInvoiceScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<InvoiceModel>>(
        stream: invoiceService.getInvoices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final invoices = snapshot.data ?? [];

          if (invoices.isEmpty) {
            return const Center(
              child: Text(
                "No Invoices Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getStatusColor(invoice.status),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    invoice.invoiceNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoice.clientName),
                      Text("₹${invoice.totalAmount.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: Chip(
                    backgroundColor: getStatusColor(invoice.status),
                    label: Text(
                      invoice.status,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InvoiceDetailsScreen(
        invoice: invoice,
      ),
    ),
  );
},
                ),
              );
            },
          );
        },
      ),
    );
  }
}