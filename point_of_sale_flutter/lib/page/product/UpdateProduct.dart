import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

// Import your custom models with aliases to avoid naming conflicts
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/CategoryModel.dart' as custom; // Alias for CategoryModel
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/model/BranchModel.dart';

class UpdateProductPage extends StatefulWidget {
  final Product? product; // Optional product to edit

  const UpdateProductPage({super.key, this.product});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  Uint8List? webImage;

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _manufactureDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  custom.Category? selectedCategory;
  Supplier? selectedSupplier;
  Branch? selectedBranch;

  bool get isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.product?.name ?? '';
      _stockController.text = widget.product?.stock?.toString() ?? '';
      _unitPriceController.text = widget.product?.unitprice?.toString() ?? '';
      _manufactureDateController.text = widget.product?.manufactureDate ?? '';
      _expiryDateController.text = widget.product?.expiryDate ?? '';
      selectedCategory = widget.product?.category;
      selectedSupplier = widget.product?.supplier;
      selectedBranch = widget.product?.branch;
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> _saveOrUpdateProduct() async {
    if (_formKey.currentState!.validate()) {
      var uri = isEditMode
          ? Uri.parse('http://localhost:8087/api/product/update/${widget.product!.id}')
          : Uri.parse('http://localhost:8087/api/product/save');

      var request = http.MultipartRequest(isEditMode ? 'PUT' : 'POST', uri);

      final product = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        stock: int.tryParse(_stockController.text),
        unitprice: int.tryParse(_unitPriceController.text),
        manufactureDate: _manufactureDateController.text,
        expiryDate: _expiryDateController.text,
        category: selectedCategory,
        supplier: selectedSupplier,
        branch: selectedBranch,
      );

      request.files.add(
        http.MultipartFile.fromString(
          'product',
          jsonEncode(product.toJson()),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (kIsWeb && webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage!,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditMode ? 'Product updated successfully!' : 'Product added successfully!')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to ${isEditMode ? "update" : "add"} product. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while ${isEditMode ? "updating" : "adding"} product.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Makes inner Scaffold transparent
          appBar: AppBar(
            title: Text(isEditMode ? 'Edit Product' : 'Add New Product'),
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter product name' : null,
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter stock' : null,
                  ),
                  TextFormField(
                    controller: _unitPriceController,
                    decoration: InputDecoration(labelText: 'Unit Price'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter unit price' : null,
                  ),
                  TextFormField(
                    controller: _manufactureDateController,
                    decoration: InputDecoration(labelText: 'Manufacture Date'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter manufacture date' : null,
                  ),
                  TextFormField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(labelText: 'Expiry Date'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter expiry date' : null,
                  ),
                  SizedBox(height: 16),
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Upload Image'),
                    onPressed: pickImage,
                  ),
                  if (kIsWeb && webImage != null)
                    Image.memory(webImage!, height: 100, width: 100, fit: BoxFit.cover)
                  else if (!kIsWeb && selectedImage != null)
                    Image.file(File(selectedImage!.path), height: 100, width: 100, fit: BoxFit.cover),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveOrUpdateProduct,
                    child: Text(isEditMode ? 'Update Product' : 'Save Product'),
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
