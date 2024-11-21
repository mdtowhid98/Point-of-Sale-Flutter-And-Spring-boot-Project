class Supplier {
  int? id;
  String? name;
  String? email;
  int? cell; // Changed from int to String
  String? address;

  Supplier({this.id, this.name, this.email, this.cell, this.address});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    cell = json['cell'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['cell'] = this.cell;
    data['address'] = this.address;
    return data;
  }
}