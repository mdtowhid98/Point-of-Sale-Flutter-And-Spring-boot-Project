import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/invoice/BananiBranchInvoice.dart';
import 'package:point_of_sale/page/invoice/DhanmondiBranchInvoice.dart';
import 'package:point_of_sale/service/ProductService.dart';
import 'package:point_of_sale/service/SalesService.dart';

class CreateSalesBananiBranch extends StatefulWidget {
  @override
  _CreateSalesBananiBranchState createState() => _CreateSalesBananiBranchState();
}

class _CreateSalesBananiBranchState extends State<CreateSalesBananiBranch> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();

  DateTime? salesDate = DateTime.now();
  List<Product> products = [];
  List<Product?> selectedProducts = [null];
  List<TextEditingController> quantityControllers = [TextEditingController()];
  List<TextEditingController> unitPriceControllers = [TextEditingController()];

  final _formKey = GlobalKey<FormState>();
  final CreateSalesService salesService = CreateSalesService();
  final ProductService productService = ProductService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllBananiBranchProducts();
    quantityControllers.forEach((controller) {
      controller.addListener(_updateTotalPrice);
    });
  }

  @override
  void dispose() {
    quantityControllers.forEach((controller) {
      controller.removeListener(_updateTotalPrice);
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _getAllBananiBranchProducts() async {
    try {
      products = await productService.getAllBananiBranchProducts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching Banani branch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < selectedProducts.length; i++) {
      final selectedProduct = selectedProducts[i];
      final quantityText = quantityControllers[i].text;
      final unitPrice = (selectedProduct?.unitprice ?? 0).toDouble();
      final quantity = int.tryParse(quantityText) ?? 0;
      totalPrice += unitPrice * quantity;
    }
    totalPriceController.text = totalPrice.toStringAsFixed(2);
  }

  void _onProductSelected(Product? product, int index) {
    setState(() {
      selectedProducts[index] = product;
      unitPriceControllers[index].text = product?.unitprice?.toString() ?? '';
      _updateTotalPrice();
    });
  }

  void _addProductField() {
    setState(() {
      selectedProducts.add(null);
      quantityControllers.add(TextEditingController()..addListener(_updateTotalPrice));
      unitPriceControllers.add(TextEditingController());
    });
  }

  void _removeProductField(int index) {
    setState(() {
      selectedProducts.removeAt(index);
      quantityControllers[index].removeListener(_updateTotalPrice);
      quantityControllers.removeAt(index).dispose();
      unitPriceControllers.removeAt(index).dispose();
    });
    _updateTotalPrice();
  }

  bool _validateQuantities() {
    for (int i = 0; i < selectedProducts.length; i++) {
      final selectedProduct = selectedProducts[i];
      final quantityText = quantityControllers[i].text;
      final quantity = int.tryParse(quantityText) ?? 0;

      if (selectedProduct != null) {
        // Check if requested quantity exceeds stock
        if ((selectedProduct.stock ?? 0) < quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Requested quantity for ${selectedProduct.name} exceeds available stock (${selectedProduct.stock ?? 0}).',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }

        // Check if the product is expired
        if (selectedProduct != null &&
            selectedProduct.expiryDate != null &&
            DateTime.parse(selectedProduct.expiryDate!).isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Product ${selectedProduct.name} has expired. Cannot create sales with expired products.',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }

      }
    }
    return true;
  }

  void _createSales() async {
    if (_formKey.currentState!.validate() && salesDate != null && _validateQuantities()) {
      String customerName = customerNameController.text;
      double totalPrice = double.parse(totalPriceController.text);

      List<Map> productsToSubmit = selectedProducts.asMap().entries.map((entry) {
        int index = entry.key;
        Product? product = entry.value;

        if (product != null) {
          int quantity = int.tryParse(quantityControllers[index].text) ?? 0;
          product.quantity = quantity;
          return {
            'id': product.id,
            'name': product.name,
            'quantity': product.quantity,
            'unitprice': product.unitprice,
            'salesDetails': {
              'quantity': product.quantity,
              'product': product.toJson(),
              'totalPrice': (product.unitprice! * quantity),
              'discount': 0.0,
            },
          };
        }
        return {};
      }).toList();

      final saleData = {
        'customername': customerName,
        'salesdate': salesDate!.toIso8601String(),
        'totalprice': totalPrice,
        'product': productsToSubmit,
      };

      try {
        final response = await salesService.createSalesBananiBranch(
          customerName,
          salesDate!,
          totalPrice.toInt(),
          productsToSubmit.length,
          selectedProducts.whereType<Product>().toList(),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoicePageBananiBranch(sale: saleData),
            ),
          );
          _resetForm();
        } else {
          _showErrorDialog('Failed to create sales. Status: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  void _resetForm() {
    customerNameController.clear();
    totalPriceController.clear();
    for (final controller in quantityControllers) {
      controller.clear();
    }
    setState(() {
      salesDate = DateTime.now();
      selectedProducts = [null];
      quantityControllers = [TextEditingController()..addListener(_updateTotalPrice)];
      unitPriceControllers = [TextEditingController()];
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Sales')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  initialValue: salesDate,
                  decoration: const InputDecoration(
                    labelText: 'Sales Date',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      salesDate = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addProductField,
                      icon: Icon(Icons.add),
                      label: Text('Add Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Set the background color to green
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedProducts.clear();
                          quantityControllers.forEach((controller) => controller.dispose());
                          unitPriceControllers.forEach((controller) => controller.dispose());
                          quantityControllers.clear();
                          unitPriceControllers.clear();
                          selectedProducts.add(null);
                          quantityControllers.add(TextEditingController()..addListener(_updateTotalPrice));
                          unitPriceControllers.add(TextEditingController());
                        });
                        _updateTotalPrice();
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text('Remove All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: List.generate(selectedProducts.length, (index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            // Product Dropdown
                            Expanded(
                              child: DropdownButtonFormField<Product>(
                                value: selectedProducts[index],
                                onChanged: (product) => _onProductSelected(product, index),
                                decoration: InputDecoration(
                                  labelText: 'Select Product',
                                  border: OutlineInputBorder(),
                                ),
                                items: products.map((product) {
                                  return DropdownMenuItem<Product>(
                                    value: product,
                                    child: Text('${product.name ?? ''} (Stock: ${product.stock ?? 0})'),
                                  );
                                }).toList(),
                                isExpanded: true,
                                hint: Text('Select a product'),
                                selectedItemBuilder: (context) {
                                  return products.map((product) {
                                    return Text('${product.name ?? ''} (Stock: ${product.stock ?? 0})');
                                  }).toList();
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _removeProductField(index),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Row to display Quantity and Unit Price side by side
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: quantityControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a quantity';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10), // Space between the fields
                            Expanded(
                              child: TextFormField(
                                controller: unitPriceControllers[index],
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Unit Price',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }),
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: totalPriceController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createSales,
                  child: Text('Create Sales'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent, // Set the background color to green
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
