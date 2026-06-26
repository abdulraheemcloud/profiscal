import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/client_model.dart';
import '../../models/invoice_model.dart';
import '../../services/firestore_service.dart';
import '../../services/invoice_service.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final InvoiceService invoiceService = InvoiceService();
  final FirestoreService clientService = FirestoreService();

  final amountController = TextEditingController();
  final gstController = TextEditingController(text: "18");
  final notesController = TextEditingController();

  List<ClientModel> clients = [];
  ClientModel? selectedClient;

  DateTime invoiceDate = DateTime.now();
  DateTime dueDate = DateTime.now().add(const Duration(days: 30));

  String status = "Pending";

  bool loading = false;

  String invoiceNumber = "";

  @override
  void initState() {
    super.initState();
    loadClients();
    generateInvoiceNumber();
  }

  Future<void> loadClients() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("clients")
        .orderBy("businessName")
        .get();

    clients = snapshot.docs.map((doc) {
      return ClientModel.fromFirestore(
        doc.id,
        doc.data(),
      );
    }).toList();

    if (clients.isNotEmpty) {
      selectedClient = clients.first;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> generateInvoiceNumber() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("invoices")
        .get();

    final next = snapshot.docs.length + 1;

    invoiceNumber = "INV-${next.toString().padLeft(4, '0')}";

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> pickInvoiceDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: invoiceDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        invoiceDate = picked;
      });
    }
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: invoiceDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }
    Future<void> saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a client"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final invoice = InvoiceModel(
      invoiceNumber: invoiceNumber,
      clientId: selectedClient!.id!,
      clientName: selectedClient!.businessName,
      invoiceDate: invoiceDate,
      dueDate: dueDate,
      amount: double.parse(amountController.text),
      gst: double.parse(gstController.text),
      status: status,
      notes: notesController.text.trim(),
    );

    await invoiceService.addInvoice(invoice);

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invoice Created Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Invoice"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      initialValue: invoiceNumber,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Invoice Number",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<ClientModel>(
                      value: selectedClient,
                      decoration: const InputDecoration(
                        labelText: "Select Client",
                        border: OutlineInputBorder(),
                      ),
                      items: clients.map((client) {
                        return DropdownMenuItem(
                          value: client,
                          child: Text(client.businessName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClient = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    buildTextField(
                      controller: amountController,
                      label: "Amount",
                      keyboardType: TextInputType.number,
                    ),

                    buildTextField(
                      controller: gstController,
                      label: "GST %",
                      keyboardType: TextInputType.number,
                    ),

                    buildTextField(
                      controller: notesController,
                      label: "Notes",
                    ),
                                        const SizedBox(height: 10),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text("Invoice Date"),
                        subtitle: Text(
                          "${invoiceDate.day}/${invoiceDate.month}/${invoiceDate.year}",
                        ),
                        trailing: const Icon(Icons.edit_calendar),
                        onTap: pickInvoiceDate,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.event),
                        title: const Text("Due Date"),
                        subtitle: Text(
                          "${dueDate.day}/${dueDate.month}/${dueDate.year}",
                        ),
                        trailing: const Icon(Icons.edit_calendar),
                        onTap: pickDueDate,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Pending",
                          child: Text("Pending"),
                        ),
                        DropdownMenuItem(
                          value: "Paid",
                          child: Text("Paid"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            status = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: saveInvoice,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Save Invoice",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    gstController.dispose();
    notesController.dispose();
    super.dispose();
  }
}