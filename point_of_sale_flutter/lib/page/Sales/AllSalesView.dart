import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';

class ViewSales extends StatefulWidget {
  @override
  _ViewSalesState createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  final SalesService salesService = SalesService();
  List<Sale> sales = [];

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      final salesData = await salesService.getAllSales();
      setState(() {
        sales = salesData;
      });
    } catch (error) {
      print('Error loading sales: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Sales'),
      ),
      body: sales.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Customer: ${sale.customername}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${sale.salesdate != null ? DateFormat('yyyy-MM-dd').format(sale.salesdate!) : 'N/A'}'),

                  Text('Total Price: \$${sale.totalprice}'),
                  Text('Products:'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sale.product?.map((product) {
                      return Text(
                        '${product.name ?? 'Unnamed Product'} - Unit Price: \$${product.unitprice ?? 0}',
                        style: TextStyle(fontSize: 14),
                      );
                    }).toList() ?? [],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Implement edit functionality here
                    },
                  ),
                  // Uncomment the delete button when implementing delete functionality
                  // IconButton(
                  //   icon: Icon(Icons.delete, color: Colors.red),
                  //   onPressed: () => deleteSale(sale.id),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
