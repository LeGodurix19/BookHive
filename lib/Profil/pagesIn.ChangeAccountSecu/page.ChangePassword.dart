import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betta/main.dart';
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
  String _newPassword = '';
  bool _isLoading = false;

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User user = FirebaseAuth.instance.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPassword,
      );

      // Ré-authentification de l'utilisateur avant de changer le mot de passe
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPassword);

      // Afficher un message de succès
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(navigatorKey.currentContext!)!.passwordUpdated)), // Utilisation de la localisation
      );
      Navigator.pop(navigatorKey.currentContext!);
    } on FirebaseAuthException catch (e) {
      // Afficher un message d'erreur basé sur le type d'exception
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(navigatorKey.currentContext!)!.error + ': ${e.message}')), // Utilisation de la localisation
      );
    } catch (e) {
      // Afficher un message d'erreur générique
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdatingPassword)), // Utilisation de la localisation
      );
    } finally {
      // Réinitialiser l'état de chargement
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.newPassword, // Utilisation de la localisation
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterNewPassword; // Utilisation de la localisation
                        } else if (value.length < 6) {
                          return AppLocalizations.of(context)!.passwordTooShort; // Utilisation de la localisation
                        }
                        return null;
                      },
                      onSaved: (value) => _newPassword = value!,
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
