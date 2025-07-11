// providers/cart_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, Product> _items = {};

  Map<String, Product> get items => {..._items}; // Return a copy for safety
  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  CartProvider() {
    _loadCartFromPrefs();
  }

  // Menambah produk atau meningkatkan quantity
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Jika sudah ada, update quantity menggunakan copyWith
      _items.update(
        product.id,
            (existingProduct) => existingProduct.copyWith(
          quantity: existingProduct.quantity + 1,
        ),
      );
    } else {
      // Jika belum ada, tambahkan produk baru
      _items.putIfAbsent(product.id, () => product.copyWith(quantity: 1));
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  // Mengurangi quantity atau menghapus item jika quantity = 1
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    final currentQuantity = _items[productId]!.quantity;
    if (currentQuantity > 1) {
      // Kurangi quantity menggunakan copyWith
      _items.update(
        productId,
            (existingProduct) => existingProduct.copyWith(
          quantity: existingProduct.quantity - 1,
        ),
      );
    } else {
      // Hapus dari keranjang jika quantity tinggal 1
      _items.remove(productId);
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  // Menghapus item sepenuhnya dari keranjang
  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  // Checkout dan kosongkan keranjang
  Future<void> checkout() async {
    // Logika untuk mengirim pesanan ke backend bisa ditambahkan di sini
    print('Checkout successful! Items cleared.');
    _items.clear();
    await _clearPrefs();
    notifyListeners();
  }

  // --- Logika Shared Preferences ---

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartDataString = prefs.getString('cart');
    if (cartDataString == null) return;

    final List<dynamic> cartDataList = json.decode(cartDataString);
    // Lebih efisien: Cukup panggil Product.fromJson sekali per item
    _items = {
      for (var itemData in cartDataList)
        (Product.fromJson(itemData)).id: Product.fromJson(itemData)
    };
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartList = _items.values.map((item) => item.toJson()).toList();
    await prefs.setString('cart', json.encode(cartList));
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
  }
}