
class Branch {
  int? id;
  String? branchName;
  String? location;

  Branch({this.id, this.branchName, this.location});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branchName'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branchName'] = this.branchName;
    data['location'] = this.location;
    return data;
  }
}