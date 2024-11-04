import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/model/CategoryModel.dart';

import 'dart:convert';

import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/SaleProduct.dart';



class CreateSalesPage extends StatefulWidget {
  @override
  _CreateSalesPageState createState() => _CreateSalesPageState();
}

class _CreateSalesPageState extends State<CreateSalesPage> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  DateTime salesDate = DateTime.now();
  List<Product> products = [];
  List<Category> categories = [];

  int totalPrice = 0;
  bool isLoadingCategories = true;
  bool isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadProducts();
  }

  Future<void> loadCategories() async {
    try {
      final response =
      await http.get(Uri.parse('http://localhost:8087/api/category/'));
      if (response.statusCode == 200) {
        setState(() {
          categories = (json.decode(response.body) as List)
              .map((data) => Category.fromJson(data))
              .toList();
          isLoadingCategories = false;
        });
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (error) {
      setState(() {
        isLoadingCategories = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading categories: $error')));
      });
    }
  }

  Future<void> loadProducts() async {
    try {
      final response =
      await http.get(Uri.parse('http://localhost:8087/api/product/'));
      if (response.statusCode == 200) {
        setState(() {
          products = (json.decode(response.body) as List)
              .map((data) => Product.fromJson(data))
              .toList();
          isLoadingProducts = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print(error);
      setState(() => isLoadingProducts = false);
    }
  }

  void calculateTotalPrice() {
    totalPrice = products.fold(
        0,
            (sum, item) => sum + ((item.unitprice ?? 0) * (item.quantity ?? 0))
    );
    setState(() {});
  }



  void addProduct() {
    setState(() {
      products.add(Product()); // Add a new empty Product instance
    });
  }


  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
      calculateTotalPrice();
    });
  }

  Future<void> createSales() async {
    if (_formKey.currentState!.validate()) {
      final saleData = {
        'customername': customerName,
        'salesdate': salesDate.toIso8601String(),
        'totalprice': totalPrice,
        'product': products.map((product) => product.toJson()).toList(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8087/api/sales/dhanmondi'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode(saleData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context);
        } else {
          print('Failed to create sales: ${response.body}');
        }
      } catch (error) {
        print('Error creating sale: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) =>
                value!.isEmpty ? 'Customer name is required' : null,
                onChanged: (value) => customerName = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sales Date'),
                readOnly: true,
                controller: TextEditingController(
                    text: salesDate.toLocal().toString().split(' ')[0]),
                validator: (value) =>
                value!.isEmpty ? 'Sales date is required' : null,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductForm(
                      categories: categories,
                      products: products,

                      onRemove: () => removeProduct(index),
                      onProductChange: (product) {
                        setState(() {
                          products[index].name= product.name;
                          products[index].unitprice =
                              product.unitprice ?? 0;
                          products[index].stock = product.stock ?? 0;
                        });
                        calculateTotalPrice();
                      },
                      onQuantityChange: (quantity) {
                        setState(() {
                          products[index].quantity = quantity;
                        });
                        calculateTotalPrice();
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(onPressed: addProduct, child: Text('Add Product')),
              SizedBox(height: 10),
              Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: createSales,
                child: Text('Create Sales'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  final List<Category> categories;
  final List<Product> products;

  final VoidCallback onRemove;
  final ValueChanged<Product> onProductChange;
  final ValueChanged<int> onQuantityChange;

  ProductForm({
    required this.categories,
    required this.products,

    required this.onRemove,
    required this.onProductChange,
    required this.onQuantityChange,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  Category? selectedCategory;
  Product? selectedProduct;

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = selectedCategory != null
        ? widget.products
        .where((product) => product.category?.id == selectedCategory!.id)
        .toList()
        : [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<Category>(
              decoration: InputDecoration(labelText: 'Category'),
              items: widget.categories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.categoryname ?? 'Unknown Category'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  selectedProduct = null; // Reset product when category changes
                });
              },
              validator: (value) =>
              value == null ? 'Please select a category' : null,
            ),
            DropdownButtonFormField<Product>(
              decoration: InputDecoration(labelText: 'Product'),
              items: widget.products.map((product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name ?? 'Unknown Product'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  widget.onProductChange(value!);
                });
              },
              validator: (value) =>
              value == null ? 'Please select a Product' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int quantity = int.parse(value);
                  widget.onQuantityChange(quantity);
                }
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null ||
                    int.parse(value) <= 0) {
                  return 'Please enter a valid quantity';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.number,
              readOnly: true,
              controller: TextEditingController(
                text: selectedProduct != null
                    ? '${selectedProduct!.unitprice}'
                    : '0',
              ),
            ),
        // TextFormField(
        //   decoration: InputDecoration(labelText: 'Unit Price'),
        //   keyboardType: TextInputType.number,
        //   readOnly: true,
        //   controller: TextEditingController(
        //     text: selectedProduct != null
        //         ? '${selectedProduct!.unitprice ?? 0}' // Fallback to 0 if unitprice is null
        //         : '0',
        //   ),
        // ),



            ElevatedButton(onPressed: widget.onRemove, child: Text('Remove')),
          ],
        ),
      ),
    );
  }
}


