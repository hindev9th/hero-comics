import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/sqflite/sqflite.dart';
import 'package:test_app/widgets/bottom_navigation.dart';

Future<void> main() async {
  await dotenv.load();
  await DbHelper().initDB();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: clPrimary),
        useMaterial3: true,
      ),
      home: const BottomNavigation(),
    );
  }
}
