import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/product/CreateProduct.dart';
import 'package:point_of_sale/service/ProductService.dart';

class AllProductView extends StatefulWidget with WidgetsBindingObserver {
  const AllProductView({super.key});

  @override
  State<AllProductView> createState() => _AllProductViewState();
}

class _AllProductViewState extends State<AllProductView> {
  late Future<List<Product>> futureProducts;
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
  }

  Future<void> _deleteProduct(Product product) async {
    await ProductService().deleteProduct(product.id);
    setState(() {
      futureProducts = ProductService().fetchProducts();
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
          title: Text('Products'),
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
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: product.photo != null
                                    ? Image.network(
                                  "http://localhost:8087/images/product/${product.photo}",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  height: 120,
                                  width: 120,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.production_quantity_limits,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
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
                                      'Unit Price: \$${product.unitprice ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Stock: ${product.stock ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Manufacture Date: ${product.manufactureDate ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Expiry Date: ${product.expiryDate ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Supplier: ${product.supplier?.name ?? 'Unknown Supplier'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Category: ${product.category?.categoryname ?? 'Unknown Category'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Branch: ${product.branch?.branchName ?? 'Unknown Branch'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Delete Product'),
                                        content: Text('Are you sure you want to delete this product?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteProduct(product);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductPage()),
            );
          },
          backgroundColor: Colors.lightGreenAccent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
