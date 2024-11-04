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
        // Handle error (e.g., show a message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Supplier: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Supplier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Supplier Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Supplier name';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: cell,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cell Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Cell Number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  cell = value;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: address,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Address';
                  }
                  return null;
                },
                onChanged: (value) {
                  address = value;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _updateSupplier,
                child: Text('Update Supplier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}