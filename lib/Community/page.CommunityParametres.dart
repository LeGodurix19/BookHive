import 'package:flutter/material.dart';

class CommunityParametresPage extends StatelessWidget {
  const CommunityParametresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: const Center(
        child: Text('Page de Paramètres', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
