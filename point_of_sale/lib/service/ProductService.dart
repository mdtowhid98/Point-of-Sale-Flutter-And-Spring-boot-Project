
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/AuthService.dart';

class ProductService {

  final Dio _dio = Dio();

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



  Future<Product?> createProduct(Product product, XFile? image) async {
    final formData = FormData();

    formData.fields.add(MapEntry('product', jsonEncode(product.toJson())));

    if (image != null) {
      final bytes = await image.readAsBytes();
      formData.files.add(MapEntry('image', MultipartFile.fromBytes(
        bytes,
        filename: image.name,
      )));
    }

    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.post(
        '${apiUrl}save',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Product.fromJson(data); // Parse response data to Hotel object
      } else {
        print('Error creating product: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Error creating product: ${e.message}');
      return null;
    }
  }

}

