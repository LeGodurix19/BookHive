import 'package:betta/Profil/page.MyProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:betta/main.dart';
import 'package:betta/Errors/errorsPage.dart';

class ManageFollowersPage extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  ManageFollowersPage({super.key});

  // Fonction pour bloquer un utilisateur
  Future<void> blockedUser(String userId, String followingUserId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('blocked')
          .doc(followingUserId)
          .set({});
      await removedFollowing(userId, followingUserId);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Utilisateur bloqué avec succès')),
      );
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Erreur lors du blocage de l\'utilisateur: $e')),
      );
    }
  }

  // Fonction pour retirer un utilisateur de la liste de suivis
  static Future<void> removedFollowing(String userId, String followingUserId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('followers')
          .doc(followingUserId)
          .delete();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(followingUserId)
          .collection('following')
          .doc(userId)
          .delete();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Utilisateur ne vous suit plus')),
      );
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du suivi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion les followers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('followers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun follower.'));
          }

          final followings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: followings.length,
            itemBuilder: (context, index) {
              final followers = followings[index];
              final followingUserId = followers.id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(followingUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Chargement...'),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text('Utilisateur introuvable'),
                    );
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['username'] ?? 'Nom inconnu';
                  final uidUser = userData['Uid'] ?? '';
                  final userPhoto = userData['Picture'] ?? '';

                  return ListTile(
                    leading: userPhoto.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(userPhoto),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                    title: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilPage(uid: uidUser),
                          ),
                        );
                      },
                      child: Text(userName),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person_remove),
                          onPressed: () async {
                            await removedFollowing(userId!, followingUserId);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.block),
                          onPressed: () {
                            blockedUser(userId!, followingUserId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
