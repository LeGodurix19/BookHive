// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:betta/Errors/page.errors.dart';
import 'package:betta/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart' as rive;

bool isISBN13(String isbn) {
  if (isbn.length != 13 || (!isbn.startsWith('978') && !isbn.startsWith('979'))) return false;

  int sum = 0;
  for (int i = 0; i < 12; i++) {
    sum += int.parse(isbn[i]) * (i.isEven ? 1 : 3);
  }

  int checkDigit = 10 - (sum % 10);
  return checkDigit == int.parse(isbn[12]);
}

void showRiveAnimationDialog(String animation, bool isLooping, [String? message]) {
  BuildContext context = navigatorKey.currentContext!;
  List<Widget> contentChild = [
    SizedBox(
      width: 200,
      height: 200,
      child: rive.RiveAnimation.asset(
        animation,
        fit: BoxFit.contain,
      ),
    ),
  ];

  if (message != null) {
    contentChild.addAll([
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ]);
  }

  showDialog(
    context: context,
    builder: (BuildContext buildContext) {
      if (!isLooping) {
        Timer(const Duration(milliseconds: 1500), () {
          if (Navigator.of(buildContext).canPop()) Navigator.of(buildContext).pop();
        });
      }
      return AlertDialog(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contentChild,
        ),
      );
    },
  );
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<Map<String, dynamic>> scannedBooks = [];
  List<String> scannedIsbns = [];
  QRViewController? controller;
  List<dynamic> books = [];
  bool showCam = true;
  final TextEditingController textEditingController = TextEditingController();

  Future<void> researchTitles(BuildContext context) async {
    try {
      String title = textEditingController.text;
      final Uri apiUri = Uri.parse('https://api.book-hive.com/search_title/');
      showRiveAnimationDialog('assets/dots_loading.riv', true);

      final response = await http.post(
        apiUri,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          'title': title,
        }),
      );

      if (mounted) Navigator.of(navigatorKey.currentContext!).pop();

      if (response.statusCode == 200 && mounted) {
        setState(() {
          showCam = false;
          books = jsonDecode(response.body)['books'];
        });
      } else {
        showRiveAnimationDialog('assets/error.riv', false, jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
    }
  }

  Future<void> sendBooksToApi(BuildContext context) async {
    try {
      final Uri apiUri = Uri.parse('https://api.book-hive.com/all_books/');
      showRiveAnimationDialog('assets/send.riv', true);

      final response = await http.post(
        apiUri,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'books': scannedBooks,
        }),
      );

      if (mounted) Navigator.of(navigatorKey.currentContext!).pop();

      if (response.statusCode == 200 && mounted) {
        setState(() {
          scannedBooks.clear();
          scannedIsbns.clear();
        });
        showRiveAnimationDialog('assets/validate.riv', false);
      } else {
        showRiveAnimationDialog('assets/error.riv', false, jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await PageError.handleError(e, StackTrace.current);
    }
  }

  void showStatusDialog(BuildContext context, int bookIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectReadingStatus),
          content: DropdownButton<int>(
            value: scannedBooks[bookIndex]['status'],
            items: <int>[0, 1, 2].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value == 0 ? AppLocalizations.of(context)!.toRead : value == 1 ? AppLocalizations.of(context)!.reading : AppLocalizations.of(context)!.finished),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                scannedBooks[bookIndex]['status'] = newValue;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code == null || scannedIsbns.contains(scanData.code!)) return;

      setState(() {
        scannedIsbns.add(scanData.code!);
      });

      if (!isISBN13(scanData.code!)) {
        showRiveAnimationDialog("assets/error.riv", true, AppLocalizations.of(context)!.errorNotValidISBN);
        Timer(const Duration(milliseconds: 2000), () {
          if (Navigator.of(navigatorKey.currentContext!).canPop()) Navigator.of(navigatorKey.currentContext!).pop();
        });
        return;
      }

      showRiveAnimationDialog('assets/dots_loading.riv', true);

      try {
        final response = await http.post(
          Uri.parse('https://api.book-hive.com/get_book/'),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, String>{
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'isbn': scanData.code!,
          }),
        );

        if (mounted) Navigator.of(navigatorKey.currentContext!).pop();

        if (response.statusCode == 200 && mounted) {
          setState(() {
            scannedBooks.add(jsonDecode(response.body));
          });
          showRiveAnimationDialog('assets/validate.riv', false);
        } else {
          showRiveAnimationDialog('assets/error.riv', false, jsonDecode(response.body)['error']);
        }
      } catch (e) {
        await PageError.handleError(e, StackTrace.current);
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              if (showCam)
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              if (!showCam)
                Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.searchResults,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close), // Close icon
                        onPressed: () {
                          setState(() {
                            books.clear();
                            showCam = true;
                            textEditingController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              if (!showCam)
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.all(4),
                        child: ListTile(
                          leading: Image.network(
                            books[index]['url_img'],
                            fit: BoxFit.cover,
                          ),
                          title: Text(books[index]['title']),
                          subtitle: Text(books[index]['author']),
                          onTap: () {
                            setState(() {
                              // Assume books[index] is a Map<String, dynamic>
                              final bookWithStatus = Map<String, dynamic>.from(books[index]);
                              bookWithStatus['status'] = 0;
                              
                              scannedBooks.add(bookWithStatus);

                              books.clear();
                              showCam = true;
                              textEditingController.clear();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scannedBooks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showStatusDialog(context, index),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          scannedBooks[index]['url_img'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          if (showCam)
            Positioned(
              top: 50, // Adjust the position as needed
              left: 20,
              right: 20,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterText,
                  filled: true,
                  fillColor: Colors.white.withAlpha(235),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => researchTitles(context),
                  ),
                ),
                onSubmitted: (value) => researchTitles(context),
              ),
            ),
          Positioned(
            bottom: 120,
            right: 0,
            child: FloatingActionButton(
              onPressed: () => sendBooksToApi(context),
              backgroundColor: Colors.white.withAlpha(235),
              elevation: 0, // Remove shadow
              child: const Icon(Icons.arrow_forward, color: Colors.green), // Arrow icon with color
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
