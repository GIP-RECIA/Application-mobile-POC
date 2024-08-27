import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
  State<MyHomePage> createState() =>_MyHomePageState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_showSearchBar ? kToolbarHeight +
            (_filteredItems.isNotEmpty ? 180.0 : 0.0) : kToolbarHeight),
        child: Column(
          children: [
            AppBar(
              title: _showSearchBar
                  ? TextField(
                      decoration: const InputDecoration(
                        hintText: 'Recherche...',
                      ),
                      onChanged: _filterSearchResults,
                    )
                  : const Text('Mon Application'),
              actions: [
                IconButton(
                  icon: Icon(_showSearchBar ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                      if (!_showSearchBar) {
                        _filteredItems.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            if (_filteredItems.isNotEmpty) _buildSearchResultsListView(),
          ],
        ),
      ),
      body: const Center(child: Text('Contenu principal')),
    );
  }

  Widget _buildSearchResultsListView() {
    return Container(
      color: Colors.white, // Ajoute une couleur de fond pour la liste
      height: 180.0, // Hauteur de la liste de résultats
      child: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final String item = _filteredItems[index];

          return ListTile(
            title: Text(item),
            onTap: () {
              print("$item selected");
            },
          );
        },
      ),
    );
  }
}