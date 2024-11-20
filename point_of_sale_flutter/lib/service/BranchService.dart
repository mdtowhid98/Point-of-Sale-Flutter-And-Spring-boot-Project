
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:point_of_sale/model/BranchModel.dart';

class BranchService {

  final String apiUrl = 'http://localhost:8087/api/branch/';

  Future<List<Branch>> fetchBranches() async {
    final response = await http.get(Uri.parse(apiUrl));



    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> branchJson = json.decode(response.body);

      return branchJson.map((json) => Branch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }


  Future<void> updateBranches(int id, Branch branch) async {
    final response = await http.put(
      Uri.parse('http://localhost:8087/api/branch/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(branch.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update branch');
    }
  }


  Future<void> deleteBranch(int? id) async {
    final response = await http
        .delete(Uri.parse('http://localhost:8087/api/branch/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete branch');
    }
  }



}



class CreateBranchService {
  final String apiUrl = 'http://localhost:8087/api/branch/save';

  Future<http.Response> createBranch(String branchName, String location) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'branchName': branchName, // Updated to use 'branchName'
        'location': location,
      }),
    );

    return response;
  }
}