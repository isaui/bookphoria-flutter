// HAPUS INI. INI HANYA UNTUK NGECEK AJA
//BISA DIPAKAI ALUR LOGINNYA
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/Homepage/api/update_history.dart';
import 'dart:convert';

import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';

import '../models/user.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    const String apiUrl = BASE_URL+'/login-flutter/'; // Ganti dengan URL endpoint login Anda
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    final resData = jsonDecode(response.body);

    if (resData['status'] == 200) {
      // Berhasil masuk, lakukan navigasi ke halaman selanjutnya

      print(resData['user']);
      User user = User.fromJson(resData['user']);
      ref.read(authProvider.notifier).setUserData(user);
      Navigator.pushReplacementNamed(context, '/');// Ganti dengan nama route halaman selanjutnya setelah login
    } else {
      // Tampilkan pesan kesalahan jika masuk gagal
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid credentials. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
               await  loginUser();// Panggil fungsi loginUser ketika tombol ditekan
               fetchHistory();
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
