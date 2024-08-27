import 'package:flutter/material.dart';
import 'package:netocentre_frontend_poc/pages/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Netocentre Frontend POC',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
