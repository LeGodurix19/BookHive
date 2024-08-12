import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageBlockeds.dart';
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowers.dart';
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class ManageRelations extends StatelessWidget {
  const ManageRelations({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageRelations), // Utilisation de la localisation
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.manageFollowers), // Utilisation de la localisation
            onTap: () => _navigateTo(context, ManageFollowersPage()),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.manageFollowings), // Utilisation de la localisation
            onTap: () => _navigateTo(context, ManageFollowingsPage()),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.manageBlockedUsers), // Utilisation de la localisation
            onTap: () => _navigateTo(context, ManageBlockedPage()),
          ),
          // Uncomment to add more options
          // ListTile(
          //   title: Text(AppLocalizations.of(context)!.manageFollowRequests), // Utilisation de la localisation
          //   onTap: () => _navigateTo(context, const ManageFollowRequestsPage()),
          // ),
        ],
      ),
    );
  }
}
