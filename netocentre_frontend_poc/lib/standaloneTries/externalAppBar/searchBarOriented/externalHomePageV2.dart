import 'package:flutter/material.dart';
import 'externalSearchBarV2.dart';

/// In this version, the logic of the search bar is implemented on every page in the search bar - non-functional

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomSearchAppBar(),
      body: Center(child: Text('Contenu principal')),
    );
  }
}