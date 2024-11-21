import 'package:flutter/material.dart';
import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/service/BranchService.dart';

class UpdateBranchView extends StatefulWidget {
  final Branch branch;

  const UpdateBranchView({Key? key, required this.branch}) : super(key: key);

  @override
  _UpdateBranchViewState createState() => _UpdateBranchViewState();
}

class _UpdateBranchViewState extends State<UpdateBranchView> {
  final _formKey = GlobalKey<FormState>();
  late String branchName;
  late String location;

  @override
  void initState() {
    super.initState();
    branchName = widget.branch.branchName ?? '';
    location = widget.branch.location ?? '';
  }

  Future<void> _updateBranch() async {
    if (_formKey.currentState!.validate()) {
      final updatedBranch = Branch(id: widget.branch.id, branchName: branchName, location: location);
      try {
        await BranchService().updateBranches(widget.branch.id!, updatedBranch);
        Navigator.pop(context); // Go back after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Branch: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Branch'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlueAccent,
                Colors.lime,
                Colors.deepPurpleAccent,
                Colors.lightGreenAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: branchName,
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    prefixIcon: Icon(Icons.home_filled),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10, // Adjust height
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    branchName = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: location,
                  decoration: InputDecoration(
                    labelText: 'Branch Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10, // Adjust height
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch location';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    location = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateBranch,
                  child: Text(
                    "Update Branch",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
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
