import 'package:flutter/material.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/page/category/CreateCategory.dart';
import 'package:point_of_sale/page/category/UpdateCategory.dart';
import 'package:point_of_sale/service/CategoryService.dart';

class AllCategoryView extends StatefulWidget {
  const AllCategoryView({super.key});

  @override
  State<AllCategoryView> createState() => _AllCategoryViewState();
}

class _AllCategoryViewState extends State<AllCategoryView> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories();
  }

  Future<void> _deleteCategory(Category category) async {
    await CategoryService().deleteCategory(category.id);
    setState(() {
      futureCategories = CategoryService().fetchCategories();
    });
  }

  void _updateCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateCategoryView(category: category)),
    ).then((_) {
      setState(() {
        futureCategories = CategoryService().fetchCategories();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateCategory()),
                    ).then((_) {
                      setState(() {
                        futureCategories = CategoryService().fetchCategories();
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent, // Set button background color to green
                  ),
                  child: Text('Create Category'),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No categories available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text('ID: ${category.id ?? 'Unnamed ID'}'),
                            subtitle: Text(
                              'Category Name: ${category.categoryname ?? 'No category available'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _updateCategory(category),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Delete Category'),
                                          content: Text('Are you sure you want to delete this category?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteCategory(category);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
