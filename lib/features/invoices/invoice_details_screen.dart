import 'package:flutter/material.dart';

import '../../models/invoice_model.dart';
import '../../services/invoice_service.dart';
import 'edit_invoice_screen.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
  });

  Future<void> deleteInvoice(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Invoice"),
        content: const Text(
          "Are you sure you want to delete this invoice?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await InvoiceService().deleteInvoice(invoice.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invoice Deleted"),
      ),
    );

    Navigator.pop(context, true);
  }

  Widget detailCard({
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Color statusColor() {
    if (invoice.status == "Paid") {
      return Colors.green;
    }

    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
  final updated = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditInvoiceScreen(
        invoice: invoice,
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
            onPressed: () => deleteInvoice(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
                      detailCard(
            title: "Invoice Number",
            value: invoice.invoiceNumber,
          ),

          detailCard(
            title: "Client Name",
            value: invoice.clientName,
          ),

          detailCard(
            title: "Invoice Date",
            value:
                "${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}",
          ),

          detailCard(
            title: "Due Date",
            value:
                "${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}",
          ),

          detailCard(
            title: "Amount",
            value: "₹${invoice.amount.toStringAsFixed(2)}",
          ),

          detailCard(
            title: "GST",
            value: "${invoice.gst.toStringAsFixed(2)} %",
          ),

          detailCard(
            title: "GST Amount",
            value: "₹${invoice.gstAmount.toStringAsFixed(2)}",
          ),

          detailCard(
            title: "Total Amount",
            value: "₹${invoice.totalAmount.toStringAsFixed(2)}",
          ),

          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: const Text("Status"),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          detailCard(
            title: "Notes",
            value: invoice.notes.isEmpty
                ? "-"
                : invoice.notes,
          ),

          const SizedBox(height: 20),
                    SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PDF Generation - Coming Next"),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Generate PDF"),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Share Feature - Coming Next"),
                  ),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text("Share Invoice"),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Print Feature - Coming Next"),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text("Print Invoice"),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}