import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';

class SalesChart extends StatefulWidget {
  @override
  _SalesChartState createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  final SalesService salesService = SalesService();
  Map<String, double> groupedSales = {};
  DateTimeRange? selectedDateRange;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      final salesData = await salesService.getAllSales();
      if (selectedDateRange != null) {
        salesData.removeWhere((sale) => sale.salesdate == null ||
            sale.salesdate!.isBefore(selectedDateRange!.start) ||
            sale.salesdate!.isAfter(selectedDateRange!.end));
      }
      updateGroupedSales(salesData);
    } catch (error) {
      print('Error loading sales: $error');
    }
  }

  void updateGroupedSales(List<Sale> salesData) {
    final Map<String, double> salesByDate = {};
    for (var sale in salesData) {
      if (sale.salesdate != null) {
        String dateKey = DateFormat('yyyy-MM-dd').format(sale.salesdate!);
        salesByDate[dateKey] =
            (salesByDate[dateKey] ?? 0) + (sale.totalprice ?? 0).toDouble();
      }
    }
    setState(() {
      groupedSales = salesByDate;
    });
  }

  void scrollChart(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Chart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.blue, Colors.amberAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Date Range: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.red), // Red color for calendar button
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDateRange) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                        loadSales();
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left, color: Colors.red), // Red color for left arrow
                    onPressed: () {
                      scrollChart(-100); // Scroll left by 100 pixels
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right, color: Colors.red), // Red color for right arrow
                    onPressed: () {
                      scrollChart(100); // Scroll right by 100 pixels
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            groupedSales.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              flex: 2,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: groupedSales.length * 80.0,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: 0,
                      title: AxisTitle(text: 'Date'),
                      labelStyle: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Total Sales'),
                      interval: calculateInterval(),
                      numberFormat: NumberFormat.simpleCurrency(),
                      labelStyle: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<MapEntry<String, double>, String>(
                        dataSource: groupedSales.entries.toList(),
                        xValueMapper: (MapEntry<String, double> sales, _) => sales.key,
                        yValueMapper: (MapEntry<String, double> sales, _) => sales.value,
                        pointColorMapper: (MapEntry<String, double> sales, _) {
                          return getColorForSales(sales.value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: groupedSales.length,
                itemBuilder: (context, index) {
                  String date = groupedSales.keys.elementAt(index);
                  double totalPrice = groupedSales[date]!;
                  return Card(
                    margin: EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        'Date: $date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
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

  double calculateInterval() {
    if (groupedSales.isEmpty) return 10;
    double maxValue = groupedSales.values.reduce((a, b) => a > b ? a : b);
    return (maxValue / 5).ceilToDouble();
  }

  Color getColorForSales(double salesValue) {
    if (salesValue > 1000) {
      return Colors.yellowAccent;
    } else if (salesValue > 500) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
