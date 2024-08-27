import 'package:flutter/material.dart';

import '../pages/homePage.dart';
import '../pages/servicesPage.dart';

/// Flutter code sample for [MenuAnchor].

void main() => runApp(const MenuApp());

/// An enhanced enum to define the available menus and their shortcuts.
///
/// Using an enum for menu definition is not required, but this illustrates how
/// they could be used for simple menu systems.
enum MenuEntry {
  about('About'),
  showMessage('Show Message'),
  hideMessage('Hide Message'),
  colorMenu('Color Menu'),
  colorRed('Red Background'),
  colorGreen('Green Background'),
  colorBlue('Blue Background');

  const MenuEntry(this.label, [this.nb]);
  final String label;
  final int? nb;
}

class MyCascadingMenu extends StatefulWidget {
  const MyCascadingMenu({super.key, required this.message});

  final String message;

  @override
  State<MyCascadingMenu> createState() => _MyCascadingMenuState();
}

class _MyCascadingMenuState extends State<MyCascadingMenu> {
  MenuEntry? _lastSelection;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor = Colors.red;
  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      setState(() {
        _backgroundColor = value;
      });
    }
  }

  bool get showingMessage => _showingMessage;
  bool _showingMessage = false;
  set showingMessage(bool value) {
    if (_showingMessage != value) {
      setState(() {
        _showingMessage = value;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    showingMessage ? widget.message : '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Text(_lastSelection != null
                    ? 'Last Selected: ${_lastSelection!.label}'
                    : ''),
              ],
            ),
          ),
        ),
        MenuAnchor(
          childFocusNode: _buttonFocusNode,
          menuChildren: <Widget>[
            MenuItemButton(
              child: Text(MenuEntry.about.label),
              onPressed: () => _activate(MenuEntry.about),
            ),
            if (_showingMessage)
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.hideMessage),
                child: Text(MenuEntry.hideMessage.label),
              ),
            if (!_showingMessage)
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.showMessage),
                child: Text(MenuEntry.showMessage.label),
              ),
          ],
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.07,
              color: const Color(0xFF2c2c2c),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("home");
                      // Naviguer vers la page de commandes reçues
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.grid_view,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("Services list");
                      // Naviguer vers la page des commandes en cours
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ServicesPage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("user");
                      // Naviguer vers la page de l'historique des commandes
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  ),
                  TextButton(
                    focusNode: _buttonFocusNode,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: const Text('OPEN MENU'),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _activate(MenuEntry selection) {
    setState(() {
      _lastSelection = selection;
    });

    switch (selection) {
      case MenuEntry.about:
        showAboutDialog(
          context: context,
          applicationName: 'MenuBar Sample',
          applicationVersion: '1.0.0',
        );
      case MenuEntry.hideMessage:
      case MenuEntry.showMessage:
        showingMessage = !showingMessage;
      case MenuEntry.colorMenu:
        break;
      case MenuEntry.colorRed:
        backgroundColor = Colors.red;
      case MenuEntry.colorGreen:
        backgroundColor = Colors.green;
      case MenuEntry.colorBlue:
        backgroundColor = Colors.blue;
    }
  }
}

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
          body: SafeArea(child: MyCascadingMenu(message: '"Talk less. Smile more." - A. Burr'))),
    );
  }
}