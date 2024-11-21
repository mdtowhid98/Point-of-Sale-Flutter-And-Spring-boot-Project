import 'package:flutter/material.dart';
import 'package:point_of_sale/page/category/AllCategoryView.dart';
import 'package:point_of_sale/service/CategoryService.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final TextEditingController categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CreateCategoryService categoryService = CreateCategoryService();

  void _createCategory() async {
    if (_formKey.currentState!.validate()) {
      String cName = categoryNameController.text;

      final response = await categoryService.createCategory(cName);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Category Created successfully!');
        categoryNameController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllCategoryView()),
        ); // Clear input after successful creation
      } else if (response.statusCode == 409) {
        print('Category already exists!');
      } else {
        print('Category creation failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent, Colors.yellowAccent], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent,
              Colors.lightGreenAccent,
              Colors.orangeAccent,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Ensures center alignment of children
                  children: [
                    // Compact TextFormField with stylish decoration
                    TextFormField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 14), // Smaller label text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        prefixIcon: Icon(Icons.category, color: Colors.blueAccent, size: 20), // Smaller icon
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjusted padding
                        isDense: true, // Compact field
                      ),
                      style: TextStyle(fontSize: 14), // Smaller input text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    SizedBox(height: 20),
                    // Stylish ElevatedButton
                    ElevatedButton(
                      onPressed: _createCategory,
                      child: Text(
                        "Create Category",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        elevation: 5, // Button shadow
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
