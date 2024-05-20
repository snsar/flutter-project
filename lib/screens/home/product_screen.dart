import 'package:flutter/material.dart';
import 'package:queyndz/models/product.dart';
import 'package:queyndz/services/product.dart';
import 'package:queyndz/screens/home/product_detail.dart'; // Đảm bảo bạn đã tạo màn hình này

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  void fetchProducts() {
    _productService.getProductsStream().listen((updatedProductList) {
      setState(() {
        productList = updatedProductList;
        filteredProductList = productList;
      });
    });
  }

  void filterProducts() {
    List<Product> results = [];
    if (searchController.text.isEmpty) {
      results = productList;
    } else {
      results = productList
          .where((product) => product.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredProductList = results;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                filterProducts();
              },
            ),
          ),
          onChanged: (value) {
            filterProducts();
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số lượng item trên mỗi hàng
          childAspectRatio:
              3 / 4, // Tỉ lệ giữa chiều rộng và chiều cao của mỗi item
          crossAxisSpacing: 10, // Khoảng cách giữa các item theo chiều ngang
          mainAxisSpacing: 10, // Khoảng cách giữa các item theo chiều dọc
        ),
        itemCount: filteredProductList.length,
        itemBuilder: (context, index) {
          final product = filteredProductList[index];
          return GestureDetector(
            onTap: () {
              // Điều hướng đến màn hình chi tiết sản phẩm
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                      product: product), // Đảm bảo bạn đã tạo màn hình này
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Add this line
                children: <Widget>[
                  Expanded(
                    child: ClipRect(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1, // Set the aspect ratio for the images
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit
                                .cover, // Use BoxFit.cover to fill the box
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('Số lượng: ${product.quantity} - Giá: ${product.price} vnđ'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
