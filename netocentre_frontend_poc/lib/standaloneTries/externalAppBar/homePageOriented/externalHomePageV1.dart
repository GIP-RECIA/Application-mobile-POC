import 'package:flutter/material.dart';
import 'externalSearchBarV1.dart';

/// In this version, the logic of the search bar is implemented on every page with a search bar

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
  bool _showSearchBar = false;
  final List<String> _allItems = ['Apple', 'Banana', 'Orange', 'Mango', 'Peach', 'Grape'];
  List<String> _filteredItems = [];

  void _filterSearchResults(String query) {
    List<String> results = [];
    if (query.isNotEmpty) {
      results = _allItems.where((item) =>
          item.toLowerCase().contains(query.toLowerCase())).toList();
    }
    setState(() {
    _filteredItems = results;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _filteredItems.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchAppBar(
        showSearchBar: _showSearchBar,
        onSearchChanged: _filterSearchResults,
        onCloseSearch: _toggleSearchBar,
        filteredItems: _filteredItems,
      ),
      body: const Center(child: Text('Contenu principal')),
    );
  }
}
