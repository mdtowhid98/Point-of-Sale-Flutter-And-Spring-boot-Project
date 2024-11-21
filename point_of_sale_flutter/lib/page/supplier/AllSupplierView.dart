import 'package:flutter/material.dart';
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/page/supplier/CreateSupplier.dart';
import 'package:point_of_sale/page/supplier/UpdateSupplier.dart';
import 'package:point_of_sale/service/SupplierService.dart';

class SupplierListView extends StatefulWidget {
  @override
  _SupplierListViewState createState() => _SupplierListViewState();
}

class _SupplierListViewState extends State<SupplierListView> {
  late Future<List<Supplier>> futureSuppliers;
  Map<int, double> _elevations = {}; // Store individual elevations
  Map<int, double> _offsets = {}; // Store individual vertical offsets
  Map<int, Color> _borderColors = {}; // Store individual border colors

  @override
  void initState() {
    super.initState();
    futureSuppliers = SupplierService().fetchSuppliers();
  }

  Future<void> _deleteSupplier(Supplier supplier) async {
    await SupplierService().deleteSupplier(supplier.id);
    setState(() {
      futureSuppliers = SupplierService().fetchSuppliers();
    });
  }

  void _updateSupplier(Supplier supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateSupplierView(supplier: supplier)),
    ).then((_) {
      setState(() {
        futureSuppliers = SupplierService().fetchSuppliers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.yellowAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Supplier>>(
                  future: futureSuppliers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No suppliers available'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final supplier = snapshot.data![index];
                          _elevations[index] = _elevations[index] ?? 4.0;
                          _offsets[index] = _offsets[index] ?? 0.0;
                          _borderColors[index] = _borderColors[index] ?? Colors.blue;

                          return MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _elevations[index] = 10.0;
                                _offsets[index] = -5.0;
                                _borderColors[index] = Colors.lightGreenAccent;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _elevations[index] = 4.0;
                                _offsets[index] = 0.0;
                                _borderColors[index] = Colors.blue;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              transform: Matrix4.translationValues(0.0, _offsets[index]!, 0.0),
                              child: Card(
                                elevation: _elevations[index],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    width: 5.0,
                                    color: _borderColors[index]!,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ID: ${supplier.id ?? 'Unnamed ID'}',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(
                                        'Supplier Name: ${supplier.name ?? 'No supplier available'}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        'Email: ${supplier.email ?? 'No email available'}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        'Cell: ${supplier.cell ?? 'No cell available'}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Address: ${supplier.address ?? 'No address available'}',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () => _updateSupplier(supplier),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Delete Supplier'),
                                                        content: Text(
                                                            'Are you sure you want to delete this supplier?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _deleteSupplier(supplier);
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
                                        ],
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSupplier()),
          ).then((_) {
            setState(() {
              futureSuppliers = SupplierService().fetchSuppliers();
            });
          });
        },
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
