import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  // Rute ini bisa digunakan jika Anda ingin navigasi dengan nama
  static const routeName = '/edit-product';

  final Product? product;

  // Constructor untuk menerima produk yang mungkin akan diedit
  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  // Inisialisasi produk kosong dengan nilai default
  var _editedProduct = Product(
    id: '',
    name: '',
    price: 0,
    description: '',
    image: '',
  );

  // Controller untuk setiap field
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika ada produk yang diedit, isi form dengan datanya
    if (widget.product != null) {
      _editedProduct = widget.product!;
      _nameController.text = _editedProduct.name;
      _priceController.text = _editedProduct.price.toString();
      _descriptionController.text = _editedProduct.description;
      _imageUrlController.text = _editedProduct.image;
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    try {
      if (_editedProduct.id.isNotEmpty) {
        // Jika ID ada, berarti ini adalah mode edit
        await productProvider.updateProduct(_editedProduct);
      } else {
        // Jika ID kosong, ini adalah mode tambah
        await productProvider.addProduct(_editedProduct);
      }
      // Kembali ke halaman sebelumnya setelah berhasil
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Terjadi Kesalahan!'),
          content: Text('Sesuatu yang salah terjadi. Coba lagi nanti.'),
          actions: <Widget>[
            TextButton(
              child: Text('Oke'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama produk tidak boleh kosong.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(name: value);
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harga tidak boleh kosong.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Harga harus lebih besar dari nol.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Deskripsi tidak boleh kosong.';
                  }
                  if (value.length < 10) {
                    return 'Deskripsi minimal 10 karakter.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(description: value);
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL Gambar'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'URL gambar tidak boleh kosong.';
                  }
                  if (!value.startsWith('http') && !value.startsWith('https')) {
                    return 'Masukkan URL yang valid.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(image: value);
                },
                onFieldSubmitted: (_) {
                  _saveForm();
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Simpan Produk'),
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}