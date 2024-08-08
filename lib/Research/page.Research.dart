import 'dart:convert';

import 'package:betta/Book/page.BookDetails.dart';
import 'package:betta/Profil/page.MyProfil.dart';
import 'package:betta/Errors/errorsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum SearchType { users, books }

Future<List<Map<String, dynamic>>> _buildList(
    String query, String collection) async {
  try {
    if (collection == 'Users') {
      final startAtUsername = query;
      final endAtUsername = query + '\uf8ff'; // Caractère Unicode pour la recherche
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: startAtUsername)
          .where('username', isLessThanOrEqualTo: endAtUsername)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      final Uri apiUri = Uri.parse('https://api.book-hive.com/search_title/');
      final response = await http.post(
        apiUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          'title': query,
          "limit": 10,
        }),
      );

      if (response.statusCode == 200) {
        final books = jsonDecode(response.body)['books'];
        if (books is List) {
          return books.map<Map<String, dynamic>>((book) => book as Map<String, dynamic>).toList();
        }
        throw Exception('Format de données inattendu');
      }
      return [];
    }
  } catch (e) {
    await PageError.handleError(e, StackTrace.current);
    return [];
  }
}

class ResearchPage extends StatefulWidget {
  const ResearchPage({super.key});

  @override
  _ResearchPageState createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  SearchType? _searchType;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 20),
            _buildSearchTypeButtons(),
            Expanded(child: _searchType == SearchType.users ? _buildListView('Users') : _buildListView('Books')),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Rechercher des livres ou des amis...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildSearchTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _searchType = SearchType.users),
          child: const Text('Utilisateurs'),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _searchType = SearchType.books),
          child: const Text('Livres'),
        ),
      ],
    );
  }

  Widget _buildListView(String collection) {
    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Entrez un nom d\'utilisateur ou un titre pour commencer la recherche'));
    }
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _buildList(_searchController.text, collection),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return collection == 'Users' ? _buildUserTile(items[index]) : _buildBookTile(items[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final leading = user['Picture'] != null && user['Picture'] != "" ? CircleAvatar(
      backgroundImage: NetworkImage(user['Picture']),
    ) : const Icon(Icons.account_circle);
    
    return ListTile(
      leading: leading,
      title: Text(user['username']),
      onTap: () {
        String uid = user['Uid'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilPage(uid: uid)),
        );
      },
    );
  }

  Widget _buildBookTile(Map<String, dynamic> book) {
    return ListTile(
      title: Text(book['title']),
      subtitle: Text(book['author']),
      leading: Image.network(
        book['url_img'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailsPage(isbn: book['isbn'])),
        );
      },
    );
  }
}
