import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageBlockeds.dart';
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowers.dart';
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowings.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Gérer les relations'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Gestion des followers'),
            onTap: () => _navigateTo(context, ManageFollowersPage()),
          ),
          ListTile(
            title: const Text('Gestion des followings'),
            onTap: () => _navigateTo(context, ManageFollowingsPage()),
          ),
          ListTile(
            title: const Text('Gestion des utilisateurs bloqués'),
            onTap: () => _navigateTo(context, ManageBlockedPage()),
          ),
          // Uncomment to add more options
          // ListTile(
          //   title: const Text('Gestion des demandes de suivi'),
          //   onTap: () => _navigateTo(context, const ChangePasswordPage()),
          // ),
        ],
      ),
    );
  }
}
