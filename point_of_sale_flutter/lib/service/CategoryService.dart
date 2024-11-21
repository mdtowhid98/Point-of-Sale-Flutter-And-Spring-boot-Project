import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:point_of_sale/model/CategoryModel.dart';

class CategoryService {
  final String apiUrl = 'http://localhost:8087/api/category/';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> categoryJson = json.decode(response.body);
      return categoryJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }


  Future<void> updateCategories(int id, Category category) async {
    final response = await http.put(
      Uri.parse('http://localhost:8087/api/category/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }


  Future<void> deleteCategory(int? id) async {
    final response = await http
        .delete(Uri.parse('http://localhost:8087/api/category/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }


}

class CreateCategoryService {
  final String apiUrl = 'http://localhost:8087/api/category/save';

  Future<http.Response> createCategory(String categoryName) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'categoryname': categoryName
      }), // Adjust according to your API's expected payload
    );

    return response;
  }
}



