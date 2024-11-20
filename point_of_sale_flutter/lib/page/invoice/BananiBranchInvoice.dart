import 'package:flutter/material.dart';
import 'package:point_of_sale/page/HomePageDhanmondiBranch.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class InvoicePageBananiBranch extends StatelessWidget {
  final Map<String, dynamic> sale;

  InvoicePageBananiBranch({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printInvoice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://i.postimg.cc/ry95B8nc/download-9.jpg"),
                    radius: 45,
                  ),
                  Text(
                    'Invoice',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Address Section
              Center(
                child: Column(
                  children: [
                    Text("Towhid Medical",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    Text("Banani Branch",
                        style: TextStyle(fontSize: 18, color: Colors.green)),
                    Text("Address: Banani, Dhaka"),
                    Text("Bangladesh"),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Customer and Sales Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Customer Name: ${sale['customername']}",
                      style: TextStyle(fontSize: 16)),
                  Text(
                    "Sales Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(sale['salesdate']))}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Products Section
              Text("Products",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.yellow[700]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Unit Price',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...sale['product'].map<TableRow>((product) {
                    final total = product['quantity'] * product['unitprice'];
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product['name']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product['quantity'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${product['unitprice'].toStringAsFixed(2)}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${total.toStringAsFixed(2)}"),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              SizedBox(height: 20),

              // Total Price
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: \$${sale['totalprice'].toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Footer Section
              Center(
                child: Column(
                  children: [
                    Text("Thank you for your business!",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Towhid Medicine Collection"),
                    Text("Phone: 01767515057"),
                    Text("Banani, Dhaka, Bangladesh"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Print Button
          // FloatingActionButton.extended(
          //   onPressed: _printInvoice,
          //   icon: Icon(Icons.print),
          //   label: Text("Print"),
          //   backgroundColor: Colors.blue,
          // ),
          // SizedBox(width: 16),
          // Home Button
          FloatingActionButton(
            onPressed: () {
              // Navigate to Home Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );// Or use Navigator.pushNamed() if you have named routes
            },
            child: Icon(Icons.home),
            backgroundColor: Colors.lightGreenAccent,
          ),
        ],
      ),
    );
  }

  // Print function
  void _printInvoice() async {
    // Load image from the network
    final response = await http.get(Uri.parse("https://i.postimg.cc/ry95B8nc/download-9.jpg"));
    final imageData = response.bodyBytes;

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final doc = pdf.Document();

        doc.addPage(
          pdf.Page(
            pageFormat: format,
            build: (context) => pdf.Column(
              crossAxisAlignment: pdf.CrossAxisAlignment.start,
              children: [
                // Header Section
                pdf.Container(
                  margin: pdf.EdgeInsets.only(bottom: 20),
                  child: pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                    children: [
                      pdf.Image(pdf.MemoryImage(imageData), width: 90, height: 90),
                      pdf.Text(
                        "Invoice",
                        style: pdf.TextStyle(fontSize: 24, fontWeight: pdf.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                pdf.SizedBox(height: 10),

                // Address Section
                pdf.Center(
                  child: pdf.Column(
                    children: [
                      pdf.Text("Towhid Medical",
                          style: pdf.TextStyle(fontSize: 24, fontWeight: pdf.FontWeight.bold, color: PdfColors.green)),
                      pdf.Text("Banani Branch",
                          style: pdf.TextStyle(fontSize: 18, color: PdfColors.green)),
                      pdf.Text("Address: Banani, Dhaka"),
                      pdf.Text("Bangladesh"),
                    ],
                  ),
                ),
                pdf.SizedBox(height: 20),

                // Customer and Sales Info
                pdf.Text("Customer Name: ${sale['customername']}"),
                pdf.Text(
                  "Sales Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(sale['salesdate']))}",
                ),
                pdf.SizedBox(height: 20),

                // Products Section
                pdf.Text("Products", style: pdf.TextStyle(fontSize: 18, fontWeight: pdf.FontWeight.bold)),

                // Products Table
                pdf.Table.fromTextArray(
                  headers: ['Name', 'Quantity', 'Unit Price', 'Total'],
                  data: List<List<String>>.generate(
                    sale['product'].length,
                        (index) {
                      final product = sale['product'][index];
                      final total = product['quantity'] * product['unitprice'];
                      return [
                        product['name'],
                        product['quantity'].toString(),
                        "\$${product['unitprice'].toStringAsFixed(2)}",
                        "\$${total.toStringAsFixed(2)}",
                      ];
                    },
                  ),
                ),
                pdf.SizedBox(height: 20),
                pdf.Row(
                  mainAxisAlignment: pdf.MainAxisAlignment.end,
                  children: [
                    pdf.Text(
                      "Total Price: \$${sale['totalprice'].toStringAsFixed(2)}",
                      style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold),
                    ),
                  ],
                ),
                pdf.SizedBox(height: 20),
                pdf.Center(
                  child: pdf.Column(
                    children: [
                      pdf.Text("Thank you for your business!", style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                      pdf.SizedBox(height: 10),
                      pdf.Text("Towhid Medicine Collection"),
                      pdf.Text("Phone: 01767515057"),
                      pdf.Text("Banani, Dhaka, Bangladesh"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        return doc.save();
      },
    );
  }
}
