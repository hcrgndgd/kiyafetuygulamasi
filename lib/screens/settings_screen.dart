import 'package:flutter/material.dart';
import 'package:wardrobe_app/screens/changePassword_screen.dart';
import 'package:wardrobe_app/screens/userAccount_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple.shade800,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Hesap Bilgileri'),
            trailing: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountScreen(),
                          ),
                        );
              },
            ),
          ),
          const Divider(color: Colors.black54),
          ListTile(
            title: const Text('Şifremi Değiştir'),
            trailing: IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
              },
            ),
          ),
          const Divider(color: Colors.black54),
          ListTile(
            title: const Text('Çıkış Yap'),
            trailing: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Çıkış yapma işlemi gelecek
              },
            ),
          ),
          const Divider(color: Colors.black26),
        ],
      ),
    );
  }
}
