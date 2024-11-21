import 'dart:convert';
import 'package:flutter/physics.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:shared_preferences/shared_preferences.dart';

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



  // Future<http.Response> createSales(String customername, DateTime salesdate, int totalprice, int quantity,
  //    Product product) async {
  //   final response = await http.post(
  //     Uri.parse(baseUrl),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'customername': customername,
  //       'salesdate': salesdate,
  //       'totalprice': totalprice,
  //       'quantity': quantity,
  //       'Product':product
  //     }), // Adjusted to use lowercase keys
  //   );
  //
  //   return response;
  // }





  // Create sales for Banani branch
  // Future<Sale> createSalesBonaniBranch(Sale sales) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}banani'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(sales.toJson()),
  //   );
  //   if (response.statusCode == 201) {
  //     return Sale.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to create sales for Banani branch');
  //   }
  // }

  // Create sales for Gulshan branch
  // Future<Sale> createSalesGulshanBranch(Sale sales) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}gulshan'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(sales.toJson()),
  //   );
  //   if (response.statusCode == 201) {
  //     return Sale.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to create sales for Gulshan branch');
  //   }
  // }

  // Delete a sale by ID
  // Future<void> deleteSales(int id) async {
  //   final response = await http.delete(Uri.parse('${baseUrl}delete/$id'));
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete sale with ID: $id');
  //   }
  // }

  // Update product stock
  // Future<Product> updateProductStock(int productId, int quantity) async {
  //   final response = await http.patch(
  //     Uri.parse('${baseUrl}/products/$productId/reduceStock'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({'quantity': quantity}),
  //   );
  //   if (response.statusCode == 200) {
  //     return Product.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to update product stock');
  //   }
  // }

  // Update a sale by ID
  // Future<Sale> updateSales(int id, Sale sale) async {
  //   final response = await http.put(
  //     Uri.parse('${baseUrl}$id'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(sale.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     return Sale.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to update sale with ID: $id');
  //   }
  // }

  // Get a sale by ID
  // Future<Sale> getSalesById(int saleId) async {
  //   final response = await http.get(Uri.parse('${baseUrl}$saleId'));
  //   if (response.statusCode == 200) {
  //     return Sale.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load sale with ID: $saleId');
  //   }
  // }
}


class CreateSalesService {
  final String apiUrl = 'http://localhost:8087/api/sales/dhanmondi';


  Future<http.Response> createSales(String customerName,
      DateTime salesDate,
      int totalPrice,
      int quantity,
      List<Product> products) async {
    // Convert product list to JSON


    List<Map<String, dynamic>> productJson = products.map((product) =>
        product.toJson()).toList();
    print(productJson);


    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customername': customerName,
        'salesdate': salesDate.toIso8601String(),
        'totalprice': totalPrice,
        'quantity': quantity,
        'product': productJson,
      }),
    );

    return response;
  }



  Future<http.Response> createSalesBananiBranch(String customerName,
      DateTime salesDate,
      int totalPrice,
      int quantity,
      List<Product> products) async {
    // Convert product list to JSON
    List<Map<String, dynamic>> productJson = products.map((product) =>
        product.toJson()).toList();

    print(productJson);
    final response = await http.post(
      Uri.parse("http://localhost:8087/api/sales/banani"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({

        'customername': customerName,
        'salesdate': salesDate.toIso8601String(),
        'totalprice': totalPrice,
        'quantity': quantity,
        'product': productJson,
      }),
    );

    return response;
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8087/api/product/'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      return []; // Return an empty list on error
    }
  }

  Future<Product> updateProductStock(int productId, int quantity) async {
    final url = Uri.parse('$apiUrl/products/$productId/reduceStock',);

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product stock');
    }
  }

}
