import 'package:betta/Book/page.BookDetails.dart';
import 'package:betta/Errors/errorsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betta/main.dart';

class Books {
  final String title;
  final String urlImg;
  final String isbn;
  int status;

  Books(this.title, this.urlImg, this.isbn, this.status);
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String shelfName = 'standard'; // Nom de l'étagère
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  // Stream pour obtenir les livres d'une étagère d'un utilisateur
  Stream<List<Books>> getUserBooksStream(String shelfName) {
    return _firestore
        .collection('Users')
        .doc(currentUserId)
        .collection('shelves')
        .doc(shelfName)
        .snapshots()
        .asyncMap((snapshot) async {
      try {
        if (!snapshot.exists || snapshot.data() == null) return [];

        List<Books> books = [];
        Map<String, dynamic> shelfData = snapshot.data()!;

        for (var isbn in shelfData.keys) {
          var bookSnapshot = await _firestore.collection('Books').doc(isbn).get();

          if (bookSnapshot.exists) {
            books.add(Books(
              bookSnapshot['title'],
              bookSnapshot['url_img'],
              isbn,
              shelfData[isbn]['status'],
            ));
          }
        }
        return books;
      } catch (e) {
        await PageError.handleError(e, StackTrace.current);
        return [];
      }
    });
  }

  void showStatusDialog(Books book) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le statut'),
          content: DropdownButton<int>(
            value: book.status,
            items: <int>[0, 1, 2].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value == 0 ? 'À lire' : value == 1 ? 'En cours' : 'Fini'),
              );
            }).toList(),
            onChanged: (int? newValue) async {
              if (newValue != null) {
                try {
                  Navigator.of(context).pop();
                  await _firestore
                      .collection('Users')
                      .doc(currentUserId)
                      .collection('shelves')
                      .doc(shelfName)
                      .update({
                    book.isbn: {'status': newValue},
                  });
                } catch (e) {
                  await PageError.handleError(e, StackTrace.current);
                }
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Books>>(
        stream: getUserBooksStream(shelfName),
        builder: (BuildContext context, AsyncSnapshot<List<Books>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun livre trouvé'));
          }

          List<Books> books = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.75,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return buildBookCover(book);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildBookCover(Books book) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => BookDetailsPage(isbn: book.isbn)),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(book.urlImg),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: buildStatusIcon(book.status),
              onPressed: () {
                showStatusDialog(book);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusIcon(int status) {
    Color color;
    IconData? icon;

    switch (status) {
      case 1:
        color = const Color.fromARGB(200, 255, 153, 0);
        icon = Icons.loop;
        break;
      case 2:
        color = const Color.fromARGB(200, 76, 175, 79);
        icon = Icons.check;
        break;
      default:
        color = const Color.fromARGB(200, 205, 205, 205);
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
