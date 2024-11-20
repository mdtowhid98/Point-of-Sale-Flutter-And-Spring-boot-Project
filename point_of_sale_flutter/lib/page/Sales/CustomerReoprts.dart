import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';

class CustomerReports extends StatefulWidget {
  @override
  _CustomerReportsState createState() => _CustomerReportsState();
}

class _CustomerReportsState extends State<CustomerReports> with SingleTickerProviderStateMixin {
  final SalesService salesService = SalesService();
  List<Sale> sales = [];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    loadSales();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this, // Pass `this` for the `vsync` argument
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
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

  // Group sales by customer and calculate total sales for each customer
  Map<String, double> getCustomerTotalSales() {
    Map<String, double> customerTotalSales = {};
    for (var sale in sales) {
      if (sale.customername != null) {
        String customerName = sale.customername!.toLowerCase();
        customerTotalSales[customerName] = (customerTotalSales[customerName] ?? 0) + (sale.totalprice ?? 0);
      }
    }
    return customerTotalSales;
  }

  // Function to determine the star rating based on total price
  int getStarRating(double totalPrice) {
    if (totalPrice > 10000) {
      return 5;
    } else if (totalPrice > 8000) {
      return 4;
    } else if (totalPrice > 5000) {
      return 3;
    } else if (totalPrice > 2000) {
      return 2;
    } else {
      return 1;
    }
  }

  // Function to determine a strong color for each bar based on the total price
  Color getBarColor(double totalPrice) {
    // Generate a different color for each bar based on a range of sales
    int hue = (totalPrice % 360).toInt(); // Use total price to vary hue
    // Increase saturation and decrease lightness to make the color stronger
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.9, 0.6).toColor(); // More saturated, darker color
  }

  @override
  Widget build(BuildContext context) {
    final customerTotalSales = getCustomerTotalSales();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Sales Report'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.lightGreenAccent], // Adjust colors here as needed
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.5), // Light blue color
              Colors.purple.withOpacity(0.5), // Light purple color
            ], // You can customize these colors
            stops: [0.0, 1.0], // Control the gradient flow
          ),
        ),
        child: Column(
          children: [
            if (sales.isEmpty)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Center( // Center the bar chart
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CartesianSeries<MapEntry<String, double>, String>>[
                          ColumnSeries<MapEntry<String, double>, String>(
                            dataSource: customerTotalSales.entries.toList(),
                            xValueMapper: (MapEntry<String, double> sales, _) => sales.key,
                            yValueMapper: (MapEntry<String, double> sales, _) => sales.value,
                            pointColorMapper: (MapEntry<String, double> sales, _) => getBarColor(sales.value),
                            name: 'Total Sales',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

            Expanded(
              child: ListView.builder(
                itemCount: customerTotalSales.length,
                itemBuilder: (context, index) {
                  final customerName = customerTotalSales.keys.elementAt(index);
                  final totalPrice = customerTotalSales[customerName] ?? 0;
                  int starRating = getStarRating(totalPrice);

                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        // Track the hovered index if needed
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        // Reset hover state
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Customer: $customerName',
                          style: TextStyle(
                            color: Colors.black, // Blue color for customer name
                          ),
                        ),
                        subtitle: Text(
                          'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.blue, // Red color for total price
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(starRating, (index) {
                            return Icon(
                              Icons.star,
                              color: Colors.redAccent,
                              size: 20,
                            );
                          }),
                        ),
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
