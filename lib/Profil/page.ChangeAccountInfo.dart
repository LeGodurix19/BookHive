import 'package:betta/Profil/pagesIn.ChangeAccountInfo/page.ChangeEmail.dart';
import 'package:betta/Profil/pagesIn.ChangeAccountInfo/page.ChangePseudo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

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
        title: Text(AppLocalizations.of(context)!.changeAccountInfo), // Utilisation de la localisation
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.changePseudo), // Utilisation de la localisation
            onTap: () => _navigateToPage(context, const ChangePseudoPage()),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.changeEmail), // Utilisation de la localisation
            onTap: () => _navigateToPage(context, const ChangeEmailPage()),
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
