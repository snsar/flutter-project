import 'package:flutter/material.dart';
import 'package:queyndz/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(widget.product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                'Giá: ${widget.product.price} vnđ',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                'Trong kho còn: ${widget.product.quantity} sản phẩm',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product
                    .description, // Display the product description here
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: DropdownButton<int>(
                value: selectedQuantity,
                items: List.generate(
                  widget.product.quantity,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedQuantity = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _buyNow(context),
              child: Text('Mua ngay'),
            ),
          ],
        ),
      ),
    );
  }

  void _buyNow(BuildContext context) {
    if (selectedQuantity > widget.product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số lượng vượt quá lượng hàng tồn kho!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text(
              'Bạn có chắc muốn mua $selectedQuantity sản phẩm này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Chấp nhận'),
              onPressed: () async {
                final productRef = FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.product.id);
                FirebaseFirestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot = await transaction.get(productRef);

                  if (!snapshot.exists) {
                    throw Exception("Product does not exist!");
                  }

                  // Cast the data to a Map<String, dynamic>
                  Map<String, dynamic> data =
                      snapshot.data() as Map<String, dynamic>;

                  int currentQuantity = data['quantity'];
                  int newQuantity = currentQuantity - selectedQuantity;

                  if (newQuantity < 0) {
                    throw Exception("Insufficient stock!");
                  }

                  transaction.update(productRef, {'quantity': newQuantity});
                  Navigator.of(context).pop();
                }).then((result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Đã mua $selectedQuantity sản phẩm!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi mua sản phẩm: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
