// Ecomercee/lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
// PERBAIKAN: Import halaman form produk
import 'product_form_screen.dart';
import '../widgets/product_grid_item.dart';
// Beri alias 'custom_badge' pada import widget Badge buatan Anda
import '../widgets/badge.dart' as custom_badge;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Memuat produk saat halaman pertama kali dibuka
    _productsFuture =
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    }
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _productsFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (dataSnapshot.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data.'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productsFuture = Provider.of<ProductProvider>(context,
                          listen: false)
                          .fetchProducts();
                    });
                  },
                  child: const Text('Coba Lagi'),
                )
              ],
            ),
          );
        }

        return Consumer<ProductProvider>(
          builder: (ctx, productProvider, child) {
            final products = productProvider.products;
            if (products.isEmpty) {
              return const Center(
                  child: Text('Tidak ada produk yang tersedia saat ini.'));
            }

            return RefreshIndicator(
              onRefresh: () => productProvider.fetchProducts(),
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: products.length,
                itemBuilder: (ctx, i) =>
                    ProductGridItem(product: products[i]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Online'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, ch) => custom_badge.Badge( // Gunakan alias di sini
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildBody(),
      // --- PERBAIKAN DI SINI ---
      // Menambahkan FloatingActionButton untuk menuju halaman tambah produk
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke ProductFormScreen tanpa membawa data produk
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Produk',
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}