import 'dart:async';
import 'package:betta/Book/page.Scan.dart';
import 'package:betta/Errors/errorsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:betta/main.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      setState(() {
        _email = userDoc['Email'] ?? ''; // Récupérer l'email de l'utilisateur
        _isLoading = false; // Mise à jour de l'état de chargement
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _validateEmail(String? value) async {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    try {
      var result = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: value)
          .get();
      if (result.docs.isNotEmpty) {
        return 'Cet email est déjà utilisé';
      }
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      return 'Erreur lors de la validation de l\'email';
    }
    return null;
  }

  Future<void> _updateEmail() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'Email': _email});
      Navigator.of(navigatorKey.currentContext!).pop(); // Utilisation de navigatorKey
      showRiveAnimationDialog('assets/validate.riv', false);
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.pop(navigatorKey.currentContext!); // Utilisation de navigatorKey
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour de l\'email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer l\'email'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Nouvel email'),
                  initialValue: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    } else if (value == _email) {
                      return 'Veuillez entrer un nouvel email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
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
            var errorMessage = await _validateEmail(_email);
            if (errorMessage != null) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(errorMessage)));
            } else {
              await _updateEmail();
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
