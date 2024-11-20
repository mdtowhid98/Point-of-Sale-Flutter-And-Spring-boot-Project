import 'package:flutter/material.dart';
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/service/SupplierService.dart';

class UpdateSupplierView extends StatefulWidget {
  final Supplier supplier;

  const UpdateSupplierView({Key? key, required this.supplier}) : super(key: key);

  @override
  State<UpdateSupplierView> createState() => _UpdateSupplierViewState();
}

class _UpdateSupplierViewState extends State<UpdateSupplierView> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  late String cell;
  late String address;

  @override
  void initState() {
    super.initState();
    name = widget.supplier.name ?? '';
    email = widget.supplier.email ?? '';
    cell = widget.supplier.cell?.toString() ?? '';
    address = widget.supplier.address ?? '';
  }

  Future<void> _updateSupplier() async {
    if (_formKey.currentState!.validate()) {
      final updatedSupplier = Supplier(
        id: widget.supplier.id,
        name: name,
        email: email,
        cell: int.parse(cell),
        address: address,
      );
      try {
        await SupplierService().updateSupplier(widget.supplier.id!, updatedSupplier);
        Navigator.pop(context); // Go back after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Supplier: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Supplier'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lime, Colors.lightGreenAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildRoundedTextField(name, 'Supplier Name', Icons.support_rounded, (value) {
                  name = value;
                }),
                SizedBox(height: 8),
                _buildRoundedTextField(email, 'Email', Icons.email, (value) {
                  email = value;
                }),
                SizedBox(height: 8),
                _buildRoundedTextField(cell, 'Cell Number', Icons.phone, (value) {
                  cell = value;
                }, isNumeric: true),
                SizedBox(height: 8),
                _buildRoundedTextField(address, 'Address', Icons.location_city, (value) {
                  address = value;
                }),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateSupplier,
                  child: Text(
                    "Update Supplier",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(String initialValue, String label, IconData icon,
      Function(String) onChanged, {bool isNumeric = false}) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumeric && int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
