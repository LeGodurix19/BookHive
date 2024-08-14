import 'package:betta/Profil/page.Login.dart';
import 'package:flutter/material.dart';

import 'page.Home.dart';
import 'Profil/class.Auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: Auth().emailUpdates(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}