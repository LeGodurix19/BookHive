import 'package:betta/Profil/pagesIn.ChangeAccountSecu/page.ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

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
        title: Text(AppLocalizations.of(context)!.changeAccountSecurity), // Utilisation de la localisation
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.changePassword), // Utilisation de la localisation
            onTap: () => _navigateToPage(context, const ChangePasswordPage()),
          ),
          // Uncomment when you want to add the change photo feature
          // ListTile(
          //   title: Text(AppLocalizations.of(context)!.changePhoto), // Utilisation de la localisation
          //   onTap: () => _navigateToPage(context, ChangePhotoPage()),
          // ),
        ],
      ),
    );
  }
}
