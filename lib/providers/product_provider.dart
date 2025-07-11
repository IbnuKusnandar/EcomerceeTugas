// lib/providers/product_provider.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _errorMessage = "Gagal memuat produk: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- PERBAIKAN DIMULAI DI SINI ---

  /// Menambahkan produk baru melalui ProductService.
  /// Setelah berhasil, data produk akan dimuat ulang.
  Future<void> addProduct(Product product) async {
    try {
      await _service.addProduct(product);
      // Muat ulang daftar produk untuk menampilkan data terbaru
      await fetchProducts();
    } catch (e) {
      // teruskan (rethrow) error agar bisa ditangani di UI
      throw Exception("Gagal menambahkan produk: ${e.toString()}");
    }
  }

  /// Memperbarui produk yang ada melalui ProductService.
  /// Setelah berhasil, data produk akan dimuat ulang.
  Future<void> updateProduct(Product product) async {
    try {
      await _service.updateProduct(product);
      // Muat ulang daftar produk untuk menampilkan data terbaru
      await fetchProducts();
    } catch (e) {
      // teruskan (rethrow) error agar bisa ditangani di UI
      throw Exception("Gagal memperbarui produk: ${e.toString()}");
    }
  }

  /// Menghapus produk berdasarkan ID.
  Future<void> deleteProduct(String id) async {
    try {
      await _service.deleteProduct(id);
      // Hapus produk dari daftar lokal untuk pembaruan UI instan
      _products.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception("Gagal menghapus produk: ${e.toString()}");
    }
  }
}