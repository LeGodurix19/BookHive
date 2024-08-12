import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Ajoutez cet import
import 'package:betta/main.dart';

class PageError {
  // Méthode pour gérer l'erreur et envoyer les détails à Sentry
  static Future<void> handleError(Object error, StackTrace stackTrace) async {
    // Envoyer l'erreur à Sentry
    await Sentry.captureException(error, stackTrace: stackTrace);

    // Naviguer vers la page d'erreur en utilisant le navigatorKey
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => const ErrorPage()),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.error)), // Utilisation de la localisation
      body: const Center(
        child: Text('Une erreur inattendue s\'est produite. L\'équipe travaille à la résoudre.'),
      ),
    );
  }
}
