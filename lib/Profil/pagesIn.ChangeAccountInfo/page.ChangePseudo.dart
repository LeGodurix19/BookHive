import 'dart:async';
import 'package:betta/Book/page.Scan.dart';
import 'package:betta/Errors/page.errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:betta/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class ChangePseudoPage extends StatefulWidget {
  const ChangePseudoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePseudoPageState createState() => _ChangePseudoPageState();
}

class _ChangePseudoPageState extends State<ChangePseudoPage> {
  final _formKey = GlobalKey<FormState>();
  String _pseudo = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPseudo();
  }

  Future<void> _loadUserPseudo() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      setState(() {
        _pseudo = userDoc['username'] ?? ''; // Récupérer le pseudo de l'utilisateur
        _isLoading = false; // Mise à jour de l'état de chargement
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      setState(() {
        _isLoading = false; // Mise à jour de l'état de chargement en cas d'erreur
      });
    }
  }

  Future<String?> _validatePseudo(String? value) async {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterPseudo; // Utilisation de la localisation
    } else if (value.length < 3) {
      return AppLocalizations.of(context)!.pseudoTooShort; // Utilisation de la localisation
    } else {
      try {
        var result = await FirebaseFirestore.instance
            .collection('Users')
            .where('username', isEqualTo: value)
            .get();
        if (result.docs.isNotEmpty) {
          return AppLocalizations.of(navigatorKey.currentContext!)!.pseudoAlreadyUsed; // Utilisation de la localisation
        }
      } catch (e) {
        await PageError.handleError(e, StackTrace.current);
        return AppLocalizations.of(navigatorKey.currentContext!)!.errorValidatingPseudo; // Utilisation de la localisation
      }
    }
    return null;
  }

  Future<void> _updatePseudo() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'username': _pseudo});
      Navigator.of(navigatorKey.currentContext!).pop(); // Utilisation de navigatorKey
      showRiveAnimationDialog('assets/validate.riv', false);
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.pop(navigatorKey.currentContext!); // Utilisation de navigatorKey
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(navigatorKey.currentContext!)!.errorUpdatingPseudo)), // Utilisation de la localisation
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changePseudo), // Utilisation de la localisation
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.newPseudo, // Utilisation de la localisation
                  ),
                  initialValue: _pseudo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPseudo; // Utilisation de la localisation
                    } else if (value.length < 3) {
                      return AppLocalizations.of(context)!.pseudoTooShort; // Utilisation de la localisation
                    } else if (value == _pseudo) {
                      return AppLocalizations.of(context)!.pleaseEnterNewPseudo; // Utilisation de la localisation
                    }
                    return null;
                  },
                  onSaved: (value) => _pseudo = value!,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            setState(() {
              _isLoading = true;
            });
            showRiveAnimationDialog('assets/send.riv', true);
            var errorMessage = await _validatePseudo(_pseudo);
            if (errorMessage != null) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            } else {
              await _updatePseudo();
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
