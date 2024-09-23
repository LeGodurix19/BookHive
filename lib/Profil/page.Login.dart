import 'package:betta/Profil/page.ProfilCustom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betta/main.dart';
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
        errorMessage = AppLocalizations.of(navigatorKey.currentContext!)!.fillAllFields; // Utilisation de la localisation
      });
      return;
    }

    try {
      if (isLogin) {
        await Auth().signInWithEmailAndPassword(email: email, password: password);
        bool isFirstTime = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc) => doc['firstTime']);
        if (Auth().user!.emailVerified == true && isFirstTime == true) {
          print("isFirstTime");
          Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (context) => const ProfilCustom()));
        } else {
          Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } else {
        await Auth().createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Un email de vérification a été envoyé. Veuillez vérifier votre email.')),
        );
        setState(() {
          isLogin = true;
        });
      }
      // ignore: use_build_context_synchronously
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _buildTitle() {
    return Text(
      AppLocalizations.of(navigatorKey.currentContext!)!.authentication, // Utilisation de la localisation
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label), // Utilisation de la localisation
      obscureText: obscureText,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _authenticate,
      child: Text(isLogin ? AppLocalizations.of(navigatorKey.currentContext!)!.signIn : AppLocalizations.of(context)!.signUp), // Utilisation de la localisation
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
      child: Text(isLogin ? AppLocalizations.of(navigatorKey.currentContext!)!.createAccount : AppLocalizations.of(context)!.alreadyHaveAccount), // Utilisation de la localisation
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
