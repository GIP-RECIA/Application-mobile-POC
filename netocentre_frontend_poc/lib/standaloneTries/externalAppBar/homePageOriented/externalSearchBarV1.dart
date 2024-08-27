import 'package:flutter/material.dart';

/// In this version, the logic of the search bar is implemented on every page with a search bar

class CustomSearchAppBar extends StatefulWidget implements
    PreferredSizeWidget {
  final bool showSearchBar;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCloseSearch;
  final List<String> filteredItems;

  CustomSearchAppBar({
    required this.showSearchBar,
    required this.onSearchChanged,
    required this.onCloseSearch,
    required this.filteredItems,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
  showSearchBar ? kToolbarHeight + (filteredItems.isNotEmpty ? 200.0
      : 0.0) : kToolbarHeight,
  );
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: widget.showSearchBar
              ? TextField(
            decoration: const InputDecoration(
              hintText: 'Recherche...',
            ),
            onChanged: widget.onSearchChanged,
          )
              : const Text('Mon Application'),
          actions: [
            IconButton(
              icon: Icon(widget.showSearchBar ? Icons.close : Icons.search),
              onPressed: widget.onCloseSearch,
            ),
          ],
        ),
        if (widget.filteredItems.isNotEmpty) _buildSearchResultsListView(),
      ],
    );
  }

  Widget _buildSearchResultsListView() {
    return Container(
      color: Colors.white, // Ajoute une couleur de fond pour la liste
      height: 200.0, // Hauteur de la liste de résultats
      child: ListView.builder(
        itemCount: widget.filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.filteredItems[index]),
            onTap: () {
              print("Item sélectionné: ${widget.filteredItems[index]}");
            },
          );
        },
      ),
    );
  }
}