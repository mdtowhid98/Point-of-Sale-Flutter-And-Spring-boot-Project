import 'package:flutter/material.dart';
import 'package:point_of_sale/model/SalesDetails.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlueAccent,
            Colors.lightGreenAccent,
            Colors.orangeAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Sales Details'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.lightGreenAccent, Colors.yellowAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                    return _buildHoverableCard(sale);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoverableCard(SalesDetails sale) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isHovered ? Colors.red : Colors.grey, // Change border color on hover
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Customer: ${sale.sale?.customername ?? 'N/A'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Sales ID and Quantity
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sales ID: ${sale.id}'),
                      Text('Quantity: ${sale.quantity}'),
                    ],
                  ),
                  // Right side: Unit Price and Total Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Unit Price: \$${sale.unitPrice}'),
                      Text(
                        'Total Price: \$${sale.totalPrice}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
