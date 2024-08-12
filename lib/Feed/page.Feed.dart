import 'package:betta/Book/page.BookDetails.dart';
import 'package:betta/Errors/page.errors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betta/Profil/page.MyProfil.dart';
import 'package:betta/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation ajoutée

class FeedPage extends StatefulWidget {
  final String? uid;
  const FeedPage({super.key, this.uid = ''});

  @override
  // ignore: library_private_types_in_public_api
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> _getFriendsStream(String uid) {
    return _firestore
        .collection("Users")
        .doc(uid)
        .collection('following')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<QuerySnapshot> _getPostsStream(List<String> friendIds) {
    if (friendIds.isNotEmpty) {
      return _firestore
          .collection('Post')
          .where('uid', whereIn: friendIds)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return const Stream.empty(); // Flux vide si pas d'amis
    }
  }

  Future<Map<String, dynamic>> _fetchPostData(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;

    DocumentSnapshot bookSnapshot = await _firestore.collection('Books').doc(data['isbn']).get();
    DocumentSnapshot userSnapshot = await _firestore.collection('Users').doc(data['uid']).get();

    data['isbn_book'] = bookSnapshot.data() as Map<String, dynamic>;
    data['user'] = userSnapshot.data() as Map<String, dynamic>;

    return data;
  }

  Future<void> _toggleLike(String postId) async {
    try {
      User user = _auth.currentUser!;
      DocumentReference postRef = _firestore.collection('Post').doc(postId);

      DocumentSnapshot postSnapshot = await postRef.get();
      List<dynamic> likes = postSnapshot['likes'] ?? [];

      if (likes.contains(user.uid)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([user.uid]),
        });
      }
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
    }
  }

  Widget _buildPostContent(Map<String, dynamic> post) {
    Widget content;
    String imageUrl = post['isbn_book']['url_img'] ?? '';
    String username = post['user']['username'];
    String title = post['isbn_book']['title'];

    switch (post['status']) {
      case 0: // livre ajouté à la bibliothèque
        content = _buildBookActionContent(username, AppLocalizations.of(context)!.added, title, imageUrl); // Utilisation de la localisation
        break;
      case 1: // livre commencé
        content = _buildBookActionContent(username, AppLocalizations.of(context)!.startedReading, title, imageUrl); // Utilisation de la localisation
        break;
      case 2: // livre fini
        content = _buildBookActionContent(username, AppLocalizations.of(context)!.finishedReading, title, imageUrl); // Utilisation de la localisation
        break;
      default:
        content = Text(AppLocalizations.of(context)!.unknownPostType); // Utilisation de la localisation
    }

    return content;
  }

  Widget _buildBookActionContent(String username, String action, String title, String imageUrl) {
    return Column(
      children: [
        Center(
          child: imageUrl.isEmpty ? const Icon(Icons.book) : Image.network(imageUrl, fit: BoxFit.contain),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(" $action "),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsPage(isbn: title),
                  ),
                );
              },
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var uid = widget.uid == "" ? _auth.currentUser?.uid: widget.uid;

    return Scaffold(
      body: StreamBuilder<List<String>>(
        stream: _getFriendsStream(uid!),
        builder: (context, friendSnapshot) {
          if (friendSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!friendSnapshot.hasData || friendSnapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun ami suivi')); // Utilisation de la localisation
          } else {
            var friendIds = friendSnapshot.data!;

            return StreamBuilder<QuerySnapshot>(
              stream: widget.uid != '' ? _getPostsStream([uid]) : _getPostsStream(friendIds),
              builder: (context, postSnapshot) {
                if (postSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun post')); // Utilisation de la localisation
                } else {
                  var posts = postSnapshot.data!.docs;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var postDoc = posts[index];

                      return FutureBuilder<Map<String, dynamic>>(
                        future: _fetchPostData(postDoc),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          var post = snapshot.data!;
                          var likesCount = (post['likes'] ?? []).length;
                          var commentsCount = (post['comments'] ?? []).length;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(post['user']['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(post['timestamp'].toDate().toString().split(' ')[0]),
                                onTap: () {
                                  Navigator.push(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(builder: (context) => ProfilPage(uid: post['uid'])),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildPostContent(post),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: uid.isNotEmpty &&
                                                  post['likes'] != null &&
                                                  post['likes'].contains(uid)
                                              ? Colors.blue
                                              : null,
                                        ),
                                        onPressed: () => _toggleLike(post['id']),
                                      ),
                                      Text('$likesCount'),
                                      IconButton(
                                        icon: const Icon(Icons.comment),
                                        onPressed: () {},
                                      ),
                                      Text('$commentsCount'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
