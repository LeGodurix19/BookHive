import 'package:flutter/material.dart';
import 'package:betta/Book/page.BookDetails.dart';
import 'package:betta/Feed/page.Feed.dart';
import 'package:betta/Profil/page.ProfilParametres.dart';
import 'package:betta/Errors/page.errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betta/main.dart'; // Assurez-vous d'importer main.dart pour accéder à navigatorKey
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import des localisations
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowers.dart';
import 'package:betta/Profil/pagesIn.ManageRelations/page.ManageFollowings.dart';

class Books {
  final String title;
  final String urlImg;
  final String isbn;
  final int status;

  Books(this.title, this.urlImg, this.isbn, this.status);
}

class ProfilPage extends StatefulWidget {
  final String? uid;

  const ProfilPage({super.key, this.uid});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool showPosts = true;
  String? urlPic;
  String? uid;
  bool isFriend = false;
  bool isMe = false;
  bool isLoading = true;
  String? userName;
  int totalBooks = 0;
  int followersCount = 0;
  int followingsCount = 0;
  bool isBlocked = false;

  @override
  void initState() {
    super.initState();
    uid = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    isMe = uid == FirebaseAuth.instance.currentUser!.uid;
    _fetchProfile();
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _fetchProfile() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(uid);
      final userSnapshot = await userDoc.get();
      final booksSnapshot = await userDoc.collection('shelves').doc("standard").get();
      final followersSnapshot = await userDoc.collection('followers').get();
      final followingsSnapshot = await userDoc.collection('following').get();

      if (!isMe) {
        final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
        final blockeds = await userDoc.collection('blocked').get();
        final blockedBy = await FirebaseFirestore.instance.collection('Users').doc(currentUserUid).collection('blocked').get();
        if (blockeds.docs.any((doc) => doc.id == currentUserUid) || blockedBy.docs.any((doc) => doc.id == uid)) {
          isBlocked = true;
          isFriend = false;
        } else {
          isFriend = followersSnapshot.docs.any((doc) => doc.id == FirebaseAuth.instance.currentUser!.uid);
        }
      }

      setState(() {
        urlPic = userSnapshot["Picture"];
        userName = userSnapshot["username"];
        totalBooks = booksSnapshot.data()?.length ?? 0;
        followersCount = followersSnapshot.docs.length;
        followingsCount = followingsSnapshot.docs.length;
        isLoading = false;
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          if (isMe)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (context) => const ProfilParametresPage()),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildToggleButtons(),
          Expanded(child: showPosts ? buildPosts() : buildLibrary()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildProfileImage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(),
                  const SizedBox(height: 8),
                  _buildStatistics(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: urlPic != null && urlPic!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(urlPic!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: urlPic == null || urlPic!.isEmpty
          ? const Icon(Icons.account_circle, size: 100)
          : null,
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Text(
          userName ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        if (!isMe)
          IconButton(
            icon: Icon(isBlocked ? Icons.block : (isFriend ? Icons.person_remove : Icons.person_add)),
            onPressed: toggleFriendStatus,
            tooltip: isFriend ? AppLocalizations.of(context)!.remove_friend : AppLocalizations.of(context)!.add_friend,
          ),
        if (isMe)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              navigatorKey.currentState!.pop();
            },
            tooltip: AppLocalizations.of(context)!.logout,
          ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatisticItem('$totalBooks', AppLocalizations.of(context)!.books),
        if (!isMe) 
          GestureDetector(
            onTap: () {
                _navigateTo(context, ManageFollowersPage(userId: uid));
            },
            child: _buildStatisticItem('$followingsCount', AppLocalizations.of(context)!.followings),
          ),
        if (!isMe)
          GestureDetector(
            onTap: () {
                _navigateTo(context, ManageFollowingsPage(userId: uid));
            },
            child: _buildStatisticItem('$followersCount', AppLocalizations.of(context)!.followers),
          ),
        if (isMe)
          _buildStatisticItem('$followingsCount', AppLocalizations.of(context)!.followings),
        if (isMe)
          _buildStatisticItem('$followersCount', AppLocalizations.of(context)!.followers),

      ],
    );
  }

  Widget _buildStatisticItem(String count, String label) {
    return Column(
      children: [
        Center(child: Text(count)),
        Text(label),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => showPosts = true),
          child: Text(AppLocalizations.of(context)!.posts),
        ),
        ElevatedButton(
          onPressed: () => setState(() => showPosts = false),
          child: Text(AppLocalizations.of(context)!.library),
        ),
      ],
    );
  }

  void toggleFriendStatus() async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(uid);

      final followersCollection = userDoc.collection('followers');
      final followingCollection = FirebaseFirestore.instance.collection('Users').doc(currentUserUid).collection('following');

      if (isFriend) {
        await followersCollection.doc(currentUserUid).delete();
        await followingCollection.doc(uid).delete();
      } else {
        await followersCollection.doc(currentUserUid).set({});
        await followingCollection.doc(uid).set({});
      }

      setState(() {
        followersCount += isFriend ? -1 : 1;
        isFriend = !isFriend;
      });
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
    }
  }

  Widget buildPosts() {
    return FeedPage(uid: uid!);
  }

  Widget buildLibrary() {
    return StreamBuilder<List<Books>>(
      stream: getUserBooksStream(uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.no_books_found)); // Utiliser les localisations
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.75,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return InkWell(
                onTap: () => navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (context) => BookDetailsPage(isbn: book.isbn)),
                ),
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
                      top: 8,
                      right: 8,
                      child: _buildBookStatusIcon(book.status),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookStatusIcon(int status) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: status == 0
            ? const Color.fromARGB(200, 205, 205, 205)
            : status == 1
                ? const Color.fromARGB(200, 255, 153, 0)
                : const Color.fromARGB(200, 76, 175, 79),
        shape: BoxShape.circle,
      ),
      child: status != 0
          ? Icon(
              status == 1 ? Icons.loop : Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }

  Stream<List<Books>> getUserBooksStream(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('shelves')
        .doc('standard')
        .snapshots()
        .asyncMap((snapshot) async {
      try {
        final booksData = snapshot.data() ?? {};
        final List<Books> booksList = [];

        for (var entry in booksData.entries) {
          final bookDoc = await FirebaseFirestore.instance.collection('Books').doc(entry.key).get();
          if (bookDoc.exists) {
            booksList.add(Books(
              bookDoc['title'],
              bookDoc['url_img'],
              bookDoc['isbn'],
              entry.value['status'],
            ));
          }
        }

        return booksList;
      } catch (e) {
        await PageError.handleError(e, StackTrace.current);
        return [];
      }
    });
  }
}
