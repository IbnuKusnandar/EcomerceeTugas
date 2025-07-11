import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/cart_provider.dart';
import '../models/product.dart';

class CartItemWidget extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormat;

  CartItemWidget({required this.product, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(product.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(product.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${product.name} dihapus dari keranjang.'),
          duration: Duration(seconds: 2),
        ));
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Anda yakin?'),
            content: Text('Hapus "${product.name}" dari keranjang?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Tidak')),
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Ya, Hapus')),
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.image),
              radius: 30,
              onBackgroundImageError: (e, s) => Icon(Icons.image),
            ),
            title: Text(product.name),
            subtitle: Text('Harga: ${currencyFormat.format(product.price)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () => cart.removeSingleItem(product.id),
                ),
                Text('${product.quantity}x', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () => cart.addItem(product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}