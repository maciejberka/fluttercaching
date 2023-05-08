import 'package:flutter/material.dart';
import 'package:fluttercaching/hive/hive_manager.dart';
import 'package:fluttercaching/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveManager.init();

  runApp(const FCApp());
}

class FCApp extends StatelessWidget {
  const FCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter caching',
      home: HomeScreen(),
    );
  }
}
