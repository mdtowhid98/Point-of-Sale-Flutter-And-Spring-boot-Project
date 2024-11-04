import 'package:flutter/material.dart';
import 'package:point_of_sale/page/supplier/AllSupplierView.dart';
import 'package:point_of_sale/service/SupplierService.dart';


class CreateSupplier extends StatefulWidget {
  const CreateSupplier({super.key});

  @override
  State<CreateSupplier> createState() => _CreateSupplierState();
}

class _CreateSupplierState extends State<CreateSupplier> {
  final TextEditingController supplierName = TextEditingController();
  final TextEditingController supplierEmail = TextEditingController();
  final TextEditingController supplierCell = TextEditingController();
  final TextEditingController supplierAddress = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final CreateSupplierService supplierService = CreateSupplierService();

  void _createSupplier() async {
    if (_formKey.currentState!.validate()) {
      String sName = supplierName.text;
      String sEmail = supplierEmail.text;
      int sCell = int.parse(supplierCell.text); // Kept as string
      String sAddress = supplierAddress.text;

      final response = await supplierService.createSupplier(sName, sEmail, sCell, sAddress);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Supplier created successfully!');
        supplierName.clear();
        supplierEmail.clear();
        supplierCell.clear();
        supplierAddress.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllSupplierView()),
        );
      } else if (response.statusCode == 409) {
        print('Supplier already exists!');
      } else {
        print('Supplier creation failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Supplier')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: supplierName,
                  decoration: InputDecoration(
                    labelText: 'Supplier Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.support_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a supplier name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: supplierEmail,
                  decoration: InputDecoration(
                    labelText: 'Supplier Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a supplier email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: supplierCell,
                  decoration: InputDecoration(
                    labelText: 'Cell No',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: supplierAddress,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createSupplier,
                  child: Text(
                    "Create Supplier", // Updated button text
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
