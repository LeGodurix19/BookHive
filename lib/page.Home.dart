import 'package:flutter/material.dart';
import 'package:betta/Profil/page.MyProfil.dart';
import 'package:betta/Research/page.Research.dart';
import 'Feed/page.Feed.dart';
import 'Book/page.Scan.dart';
import 'Book/page.Library.dart';
import 'package:betta/main.dart'; // Assurez-vous d'importer main.dart pour accéder à navigatorKey

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    ResearchPage(),
    ScanPage(),
    LibraryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToProfile() {
    navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => const ProfilPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookHive'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
