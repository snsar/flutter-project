import 'package:flutter/material.dart';
import 'package:queyndz/models/product.dart';
import 'package:queyndz/services/product.dart';
import 'package:queyndz/screens/home/edit_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ProductService _productService = ProductService();
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() {
    _productService.getProductsStream().listen((updatedProductList) {
      setState(() => productList = updatedProductList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductEditScreen()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return ListTile(
            leading: Image.network(product.imageUrl, width: 50, height: 50),
            title: Text(product.name),
            subtitle:
                Text('Số lượng: ${product.quantity} - Giá: ${product.price} vnđ'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductEditScreen(product: product)),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _productService.deleteProduct(product.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
