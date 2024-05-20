import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final String description;
  final double price;
  

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.description,
    required this.price,
 
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'description': description,
      'price': price,
      
    };
  }

  static Product fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      description: map['description'],
      price: map['price'],
    );
  }
}
