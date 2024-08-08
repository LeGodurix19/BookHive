import 'package:flutter/material.dart';

class AllMessagesPage extends StatelessWidget {
  const AllMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Text('Page de Messages', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}