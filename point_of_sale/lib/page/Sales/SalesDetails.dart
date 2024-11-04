import 'package:flutter/material.dart';
import 'package:point_of_sale/model/SalesDetails.dart';
import 'package:point_of_sale/page/Sales/CreateSales.dart';
import 'package:point_of_sale/service/SalesDetailsService.dart';


class ViewSalesDetailsScreen extends StatefulWidget {
  @override
  _ViewSalesDetailsScreenState createState() => _ViewSalesDetailsScreenState();
}

class _ViewSalesDetailsScreenState extends State<ViewSalesDetailsScreen> {
  List<SalesDetails> salesDetails = [];
  List<SalesDetails> filteredSalesDetails = [];
  Map<int, List<SalesDetails>> groupedSalesDetails = {};
  final salesDetailsService = SalesDetailsService();

  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchSalesDetails();
  }

  Future<void> _fetchSalesDetails() async {
    try {
      final fetchedSalesDetails = await salesDetailsService.getAllSalesDetails();
      setState(() {
        salesDetails = fetchedSalesDetails;
        filteredSalesDetails = List.from(salesDetails);
        _groupSalesDetails();
      });
    } catch (e) {
      print("Error fetching sales details: $e");
    }
  }

  void _groupSalesDetails() {
    groupedSalesDetails = {};
    for (var sale in salesDetails) {
      groupedSalesDetails.putIfAbsent(sale.id!, () => []).add(sale);
    }
  }

  void _searchCustomerNameOrId(String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    setState(() {
      filteredSalesDetails = salesDetails.where((sale) {
        final customerName = sale.sale?.customername?.toLowerCase() ?? '';
        return customerName.contains(lowerCaseSearchTerm) || sale.id.toString().contains(lowerCaseSearchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the CreateSales screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateSalesPage()),
                );
              },
              child: Text('Create Sales'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Customer Name or Sales ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                searchTerm = value;
                _searchCustomerNameOrId(searchTerm);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSalesDetails.length,
                itemBuilder: (context, index) {
                  final sale = filteredSalesDetails[index];
                  return Card(
                    child: ListTile(
                      title: Text('Customer: ${sale.sale?.customername ?? 'N/A'}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sales ID: ${sale.id}'),
                          Text('Quantity: ${sale.quantity}'),
                          Text('Unit Price: \$${sale.unitPrice}'),
                          Text('Total Price: \$${sale.totalPrice}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
