import 'package:betta/Profil/page.ManageRelations.dart';
import 'package:flutter/material.dart';
import 'page.ChangeAccountInfo.dart';
import 'page.ChangeAccountSecu.dart';
import 'page.NotifsSettings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importer les localisations

class ProfilParametresPage extends StatelessWidget {
  const ProfilParametresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Récupérer les localisations

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile), // Utiliser la clé pour le titre
      ),
      body: ListView(
        children: _buildListTiles(context, localizations),
      ),
    );
  }

  List<Widget> _buildListTiles(BuildContext context, AppLocalizations localizations) {
    return [
      _buildListTile(
        context,
        icon: Icons.person,
        title: localizations.account, // Utiliser la clé pour le titre
        subtitle: localizations.personal_info, // Utiliser la clé pour le sous-titre
        destination: const ChangeAccountInfoPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.security,
        title: localizations.security, // Utiliser la clé pour le titre
        subtitle: localizations.security_settings, // Utiliser la clé pour le sous-titre
        destination: const ChangeAccountSecuPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.notifications,
        title: localizations.notifications, // Utiliser la clé pour le titre
        subtitle: localizations.notification_preferences, // Utiliser la clé pour le sous-titre
        destination: const NotificationSettingsPage(),
      ),
      _buildListTile(
        context,
        icon: Icons.group_rounded,
        title: localizations.social, // Utiliser la clé pour le titre
        subtitle: localizations.manage_relationships, // Utiliser la clé pour le sous-titre
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
