import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../page.Home.dart';
import 'class.Auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage;
  bool isLogin = true;
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _authenticate() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.fillAllFields; // Utilisation de la localisation
      });
      return;
    }

    try {
      if (isLogin) {
        await Auth().signInWithEmailAndPassword(email: email, password: password);
      } else {
        await Auth().createUserWithEmailAndPassword(email: email, password: password);
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _buildTitle() {
    return Text(
      AppLocalizations.of(context)!.authentication, // Utilisation de la localisation
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email), // Utilisation de la localisation
      obscureText: obscureText,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _authenticate,
      child: Text(isLogin ? AppLocalizations.of(context)!.signIn : AppLocalizations.of(context)!.signUp), // Utilisation de la localisation
    );
  }

  Widget _buildSwitchButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          errorMessage = null; // Réinitialiser le message d'erreur
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? AppLocalizations.of(context)!.createAccount : AppLocalizations.of(context)!.alreadyHaveAccount), // Utilisation de la localisation
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      errorMessage ?? '',
      style: const TextStyle(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextField(AppLocalizations.of(context)!.email, emailController), // Utilisation de la localisation
            _buildTextField(AppLocalizations.of(context)!.password, passwordController, obscureText: true), // Utilisation de la localisation
            const SizedBox(height: 16), // Ajoute un espacement entre les éléments
            _buildSubmitButton(),
            const SizedBox(height: 8), // Ajoute un espacement entre les éléments
            _buildSwitchButton(),
            _buildErrorMessage(),
          ],
        ),
      ),
    );
  }
}
