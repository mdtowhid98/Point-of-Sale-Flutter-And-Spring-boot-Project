


import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/model/SupplierModel.dart';

class Product {
  int? id;
  String? name;
  String? photo;
  int? stock;
  int? quantity;
  int? unitprice;
  String? manufactureDate;
  String? expiryDate;
  Category? category;
  Supplier? supplier;
  Branch? branch;

  Product(
      {this.id,
        this.name,
        this.photo,
        this.stock,
        this.quantity,
        this.unitprice,
        this.manufactureDate,
        this.expiryDate,
        this.category,
        this.supplier,
        this.branch});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    stock = json['stock'];
    quantity = json['quantity'];
    unitprice = json['unitprice'];
    manufactureDate = json['manufactureDate'];
    expiryDate = json['expiryDate'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    branch =
    json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['stock'] = this.stock;
    data['quantity'] = this.quantity;
    data['unitprice'] = this.unitprice;
    data['manufactureDate'] = this.manufactureDate;
    data['expiryDate'] = this.expiryDate;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    return data;
  }
}