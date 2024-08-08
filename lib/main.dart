import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'class.WidgetTree.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Utiliser runZonedGuarded pour garantir que tout se passe dans la même zone
  runZonedGuarded(() async {
    await dotenv.load(fileName: ".env");

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Initialiser Sentry
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
      },
      // Initialiser les Widgets en mode Flutter
      appRunner: () => runApp(const MyApp()),
    );
  }, (Object error, StackTrace stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    runApp(const ErrorPage());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookHive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey, // Utilisez le GlobalKey ici
      home: const WidgetTree(),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('An unexpected error occurred. The team is working on it.'),
      ),
    );
  }
}
