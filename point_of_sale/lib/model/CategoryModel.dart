// category.dart
class Category {
  int? id;
  String? categoryname;

  Category({this.id, this.categoryname});

  // JSON deserialization
  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryname = json['categoryname'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryname'] = this.categoryname;
    return data;
  }
}