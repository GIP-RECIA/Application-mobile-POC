import 'package:flutter/material.dart';

/// In this version, the logic of the search bar is implemented on every page in the search bar - non-functional

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomSearchAppBar({super.key});

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
  _CustomSearchAppBarState()._calculatePreferredSize(),
  );
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> with AutomaticKeepAliveClientMixin{
  bool _showSearchBar;
  final List<String> _allItems = ['Apple', 'Banana', 'Orange', 'Mango', 'Peach', 'Grape'];
  List<String> _filteredItems = [];


  _CustomSearchAppBarState() : _showSearchBar = true {
    print("build search bar class");
    //this._showSearchBar = true;
  }

  double _calculatePreferredSize() {
    // Calculer la taille en fonction de l'état actuel
    //super.build(context);
    double listViewHeight = _filteredItems.isNotEmpty ? 150.0 : 150.0;
    print("=== start calculate preferred size ===");
    print("filtered items is not empty : ${_filteredItems.isNotEmpty}");
    print("show search bar : $_showSearchBar");
    print("toolbar height : $kToolbarHeight");
    print("=== end calculate preferred size ===");
    return _showSearchBar ? kToolbarHeight + listViewHeight :
    kToolbarHeight;
  }

  void _filterSearchResults(String query) {
    List<String> results = [];
    if(query.isNotEmpty){
      results = _allItems.where((item) =>
          item.toLowerCase().contains(query.toLowerCase())).toList();
    }
    setState(() {
      _filteredItems = results;
    });
    print(_filteredItems.isNotEmpty);
    _calculatePreferredSize();
  }

  void _toggleSearchBar() {
    print("toggle search bar state");
    setState(() {
      print("in set state : $_showSearchBar");
      _showSearchBar = !_showSearchBar;
      print("in set state 2 : $_showSearchBar");
      if (!_showSearchBar) {
        _filteredItems.clear();
      }
    });
    print("after set state : $_showSearchBar");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
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
              onPressed: _toggleSearchBar,
            ),
          ],
        ),
        if (_filteredItems.isNotEmpty)
          Container(
            height: 150.0,
            color: Colors.amber, // Couleur de fond pour la liste
            child: _buildSearchResultsListView(),
          ),
      ],
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

  @override
  bool get wantKeepAlive => true;
}
