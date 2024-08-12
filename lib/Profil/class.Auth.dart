import 'package:betta/Errors/page.errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? uid = userCredential.user?.uid;
      if (uid != null) {
        await _initializeUserData(uid, email);
      }
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> _initializeUserData(String uid, String email) async {
    // Créer le document utilisateur avec les champs de base
    await _firestore.collection('Users').doc(uid).set({
      'username': "User tmp",
      'Email': email,
      'Picture': "",
      'Uid': uid,
    });

    // Créer les sous-collections et documents nécessaires
    final userRef = _firestore.collection('users').doc(uid).collection('shelves');
    await userRef.doc('standard').set({});
    await userRef.doc('wishlist').set({});
    await _firestore.collection('users').doc(uid).collection('followers').doc(uid).set({});
    await _firestore.collection('users').doc(uid).collection('following').doc(uid).set({});
    await _firestore.collection('users').doc(uid).collection('blocked').doc(uid).set({});
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _handleError(Object error) async {
    await PageError.handleError(error, StackTrace.current);
  }
}
