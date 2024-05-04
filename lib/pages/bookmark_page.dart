import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/login_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => LoginPage(),
            ));
      },
      child: Text("Login"),
    ));
  }
}
