import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  bool _isLoading = false;

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: _currentPassword,
    );

    try {
      // Ré-authentification de l'utilisateur avant de changer le mot de passe
      await user.reauthenticateWithCredential(credential);

      // Envoyer un email de vérification
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un email pour changer de mot de passe a été envoyé. Veuillez vérifier votre email.')),
      );

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changePassword), // Utilisation de la localisation
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.currentPassword, // Utilisation de la localisation
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterCurrentPassword; // Utilisation de la localisation
                        }
                        return null;
                      },
                      onSaved: (value) => _currentPassword = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _changePassword();
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.changePassword), // Utilisation de la localisation
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
