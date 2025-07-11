// lib/models/product.dart

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    // Deskripsi harus ada, meskipun kosong
    this.description = 'Tidak ada deskripsi untuk produk ini.',
    this.quantity = 1,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? description,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  // Konversi dari Map (JSON) ke objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      description: json['description'] ?? 'Tidak ada deskripsi.',
      quantity: (json['quantity'] as int?) ?? 1,
    );
  }

  // PERBAIKAN: Menambahkan fromMap untuk kompatibilitas
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    final data = {...map, 'id': id};
    return Product.fromJson(data);
  }

  // Konversi dari objek Product ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'quantity': quantity,
    };
  }

  // PERBAIKAN: Menambahkan toMap untuk kompatibilitas
  Map<String, dynamic> toMap() {
    // Tidak perlu memasukkan ID karena Firestore mengelolanya secara terpisah
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}