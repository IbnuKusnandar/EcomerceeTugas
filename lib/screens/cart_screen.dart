import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // <-- PASTIKAN IMPORT INI ADA

import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart'; // <-- Pastikan file ini dibuat

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _checkout(BuildContext context, CartProvider cart) async {
    // Tampilkan dialog konfirmasi sebelum checkout
    final confirmCheckout = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Konfirmasi Pembayaran'),
          content: Text('Lanjutkan pembayaran sebesar ${currencyFormat.format(cart.totalAmount)}?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Batal')),
            ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Bayar')),
          ],
        ));

    if (confirmCheckout != true) {
      return;
    }

    await cart.checkout();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/succed.json', width: 150, repeat: false),
            SizedBox(height: 16),
            Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (Home)
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Keranjang Anda')),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                child: Text(
                  'Keranjang masih kosong.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
                : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => CartItemWidget( // Menggunakan widget terpisah
                product: cartItems[i],
                currencyFormat: currencyFormat,
              ),
            ),
          ),
          if (cartItems.isNotEmpty)
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Chip(
                      label: Text(
                        currencyFormat.format(cart.totalAmount),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: cart.totalAmount <= 0
                          ? null
                          : () => _checkout(context, cart),
                      child: Text('BAYAR'),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}