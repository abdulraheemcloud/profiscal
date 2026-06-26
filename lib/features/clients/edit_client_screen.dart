import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../services/firestore_service.dart';

class EditClientScreen extends StatefulWidget {
  final ClientModel client;

  const EditClientScreen({
    super.key,
    required this.client,
  });

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController businessNameController;
  late TextEditingController clientNameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController gstController;
  late TextEditingController addressController;
  late TextEditingController monthlyFeeController;

  final FirestoreService firestoreService = FirestoreService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    businessNameController =
        TextEditingController(text: widget.client.businessName);

    clientNameController =
        TextEditingController(text: widget.client.clientName);

    mobileController =
        TextEditingController(text: widget.client.mobile);

    emailController =
        TextEditingController(text: widget.client.email);

    gstController =
        TextEditingController(text: widget.client.gstNumber);

    addressController =
        TextEditingController(text: widget.client.address);

    monthlyFeeController =
        TextEditingController(text: widget.client.monthlyFee.toString());
  }

  @override
  void dispose() {
    businessNameController.dispose();
    clientNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    gstController.dispose();
    addressController.dispose();
    monthlyFeeController.dispose();
    super.dispose();
  }

  Future<void> updateClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final updatedClient = ClientModel(
      id: widget.client.id,
      businessName: businessNameController.text.trim(),
      clientName: clientNameController.text.trim(),
      mobile: mobileController.text.trim(),
      email: emailController.text.trim(),
      gstNumber: gstController.text.trim(),
      address: addressController.text.trim(),
      monthlyFee:
          double.tryParse(monthlyFeeController.text.trim()) ?? 0,
    );

    await firestoreService.updateClient(updatedClient);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Client updated successfully"),
      ),
    );

    Navigator.pop(context, true);
  }

  Widget buildField({
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
        title: const Text("Edit Client"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildField(
                controller: businessNameController,
                label: "Business Name",
              ),

              buildField(
                controller: clientNameController,
                label: "Client Name",
              ),

              buildField(
                controller: mobileController,
                label: "Mobile",
                keyboardType: TextInputType.phone,
              ),

              buildField(
                controller: emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
              ),

              buildField(
                controller: gstController,
                label: "GST Number",
              ),

              buildField(
                controller: addressController,
                label: "Address",
              ),

              buildField(
                controller: monthlyFeeController,
                label: "Monthly Fee",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateClient,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Update Client"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}