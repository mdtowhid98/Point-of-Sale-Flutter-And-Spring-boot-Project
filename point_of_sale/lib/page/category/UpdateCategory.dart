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
      appBar: AppBar(title: Text('Update Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: categoryName,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
                onChanged: (value) {
                  categoryName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCategory,
                child: Text('Update Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}