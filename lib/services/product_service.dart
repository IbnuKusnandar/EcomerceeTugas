// lib/services/product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  // Gunakan 'private' convention dengan underscore
  final CollectionReference _ref =
  FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _ref.get();
    // PERBAIKAN: Menggunakan Product.fromMap yang sudah benar
    return snapshot.docs
        .map((doc) =>
        Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addProduct(Product product) {
    // PERBAIKAN: Menggunakan product.toMap
    return _ref.add(product.toMap());
  }

  Future<void> updateProduct(Product product) {
    // PERBAIKAN: Menggunakan product.toMap
    return _ref.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _ref.doc(id).delete();
  }
}