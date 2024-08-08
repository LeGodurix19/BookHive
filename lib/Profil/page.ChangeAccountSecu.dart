import 'package:betta/Profil/pagesIn.ChangeAccountSecu/page.ChangePassword.dart';
import 'package:flutter/material.dart';

class ChangeAccountSecuPage extends StatelessWidget {
  const ChangeAccountSecuPage({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier les informations de sécurité du compte'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Changer le mot de passe'),
            onTap: () => _navigateToPage(context, const ChangePasswordPage()),
          ),
          // Uncomment when you want to add the change photo feature
          // ListTile(
          //   title: const Text('Changer la photo'),
          //   onTap: () => _navigateToPage(context, ChangePhotoPage()),
          // ),
        ],
      ),
    );
  }
}
