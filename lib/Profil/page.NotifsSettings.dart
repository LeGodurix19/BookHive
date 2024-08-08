import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('Paramètres de notifications'),
	  ),
	  body: const Center(
		child: Text('Ici, l\'utilisateur peut définir ses préférences de notifications.'),
	  ),
	);
  }
}