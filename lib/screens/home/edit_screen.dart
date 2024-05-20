import 'package:flutter/material.dart';
import 'package:queyndz/models/product.dart';
import 'package:queyndz/services/product.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProductEditScreen extends StatefulWidget {
  final Product? product;

  const ProductEditScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final ProductService _productService = ProductService();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _quantityController.text = widget.product!.quantity.toString();
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      // _imageFile needs to be handled if you're displaying the existing image
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    final newProduct = Product(
      id: widget.product?.id ?? _productService.generateProductId(),
      name: _nameController.text,
      imageUrl: '', // This will be updated after the image is uploaded
      quantity: int.parse(_quantityController.text),
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
    );
    if (_imageFile != null) {
      if (widget.product == null) {
        // Add new product logic
        await _productService.addProduct(newProduct, _imageFile!);
      } else {
        // Edit existing product logic
        await _productService.updateProduct(newProduct, _imageFile);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn hình ảnh cho sản phẩm!')),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null
            ? 'Thêm sản phẩm mới'
            : 'Chỉnh sửa sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn hình ảnh'),
              ),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: 100,
                  height: 100,
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProduct,
        child: Icon(Icons.save),
      ),
    );
  }
}
