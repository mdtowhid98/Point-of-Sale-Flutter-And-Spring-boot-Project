import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/product/UpdateProduct.dart';
import 'package:point_of_sale/service/ProductService.dart';

class Notifications extends StatefulWidget with WidgetsBindingObserver {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}




class _NotificationsState extends State<Notifications> {
  late Future<List<Product>> futureProducts;
  int expiringProductsCount = 0; // Tracks the number of expiring products
  Map<int, bool> hoverStates = {};

  final List<Color> cardColors = [
    Colors.amber.shade100,
    Colors.lightBlue.shade100,
    Colors.lightGreen.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
    Colors.yellow.shade100,
    Colors.orange.shade100,
  ];

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts();
    calculateExpiringProducts(); // Calculate the count on init
  }

  void _updateProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProductPage(product: product)),
    ).then((_) {
      setState(() {
        futureProducts = ProductService().fetchProducts();
      });
    });
  }

  // Calculate the number of products expiring within the next 3 days
  void calculateExpiringProducts() async {
    final now = DateTime.now();
    final products = await ProductService().fetchProducts();
    setState(() {
      expiringProductsCount = products.where((product) {
        if (product.expiryDate == null) return false;
        final expiryDate = DateTime.parse(product.expiryDate!);
        final difference = expiryDate.difference(now).inDays;
        return difference >= 0 && difference < 3;
      }).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.green.shade200,
            Colors.yellow.shade200,
            Colors.orange.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Expeiry date last three days'),
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
        body: FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products available'));
            } else {
              final now = DateTime.now();
              final filteredProducts = snapshot.data!.where((product) {
                if (product.expiryDate == null) return false;
                final expiryDate = DateTime.parse(product.expiryDate!);
                final difference = expiryDate.difference(now).inDays;
                return difference >= 0 && difference < 3;
              }).toList();

              if (filteredProducts.isEmpty) {
                return Center(child: Text('No products expiring in the next 3 days'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final backgroundColor = cardColors[index % cardColors.length];

                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoverStates[index] = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoverStates[index] = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: hoverStates[index] ?? false ? Colors.lime : Colors.transparent,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out content
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Manufacture Date: ${product.manufactureDate ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14, color: Colors.blue),
                                    ),
                                    Text(
                                      'Expiry Date: ${product.expiryDate ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _updateProduct(product),
                              ),
                            ],
                          ),
                            
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
