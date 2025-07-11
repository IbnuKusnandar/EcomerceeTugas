import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _isLogin = true; // Toggle antara login dan register
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(message),
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
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      User? user;
      if (_isLogin) {
        user = await auth.login(emailCtrl.text, passCtrl.text);
      } else {
        user = await auth.register(emailCtrl.text, passCtrl.text);
      }

      if (user != null) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } on FirebaseAuthException catch (error) {
      // Handle error spesifik dari Firebase
      String errorMessage = 'Autentikasi gagal.';
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        errorMessage = 'Email atau password salah.';
      } else if (error.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah digunakan.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      _showErrorDialog('Tidak dapat masuk. Silakan coba lagi nanti.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Masuk" : "Daftar")),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Masukkan email yang valid!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passCtrl,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password minimal 6 karakter.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'LOGIN' : 'DAFTAR'),
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Belum punya akun? Daftar'
                        : 'Sudah punya akun? Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}