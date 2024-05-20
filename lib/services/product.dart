import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queyndz/models/product.dart';
import 'package:path/path.dart' as Path;

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get a list of products
  Stream<List<Product>> getProductsStream() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Add a product
  Future<void> addProduct(Product product, File imageFile) async {
    String imageUrl = await uploadImage(imageFile, product.id);
    product = Product(
      id: product.id,
      name: product.name,
      imageUrl: imageUrl, // Update with the new image URL
      quantity: product.quantity,
      description: product.description,
      price: product.price,
    );
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toMap());
  }

  // Update a product
  Future<void> updateProduct(Product product, File? imageFile) async {
    // If a new image file is provided, upload it and get the new URL
    String imageUrl = product.imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile, product.id);
    }

    // Update the product with the new details and image URL
    await _firestore.collection('products').doc(product.id).update({
      'name': product.name,
      'imageUrl': imageUrl,
      'quantity': product.quantity,
      'description': product.description,
      'price': product.price,
    });
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    // Delete the product document from Firestore
    await _firestore.collection('products').doc(productId).delete();
    // Delete the product image from Firebase Storage
    await _storage.ref('product_images/$productId').delete();
  }

  // Upload image and return the URL
  Future<String> uploadImage(File imageFile, String productId) async {
    try {
      if (imageFile.existsSync()) {
        Reference storageReference =
            _storage.ref().child('product_images/$productId');
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        return await taskSnapshot.ref.getDownloadURL();
      } else {
        print('File does not exist.');
        return '';
      }
    } catch (e) {
      print('An error occurred while uploading the image: $e');
      return '';
    }
  }

  // Generate a new ID for a product
  String generateProductId() {
    return _firestore.collection('products').doc().id;
  }
}
