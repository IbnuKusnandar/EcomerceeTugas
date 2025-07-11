import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/product_detail_screen.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  ProductGridItem({required this.product});

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              // PERBAIKAN: Menggunakan CircularProgressIndicator sebagai placeholder
              // Ini menghilangkan kebutuhan akan file 'assets/placeholder.png'
              placeholder: MemoryImage(kTransparentImage), // Placeholder transparan bawaan Flutter
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                // Tampilan jika gambar gagal dimuat dari network
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} ditambahkan!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'LIHAT',
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

// Tambahkan import ini di bagian atas file product_grid_item.dart
// import 'package:transparent_image/transparent_image.dart';
// Dan jangan lupa tambahkan package `transparent_image` di pubspec.yaml

/*
ATAU, jika Anda tidak ingin menambah package baru,
gunakan CircularProgressIndicator seperti ini (meskipun kurang mulus):

child: Image.network(
  product.image,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(child: CircularProgressIndicator());
  },
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
),
*/