import 'package:point_of_sale/model/ProductModel.dart';

class Sale {
  int? id;
  String? customername;
  DateTime? salesdate;
  int? totalprice;
  int? quantity;
  int? discount;
  List<Product>? product;
  dynamic salesDetails;

  Sale({
    this.id,
    this.customername,
    this.salesdate,
    this.totalprice,
    this.quantity,
    this.discount,
    this.product,
    this.salesDetails,
  });

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customername = json['customername'];
    // Parse 'salesdate' string to DateTime
    salesdate = json['salesdate'] != null ? DateTime.parse(json['salesdate']) : null;
    totalprice = json['totalprice'];
    quantity = json['quantity'];
    discount = json['discount'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
    salesDetails = json['salesDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['customername'] = customername;
    data['salesdate'] = salesdate?.toIso8601String(); // Convert DateTime to ISO string
    data['totalprice'] = totalprice;
    data['quantity'] = quantity;
    data['discount'] = discount;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['salesDetails'] = salesDetails;
    return data;
  }
}
