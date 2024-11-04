import 'package:flutter/material.dart';
import 'package:point_of_sale/page/branch/AllBranchView.dart';
import 'package:point_of_sale/service/BranchService.dart';


class CreateBranch extends StatefulWidget {
  const CreateBranch({super.key});

  @override
  State<CreateBranch> createState() => _CreateBranchState();
}

class _CreateBranchState extends State<CreateBranch> {
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController branchLocationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final CreateBranchService branchService = CreateBranchService();

  void _createBranch() async {
    if (_formKey.currentState!.validate()) {
      String bName = branchNameController.text;
      String blocation = branchLocationController.text;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final response = await branchService.createBranch(bName, blocation);

        Navigator.pop(context); // Close loading indicator

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Branch created successfully!');
          branchNameController.clear();
          branchLocationController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AllBranchesView()),
          );
        } else if (response.statusCode == 409) {
          print('Branch already exists!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Branch already exists!')),
          );
        } else {
          print('Branch creation failed with status: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Branch creation failed!')),
          );
        }
      } catch (e) {
        Navigator.pop(context); // Close loading indicator
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Branch')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: branchNameController,
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_filled),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: branchLocationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch Location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createBranch,
                  child: Text(
                    "Create Branch",
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