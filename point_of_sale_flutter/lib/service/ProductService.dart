
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/AuthService.dart';

import 'package:http_parser/http_parser.dart';

class ProductService {

  final AuthService authService = AuthService();

  final String apiUrl = 'http://localhost:8087/api/product/';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> productJson = json.decode(response.body);
      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }



  Future<Product?> createProduct(Product product, XFile? image, Uint8List? imageData) async {
    var uri = Uri.parse(apiUrl + 'save');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromString(
        'product',
        jsonEncode(product),
        contentType: MediaType('application', 'json'),
      ),
    );

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', image!.path),
      );
    }

    if (kIsWeb && imageData != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageData!,
        filename: 'upload.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image!.path,
      ));
    }

    final token = await authService.getToken();
    request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody.body) as Map<String, dynamic>;
        return Product.fromJson(data);
      } else {
        print('Error creating product: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating product: ${e.toString()}');
      return null;
    }
  }

  Future<List<Product>> getAllDhanmondiBranchProducts() async {
    final response = await http.get(Uri.parse('${apiUrl}dhanmondi'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products for Dhanmondi branch');
    }
  }

  Future<List<Product>> getAllBananiBranchProducts() async {
    final response = await http.get(Uri.parse('${apiUrl}banani'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products for Banani branch');
    }
  }

  Future<List<Product>> getAllGulshanBranchProducts() async {
    final response = await http.get(Uri.parse('${apiUrl}gulshan'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products for Gulshan branch');
    }
  }


  Future<void> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('http://localhost:8087/api/product/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update supplier');
    }
  }

  Future<void> deleteProduct(int? id) async {
    final response = await http
        .delete(Uri.parse('http://localhost:8087/api/product/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }


}

