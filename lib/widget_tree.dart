import 'package:grocery_list_app/auth.dart';
import 'package:grocery_list_app/pages/homepage.dart';
import 'package:grocery_list_app/pages/login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext contect) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return const LoginPage();
          }
        });
  }
}
