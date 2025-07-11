// lib/main.dart

import 'package:ecomercee/providers/cart_provider.dart';
import 'package:ecomercee/providers/product_provider.dart';
import 'package:ecomercee/screens/cart_screen.dart';
import 'package:ecomercee/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  // Kredensial Firebase Anda sudah benar
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDQ1qGMlOCO2FgMNcwk18BA27SjtLtqJaQ",
          authDomain: "ecommercee-c1310.firebaseapp.com",
          projectId: "ecommercee-c1310",
          storageBucket: "ecommercee-c1310.firebasestorage.app",
          messagingSenderId: "613832438301",
          appId: "1:613832438301:web:a4d122636fac330d640cf4",
          measurementId: "G-CNNLCW3J2Y"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Menggunakan MultiProvider untuk menyediakan semua state management
    return MultiProvider(
      providers: [
        // Menyediakan instance AuthService
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Menyediakan ProductProvider
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        // Menyediakan CartProvider
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Toko Online',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          colorScheme: ThemeData().colorScheme.copyWith(
            secondary: Colors.amber, // Warna aksen
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
            headlineSmall: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
            titleLarge: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        // Cek status login menggunakan StreamBuilder untuk pembaruan real-time
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData) {
              return HomeScreen(); // Jika sudah login, ke HomeScreen
            }
            return LoginScreen(); // Jika belum, ke LoginScreen
          },
        ),
        // Daftarkan semua rute yang digunakan di aplikasi
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}