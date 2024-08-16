import 'package:betta/Profil/page.MyProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:betta/Errors/page.errors.dart';
import 'package:betta/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class ManageBlockedPage extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  ManageBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageBlockedUsers), // Utilisation de la localisation
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('blocked')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noBlockedUsers)); // Utilisation de la localisation
          }

          final blockedUsers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final blockedUser = blockedUsers[index];
              final blockedUserId = blockedUser.id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(blockedUserId)
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId)
                              .collection('blocked')
                              .doc(blockedUserId)
                              .delete();

                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(blockedUserId)
                              .collection('blockedBy')
                              .doc(userId)
                              .delete();
                        } catch (e) {
                          await PageError.handleError(e, StackTrace.current);
                          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.errorDeleting)), // Utilisation de la localisation
                          );
                        }
                      },
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
