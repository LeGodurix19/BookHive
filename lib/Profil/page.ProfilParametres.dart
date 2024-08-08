import 'package:betta/Profil/page.ManageRelations.dart';
import 'package:flutter/material.dart';
import 'page.ChangeAccountInfo.dart';
import 'page.ChangeAccountSecu.dart';
import 'page.NotifsSettings.dart';

class ProfilParametresPage extends StatelessWidget {
  const ProfilParametresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres du Profil'),
      ),
      body: ListView(
        children: _buildListTiles(context),
      ),
    );
  }

  List<Widget> _buildListTiles(BuildContext context) {
    return [
      _buildListTile(
        context,
        icon: Icons.person,
        title: 'Compte',
        subtitle: 'Informations personnelles',
        destination: const ChangeAccountInfoPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.security,
        title: 'Sécurité',
        subtitle: 'Paramètres de sécurité',
        destination: const ChangeAccountSecuPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.notifications,
        title: 'Notifications',
        subtitle: 'Préférences de notification',
        destination: const NotificationSettingsPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.group_rounded,
        title: 'Social',
        subtitle: 'Gestion des relations',
        destination: const ManageRelations(),
      ),
      // Ajoutez d'autres ListTile ici si nécessaire
    ];
  }

  Widget _buildListTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
