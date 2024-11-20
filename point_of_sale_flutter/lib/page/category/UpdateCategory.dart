import 'package:flutter/material.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/service/CategoryService.dart';

class UpdateCategoryView extends StatefulWidget {
  final Category category;

  const UpdateCategoryView({Key? key, required this.category}) : super(key: key);

  @override
  _UpdateCategoryViewState createState() => _UpdateCategoryViewState();
}

class _UpdateCategoryViewState extends State<UpdateCategoryView> {
  final _formKey = GlobalKey<FormState>();
  late String categoryName;

  @override
  void initState() {
    super.initState();
    categoryName = widget.category.categoryname ?? '';
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      final updatedCategory = Category(id: widget.category.id, categoryname: categoryName);
      try {
        await CategoryService().updateCategories(widget.category.id!, updatedCategory);
        Navigator.pop(context); // Go back after updating
      } catch (e) {
        // Handle error (e.g., show a message)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update category: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Category'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    initialValue: categoryName,
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      prefixIcon: Icon(Icons.category, color: Colors.blueAccent, size: 20),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      isDense: true,
                    ),
                    style: TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      categoryName = value;
                    },
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateCategory,
                    child: Text(
                      "Update Category",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
