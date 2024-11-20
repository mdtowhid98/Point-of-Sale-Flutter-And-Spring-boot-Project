import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/model/SalesDetails.dart';

class SalesDetailsService {
  final String baseUrl = "http://localhost:8087/api/salesdetails/";

  // Fetch all sales details
  Future<List<SalesDetails>> getAllSalesDetails() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SalesDetails.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sales details');
    }
  }



  // Fetch grouped sales details
  Future<Map<int, List<SalesDetails>>> getGroupedSalesDetails() async {
    final response = await http.get(Uri.parse('${baseUrl}grouped'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(
        int.parse(key),
        (value as List).map((item) => SalesDetails.fromJson(item)).toList(),
      ));
    } else {
      throw Exception('Failed to load grouped sales details');
    }
  }

  // Search by customer name and ID
  List<SalesDetails> searchByCustomerNameAndId(List<SalesDetails> sales, String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    return sales.where((item) {
      final customerName = item.sale?.customername?.toLowerCase();
      final saleId = item.sale?.id?.toString();
      return (customerName != null && customerName.contains(lowerCaseSearchTerm)) ||
          (saleId != null && saleId.contains(lowerCaseSearchTerm));
    }).toList();
  }
}
