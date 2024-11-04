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
        );// Clear input after successful creation
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
      appBar: AppBar(title: Text('Create Category')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createCategory,
                  child: Text(
                    "Create Category",
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