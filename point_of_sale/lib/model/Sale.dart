import 'package:point_of_sale/model/ProductModel.dart';

class Sale {
  int? id;
  String? customername;
  String? salesdate;
  int? totalprice;
  int? quantity;
  int? discount;
  List<Product>? product;
  Null? salesDetails;

  Sale(
      {this.id,
        this.customername,
        this.salesdate,
        this.totalprice,
        this.quantity,
        this.discount,
        this.product,
        this.salesDetails});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customername = json['customername'];
    salesdate = json['salesdate'];
    totalprice = json['totalprice'];
    quantity = json['quantity'];
    discount = json['discount'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    salesDetails = json['salesDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customername'] = this.customername;
    data['salesdate'] = this.salesdate;
    data['totalprice'] = this.totalprice;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['salesDetails'] = this.salesDetails;
    return data;
  }
}