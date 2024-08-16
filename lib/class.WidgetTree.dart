import 'package:betta/Profil/page.Login.dart';
import 'package:betta/Profil/page.ProfilCustom.dart';
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
      builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          print(snapshot.data![0]);
          print(snapshot.data![1]);
          if (snapshot.data![0] && snapshot.data![1] == false) {
            return const HomePage();
          }
          else if (snapshot.data![0] && snapshot.data![1]) {
            return const ProfilCustom();
          }
        }
        return const LoginPage();
      },
    );
  }
}