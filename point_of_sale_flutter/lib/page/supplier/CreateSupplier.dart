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
      int sCell = int.parse(supplierCell.text);
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
          MaterialPageRoute(builder: (context) => SupplierListView()),
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
      appBar: AppBar(
        title: Text('Create Supplier'),
        centerTitle: true, // This centers the title
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundedTextField(supplierName, 'Supplier Name', Icons.support_rounded),
                SizedBox(height: 8),
                _buildRoundedTextField(supplierEmail, 'Supplier Email', Icons.email),
                SizedBox(height: 8),
                _buildRoundedTextField(supplierCell, 'Cell No', Icons.phone),
                SizedBox(height: 8),
                _buildRoundedTextField(supplierAddress, 'Address', Icons.location_city),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createSupplier,
                  child: Text(
                    "Create Supplier",
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

  // Reusable method to create a smaller, rounded TextField
  Widget _buildRoundedTextField(TextEditingController controller, String label, IconData icon) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 12), // Smaller font size
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Smaller padding for compact height
          labelText: label,
          labelStyle: TextStyle(fontSize: 12), // Smaller label font
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 18), // Smaller icon
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
