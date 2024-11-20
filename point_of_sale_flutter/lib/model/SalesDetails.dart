import 'ProductModel.dart';
import 'Sale.dart';

class SalesDetails {
  int? id;
  Sale? sale;
  Product? product;
  int? quantity;
  int? unitPrice;
  int? totalPrice;
  int? discount;

  SalesDetails({
    this.id,
    this.sale,
    this.product,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.discount,
  });

  SalesDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sale = json['sale'] != null ? Sale.fromJson(json['sale']) : null;
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale': sale?.toJson(),
      'product': product?.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'discount': discount,
    };
  }
}
