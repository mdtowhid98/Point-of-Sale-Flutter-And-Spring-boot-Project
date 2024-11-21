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
  Map<int, double> _elevations = {}; // Store individual elevations
  Map<int, double> _offsets = {}; // Store individual vertical offsets
  Map<int, Color> _borderColors = {}; // Store individual border colors

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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
              ],
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
              Colors.red.withOpacity(0.3),
              Colors.orange.withOpacity(0.3),
              Colors.yellow.withOpacity(0.3),
              Colors.green.withOpacity(0.3),
              Colors.blue.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
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

                          // Initialize elevation, offset, and border color for each card
                          _elevations[index] = _elevations[index] ?? 4.0;
                          _offsets[index] = _offsets[index] ?? 0.0;
                          _borderColors[index] = _borderColors[index] ?? Colors.blue;

                          return MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _elevations[index] = 10.0;
                                _offsets[index] = -5.0;
                                _borderColors[index] = Colors.lightGreenAccent; // Change border color on hover
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _elevations[index] = 4.0;
                                _offsets[index] = 0.0;
                                _borderColors[index] = Colors.blue; // Reset border color
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              transform: Matrix4.translationValues(0.0, _offsets[index]!, 0.0),
                              child: Card(
                                elevation: _elevations[index],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    width: 5.0,
                                    color: _borderColors[index]!, // Apply individual border color
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ListTile(
                                    title: Text('ID: ${category.id ?? 'Unnamed ID'}'),
                                    subtitle: Text(
                                      'Category Name: ${category.categoryname ?? 'No category available'}',
                                      style: TextStyle(color: Colors.black),
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
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Create Category',
        child: FloatingActionButton(
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
          backgroundColor: Colors.lightGreenAccent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
