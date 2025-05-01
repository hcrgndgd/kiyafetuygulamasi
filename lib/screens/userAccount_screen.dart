import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String fullName = 'Hacer Gündoğdu';
    final String email = 'hacergundogdu@gmail.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hesap Bilgileri',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ad Soyad',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              fullName,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            Divider(color: Colors.black54),
            const Text(
              'E-posta',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
