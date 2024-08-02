import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/sqflite/sqflite.dart';
import 'package:test_app/widgets/bottom_navigation.dart';
import 'package:toastification/toastification.dart';
import 'package:dart_json_mapper_flutter/dart_json_mapper_flutter.dart' show flutterAdapter;
import 'package:test_app/models/model.dart';
import 'package:test_app/models/model.mapper.g.dart' show initializeJsonMapper;

Future<void> main() async {
  initializeJsonMapper(adapters: [flutterAdapter]);
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
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: clPrimary),
          useMaterial3: true,
        ),
        home: const BottomNavigation(),
      ),
    );
  }
}
