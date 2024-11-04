import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/Sale.dart';


class SalesService {
  final String baseUrl = "http://localhost:8087/api/sales/";

  // Get all sales
  Future<List<Sale>> getAllSales() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Sale.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  // Get all sales for sales product
  Future<List<Sale>> getAllSalesForSalesProduct() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Sale.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load sales for products');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }

  // Create sales for Dhanmondi branch
  Future<Sale> createSales(Sale sales) async {
    final response = await http.post(
      Uri.parse('${baseUrl}dhanmondi'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sales.toJson()),
    );
    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sales for Dhanmondi branch');
    }
  }

  // Create sales for Banani branch
  Future<Sale> createSalesBonaniBranch(Sale sales) async {
    final response = await http.post(
      Uri.parse('${baseUrl}banani'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sales.toJson()),
    );
    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sales for Banani branch');
    }
  }

  // Create sales for Gulshan branch
  Future<Sale> createSalesGulshanBranch(Sale sales) async {
    final response = await http.post(
      Uri.parse('${baseUrl}gulshan'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sales.toJson()),
    );
    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sales for Gulshan branch');
    }
  }

  // Delete a sale by ID
  Future<void> deleteSales(int id) async {
    final response = await http.delete(Uri.parse('${baseUrl}delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete sale with ID: $id');
    }
  }

  // Update product stock
  Future<Product> updateProductStock(int productId, int quantity) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}/products/$productId/reduceStock'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'quantity': quantity}),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product stock');
    }
  }

  // Update a sale by ID
  Future<Sale> updateSales(int id, Sale sale) async {
    final response = await http.put(
      Uri.parse('${baseUrl}$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sale.toJson()),
    );
    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update sale with ID: $id');
    }
  }

  // Get a sale by ID
  Future<Sale> getSalesById(int saleId) async {
    final response = await http.get(Uri.parse('${baseUrl}$saleId'));
    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sale with ID: $saleId');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:point_of_sale/model/ProductModel.dart';
// import 'package:point_of_sale/model/Sale.dart';
//
//
// class SalesService {
//   final String baseUrl = "http://localhost:8087/api/sales/";
//
//   Future<List<Sale>> getAllSales() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((item) => Sale.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load sales');
//     }
//   }
//
//   Future<Sale> createSales(Sale sale) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(sale.toJson()),
//     );
//     if (response.statusCode == 201) {
//       return Sale.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to create sale');
//     }
//   }
//
//   Future<void> deleteSales(int id) async {
//     final response = await http.delete(Uri.parse('$baseUrl$id'));
//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete sale with ID: $id');
//     }
//   }
//
//   Future<Product> updateProductStock(int productId, int quantity) async {
//     final response = await http.patch(
//       Uri.parse('$baseUrl/products/$productId/reduceStock'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'quantity': quantity}),
//     );
//     if (response.statusCode == 200) {
//       return Product.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to update product stock');
//     }
//   }
//
//   Future<Sale> getSalesById(int saleId) async {
//     final response = await http.get(Uri.parse('$baseUrl$saleId'));
//     if (response.statusCode == 200) {
//       return Sale.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load sale with ID: $saleId');
//     }
//   }
// }
