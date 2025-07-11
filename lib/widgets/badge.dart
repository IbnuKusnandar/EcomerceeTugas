import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child; // Widget yang akan ditampilkan (misal, ikon keranjang)
  final String value; // Jumlah item dalam bentuk String
  final Color? color;  // Warna opsional untuk badge

  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cek jika value adalah '0' atau kosong, kita tidak perlu menampilkan badge
    final bool showBadge = value.isNotEmpty && value != '0';

    return Stack(
      alignment: Alignment.center,
      children: [
        // Widget utama (misal, IconButton)
        child,

        // Hanya tampilkan badge jika showBadge adalah true
        if (showBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              // Dekorasi untuk badge (lingkaran merah)
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color ?? Colors.red, // Default warna merah jika tidak dispesifikasi
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}