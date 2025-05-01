import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _oldPasswordError;
  String? _newPasswordError;

  String oldPassword = "123456"; 

  final int minPasswordLength = 7;

  bool _isPasswordMatching() {
    return _newPasswordController.text == _confirmNewPasswordController.text;
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      if (_oldPasswordController.text != oldPassword) {
        setState(() {
          _oldPasswordError = "Eski şifrenizi yanlış girdiniz.";
        });
        return;
      } else {
        setState(() {
          _oldPasswordError = null;
        });
      }

      if (!_isPasswordMatching()) {
        setState(() {
          _newPasswordError = "Yeni şifreler uyuşmuyor.";
        });
        return;
      } else {
        setState(() {
          _newPasswordError = null;
        });
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreniz başarıyla değiştirildi!")),
      );

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Değiştir', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Eski Şifre",
                  hintText: "Eski şifrenizi girin",
                  errorText: _oldPasswordError,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Eski şifrenizi girin";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Yeni Şifre",
                  hintText: "Yeni şifrenizi girin",
                  errorText: _newPasswordError,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Yeni şifreyi girin";
                  }
                  if (value.length < minPasswordLength) {
                    return "Şifre en az $minPasswordLength karakter olmalı";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Yeni Şifre Tekrar",
                  hintText: "Yeni şifrenizi tekrar girin",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Yeni şifrenizi tekrar girin";
                  }
                  if (!_isPasswordMatching()) {
                    return "Yeni şifreler uyuşmuyor";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Şifreyi Değiştir', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
