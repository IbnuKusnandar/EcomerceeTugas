import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    // Menerima produk melalui arguments saat navigasi
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Produk
            Hero(
              tag: product.id, // Tag Hero harus sama dengan di ProductGridItem
              child: Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 100),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Nama Produk
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // 3. Harga
                  Text(
                    currencyFormat.format(product.price),
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  // 4. Deskripsi
                  Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 100), // Spasi untuk tombol fixed di bawah
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol Beli di bagian bawah (Fixed Footer)
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            cartProvider.addItem(product);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} ditambahkan ke keranjang!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'LIHAT',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  },
                ),
              ),
            );
          },
          child: Text('+ Keranjang', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}