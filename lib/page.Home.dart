import 'package:betta/Profil/class.Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<String?> _getUrlPic() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(Auth().user!.uid)
        .get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;
      return data?['Picture'];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookHive'),
        actions: <Widget>[
          FutureBuilder<String?>(
            future: _getUrlPic(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                var urlPic = snapshot.data;
                return IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: urlPic != null && urlPic.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(urlPic),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: urlPic == null || urlPic.isEmpty
                        ? const Icon(Icons.account_circle, size: 100)
                        : null,
                  ),
                  onPressed: _navigateToProfile,
                );
              }
            },
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
