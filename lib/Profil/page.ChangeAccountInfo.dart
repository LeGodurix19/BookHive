import 'package:betta/Profil/pagesIn.ChangeAccountInfo/page.ChangeEmail.dart';
import 'package:betta/Profil/pagesIn.ChangeAccountInfo/page.ChangePseudo.dart';
import 'package:flutter/material.dart';

class ChangeAccountInfoPage extends StatelessWidget {
  const ChangeAccountInfoPage({super.key});

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
        title: const Text('Modifier les informations du compte'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Changer le pseudo'),
            onTap: () => _navigateToPage(context, const ChangePseudoPage()),
          ),
          ListTile(
            title: const Text('Changer l\'email'),
            onTap: () => _navigateToPage(context, const ChangeEmailPage()),
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
