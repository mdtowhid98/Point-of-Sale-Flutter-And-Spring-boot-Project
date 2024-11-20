// import 'package:flutter/material.dart';
// import 'package:point_of_sale/model/ProductModel.dart';
// import 'package:point_of_sale/service/ProductService.dart';
//
//
// class UpdateProductView extends StatefulWidget {
//   final Product product;
//
//   const UpdateProductView({Key? key, required this.product}) : super(key: key);
//
//   @override
//   State<UpdateProductView> createState() => _UpdateProductViewState();
// }
//
// class _UpdateProductViewState extends State<UpdateProductView> {
//   final _formKey = GlobalKey<FormState>();
//   late String name;
//   late String unitprice;
//   late String stock;
//   // late String address;
//
//   @override
//   void initState() {
//     super.initState();
//     name = widget.product.name ?? '';
//     unitprice = widget.product.unitprice ?.toString()?? '';
//     stock = widget.product.stock?.toString() ?? '';
//     // address = widget.supplier.address ?? '';
//   }
//
//   Future<void> _updateProduct() async {
//     if (_formKey.currentState!.validate()) {
//       final updatedProduct = Product(
//         id: widget.product.id,
//         name: name,
//         unitprice: int.parse(unitprice),
//         stock: int.parse(stock),
//         // address: address,
//       );
//       try {
//         await ProductService().updateProduct(widget.product.id!, updatedProduct);
//
//         Navigator.pop(context); // Go back after updating
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update Product: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Product'),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lime, Colors.lightGreenAccent, Colors.yellowAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildRoundedTextField(name, 'Product Name', Icons.support_rounded, (value) {
//                   name = value;
//                 }),
//                 SizedBox(height: 8),
//                 _buildRoundedTextField(unitprice, 'Unit Price', Icons.price_check, (value) {
//                   unitprice = value;
//                 }),
//                 SizedBox(height: 8),
//                 _buildRoundedTextField(stock, 'Stock', Icons.inventory, (value) {
//                   stock = value;
//                 }, isNumeric: true),
//                 SizedBox(height: 8),
//                 // _buildRoundedTextField(address, 'Address', Icons.location_city, (value) {
//                 //   address = value;
//                 // }),
//                 // SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _updateProduct,
//                   child: Text(
//                     "Update Product",
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoundedTextField(String initialValue, String label, IconData icon,
//       Function(String) onChanged, {bool isNumeric = false}) {
//     return Container(
//       width: double.infinity,
//       child: TextFormField(
//         initialValue: initialValue,
//         onChanged: onChanged,
//         keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//         style: TextStyle(fontSize: 12),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//           labelText: label,
//           labelStyle: TextStyle(fontSize: 12),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: Colors.blueAccent),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           prefixIcon: Icon(icon, color: Colors.blueAccent, size: 18),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $label';
//           }
//           if (isNumeric && int.tryParse(value) == null) {
//             return 'Please enter a valid number';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
