import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/ProductService.dart';

class AllProductStockGulshan extends StatefulWidget with WidgetsBindingObserver {
  const AllProductStockGulshan({super.key});

  @override
  State<AllProductStockGulshan> createState() => _AllProductStockGulshanState();
}

class _AllProductStockGulshanState extends State<AllProductStockGulshan> {
  late Future<List<Product>> futureProducts;
  Map<int, bool> hoverStates = {};
  int? hoveredIndex;

  final List<Color> cardColors = [
    Colors.red,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.lightGreenAccent,
    Colors.teal,
    Colors.amberAccent,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().getAllGulshanBranchProducts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      futureProducts = ProductService().getAllGulshanBranchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gulshan Branch Stock'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.lightGreenAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // Make the scaffold's background transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightGreenAccent, Colors.yellowAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products available'));
            } else {
              // Prepare data for the pie chart
              Map<String, double> stockData = {};
              snapshot.data!.forEach((product) {
                final productName = product.name ?? 'Unknown Product';
                stockData[productName] = (stockData[productName] ?? 0) + (product.stock ?? 0);
              });

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: stockData.entries.map((entry) {
                            int colorIndex = stockData.keys.toList().indexOf(entry.key) % cardColors.length;
                            bool isHovered = hoveredIndex == colorIndex;

                            return PieChartSectionData(
                              color: cardColors[colorIndex],
                              value: entry.value,
                              title: '${entry.value}', // Display the stock value as the label
                              titleStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              radius: isHovered ? 70 : 60,
                              borderSide: BorderSide(
                                color: isHovered ? Colors.lightGreenAccent : Colors.transparent,
                                width: 4,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {});
                            },
                          ),
                        ),
                        swapAnimationDuration: Duration(milliseconds: 800),
                        swapAnimationCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        final backgroundColor = cardColors[index % cardColors.length];

                        return MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              hoverStates[index] = true;
                              hoveredIndex = index % cardColors.length;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              hoverStates[index] = false;
                              hoveredIndex = null;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: hoverStates[index] ?? false ? Colors.lime : Colors.blue,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Product Name: ${product.name ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Stock: ${product.stock ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue, // Red color for stock
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Branch: ${product.branch?.branchName ?? 'Unknown Branch'}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue, // Red color for branch
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
