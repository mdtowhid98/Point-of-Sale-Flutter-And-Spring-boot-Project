import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:point_of_sale/model/SupplierModel.dart';


class SupplierService {
  final String apiUrl = 'http://localhost:8087/api/supplier/';

  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> supplierJson = json.decode(response.body);
      return supplierJson.map((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }

  Future<void> updateSupplier(int id, Supplier supplier) async {
    final response = await http.put(
      Uri.parse('http://localhost:8087/api/supplier/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(supplier.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update supplier');
    }
  }


  Future<void> deleteSupplier(int? id) async {
    final response = await http
        .delete(Uri.parse('http://localhost:8087/api/supplier/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier');
    }
  }


}

class CreateSupplierService {
  final String apiUrl = 'http://localhost:8087/api/supplier/save';

  Future<http.Response> createSupplier(String name, String email, int cell, String address) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'cell': cell,
        'address': address,
      }), // Adjusted to use lowercase keys
    );

    return response;
  }
}