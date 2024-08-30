import 'package:flutter/material.dart';

/// In this version, the logic of the search bar is implemented in an intermediate class

/// Intermediate class
class ScaffoldwithIntegratedSearchBar extends StatefulWidget {
  final Widget child; // Le contenu principal de la page

  const ScaffoldwithIntegratedSearchBar({super.key, required this.child});

  @override
  State<ScaffoldwithIntegratedSearchBar> createState() => _ScaffoldwithIntegratedSearchBarState();
}

class _ScaffoldwithIntegratedSearchBarState extends State<ScaffoldwithIntegratedSearchBar> {
  bool _showSearchBar = false;
  final List<String> _allItems = ['Apple', 'Banana', 'Orange', 'Mango', 'Peach', 'Grape'];
  List<String> _filteredItems = [];

  void _filterSearchResults(String query) {
    setState(() {
      _filteredItems = _allItems.where((item) =>
          item.toLowerCase().contains(query.toLowerCase())).toList();
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
        toggleSearchBar: _toggleSearchBar,
        onSearch: _filterSearchResults,
        filteredItems: _filteredItems,
      ),
      body: Stack(
        children: [
          widget.child,
          if (_showSearchBar && _filteredItems.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: (_filteredItems.length < 3 ? _filteredItems.length : 3) * 60.0, // Multiple de 60 - max 180 pour 3 affichés en simultané
                color: Colors.blueAccent, // Couleur de fond pour la liste
                child: _buildSearchResultsListView(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsListView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_filteredItems[index]),
          onTap: () {
            print("Item sélectionné: ${_filteredItems[index]}");
          },
        );
      },
    );
  }
}

class CustomSearchAppBar extends StatelessWidget implements
    PreferredSizeWidget {
  final bool showSearchBar;
  final VoidCallback toggleSearchBar;
  final Function(String) onSearch;
  final List<String> filteredItems;

  const CustomSearchAppBar({super.key,
    required this.showSearchBar,
    required this.toggleSearchBar,
    required this.onSearch,
    required this.filteredItems,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: showSearchBar
          ? TextField(
        decoration: const InputDecoration(
          hintText: 'Recherche...',
        ),
        onChanged: onSearch,
      )
          : const Text('Mon Application'),
      actions: [
        IconButton(
          icon: Icon(showSearchBar ? Icons.close : Icons.search),
          onPressed: toggleSearchBar,
        ),
      ],
    );
  }
}