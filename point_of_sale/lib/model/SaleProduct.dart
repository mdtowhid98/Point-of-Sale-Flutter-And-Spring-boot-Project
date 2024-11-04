// // model/SaleProduct.dart
//
//
// import 'package:point_of_sale/model/ProductModel.dart';
//
// class SaleProduct {
//   Product? product; // Reference to the Product type
//   int unitPrice = 0;
//   int quantity = 0;
//   int stock = 0;
//
//   SaleProduct();
//
//   Map<String, dynamic> toJson() {
//     return {
//       'product': product?.toJson(), // Ensure Product class has a toJson method
//       'unitPrice': unitPrice,
//       'quantity': quantity,
//       'stock': stock,
//     };
//   }
//
//   // Optionally, you can also create a factory constructor to initialize from JSON
//   SaleProduct.fromJson(Map<String, dynamic> json) {
//     // Assuming Product also has a fromJson method
//     product = Product.fromJson(json['product']);
//     unitPrice = json['unitPrice'];
//     quantity = json['quantity'];
//     stock = json['stock'];
//   }
// }
