import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../page.Home.dart';
import 'class.Auth.dart';

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
        errorMessage = "Please fill in all fields";
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
    return const Text(
      'Authentification',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _authenticate,
      child: Text(isLogin ? 'Sign in' : 'Sign up'),
    );
  }

  Widget _buildSwitchButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          errorMessage = null; // Reset error message
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Create an account' : 'Already have an account?'),
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
            _buildTextField('Email', emailController),
            _buildTextField('Password', passwordController, obscureText: true),
            const SizedBox(height: 16), // Adds spacing between elements
            _buildSubmitButton(),
            const SizedBox(height: 8), // Adds spacing between elements
            _buildSwitchButton(),
            _buildErrorMessage(),
          ],
        ),
      ),
    );
  }
}
