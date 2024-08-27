import 'package:flutter/material.dart';
import 'externalSearchBarV3.dart';

/// In this version, the logic of the search bar is implemented in an intermediate class

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
    return ScaffoldwithIntegratedSearchBar(
        child: Container(
          color: Colors.red,
          child: Center(
              child: Text('Contenu principal')
          ),
        )
    );
  }
}
