import 'dart:async';
import 'package:betta/Book/page.Scan.dart';
import 'package:betta/Errors/errorsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:betta/main.dart';

class BookDetailsPage extends StatelessWidget {
  final String isbn;

  const BookDetailsPage({super.key, required this.isbn});

  void reloadPage() {
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => BookDetailsPage(isbn: isbn)),
    );
  }

  Future<Map<String, dynamic>?> fetchBookDetails(String isbn) async {
    try {
      var document = await FirebaseFirestore.instance.collection('Books').doc(isbn).get();
      return document.exists ? document.data() : null;
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> isInCollection(String isbn, String collectionName) async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return false;

      var documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('shelves')
          .doc(collectionName)
          .get();

      var data = documentSnapshot.data();
      return data != null && data.containsKey(isbn);
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      return false;
    }
  }

  Future<void> toggleCollection(String isbn, String collectionName, bool add) async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      showRiveAnimationDialog('assets/send.riv', true);

      final shelvesRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('shelves');

      if (add) {
        if (collectionName != "wishlist") {
          await shelvesRef.doc("wishlist").update({
            isbn: FieldValue.delete(),
          });
        }
        await shelvesRef.doc(collectionName).set({
          isbn: {"status": 0}
        }, SetOptions(merge: true));
      } else {
        await shelvesRef.doc(collectionName).update({
          isbn: FieldValue.delete(),
        });
      }

      Navigator.of(navigatorKey.currentContext!).pop();
      showRiveAnimationDialog('assets/validate.riv', false);
      Timer(const Duration(milliseconds: 2000), () => reloadPage());
    } catch (e) {
      showRiveAnimationDialog('assets/error.riv', false, "$e");
      await PageError.handleError(e, StackTrace.current);
    }
  }

  void shareBook(String isbn) {
    // Implémentez la logique pour partager le livre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du livre'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          fetchBookDetails(isbn),
          isInCollection(isbn, 'standard'),
          isInCollection(isbn, 'wishlist'),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final book = snapshot.data![0];
            final inLibrary = snapshot.data![1];
            final inWishlist = snapshot.data![2];

            return Center(
              child: Column(
                children: [
                  if (book['url_img'] != null)
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.network(book['url_img']),
                    ),
                  if (book['url_img'] == null)
                    const Icon(Icons.book, size: 100),
                  if (book['title'] != null)
                    SizedBox(
                      width: 400,
                      child: Text(
                        book['title'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (book['author'] != null) Text(book['author']),
                  if (book['description'] != null) Text(book['description']),
                  _buildActionButtons(inLibrary, inWishlist),
                ],
              ),
            );
          }
          return const Center(child: Text('Aucune donnée'));
        },
      ),
    );
  }

  Widget _buildActionButtons(bool inLibrary, bool inWishlist) {
    List<Widget> buttons = [];

    if (!inLibrary) {
      buttons.add(ElevatedButton(
        onPressed: () => toggleCollection(isbn, 'standard', true),
        child: const Text('Ajouter à la bibliothèque'),
      ));
    }
    if (inLibrary) {
      buttons.addAll([
        ElevatedButton(
          onPressed: () => shareBook(isbn),
          child: const Text('Partager'),
        ),
        ElevatedButton(
          onPressed: () => toggleCollection(isbn, 'standard', false),
          child: const Text('Retirer de la bibliothèque'),
        ),
      ]);
    }
    if (!inWishlist && !inLibrary) {
      buttons.add(ElevatedButton(
        onPressed: () => toggleCollection(isbn, 'wishlist', true),
        child: const Text('Ajouter à la wishlist'),
      ));
    }
    if (inWishlist) {
      buttons.add(ElevatedButton(
        onPressed: () => toggleCollection(isbn, 'wishlist', false),
        child: const Text('Retirer de la wishlist'),
      ));
    }

    return Column(children: buttons);
  }
}
