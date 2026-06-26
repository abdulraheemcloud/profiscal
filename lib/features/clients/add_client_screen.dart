import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../services/firestore_service.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _addressController = TextEditingController();
  final _monthlyFeeController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _clientNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _monthlyFeeController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final client = ClientModel(
        businessName: _businessNameController.text.trim(),
        clientName: _clientNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        gstNumber: _gstController.text.trim(),
        address: _addressController.text.trim(),
        monthlyFee:
            double.tryParse(_monthlyFeeController.text.trim()) ?? 0,
      );

      await _firestoreService.addClient(client);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Client Added Successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Client"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                controller: _businessNameController,
                label: "Business Name",
              ),
              buildTextField(
                controller: _clientNameController,
                label: "Client Name",
              ),
              buildTextField(
                controller: _mobileController,
                label: "Mobile Number",
                keyboardType: TextInputType.phone,
              ),
              buildTextField(
                controller: _emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                requiredField: false,
              ),
              buildTextField(
                controller: _gstController,
                label: "GST Number",
                requiredField: false,
              ),
              buildTextField(
                controller: _addressController,
                label: "Address",
                maxLines: 3,
              ),
              buildTextField(
                controller: _monthlyFeeController,
                label: "Monthly Fee",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveClient,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save Client",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}