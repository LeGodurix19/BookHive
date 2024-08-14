import 'package:betta/Errors/page.errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Stream<bool> emailUpdates() {
    return _auth.userChanges().map((user) => user!.emailVerified);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        // Déconnecter l'utilisateur si l'email n'est pas vérifié
        await signOut();

        // Informer l'utilisateur de vérifier son email
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Veuillez vérifier votre email pour continuer.',
        );
      }
    } on FirebaseAuthException {
      rethrow;
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

      User? user = userCredential.user;

      if (user != null) {
        // Envoyer un email de vérification
        await user.sendEmailVerification();

        // Initialiser les données utilisateur
        await _initializeUserData(user.uid, email);
      }
    } on FirebaseAuthException {
      rethrow;
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
