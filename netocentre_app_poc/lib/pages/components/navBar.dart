import 'package:flutter/material.dart';
import 'package:netocentre_app_poc/pages/homePage.dart';
import 'package:netocentre_app_poc/pages/servicesPage.dart';
import 'package:netocentre_app_poc/pages/unconnectedHomePage.dart';
import 'package:netocentre_app_poc/repositories/tokenRepository.dart';
import 'package:netocentre_app_poc/singletons/baseUrl.dart';
import 'package:netocentre_app_poc/singletons/tokenManager.dart';
import 'package:netocentre_app_poc/singletons/userInfo.dart';

import '../../services/portalService.dart';

class NavBar extends StatefulWidget{

  const NavBar({super.key});

  @override
  State<NavBar> createState() => NavBarState();

}

class NavBarState extends State<NavBar> {


  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  String pictureUri = "";


  @override
  void initState() {
    super.initState();

    if(UserInfo().firstname == ""){
      print("USER INFO - On ne devrait jamais être là car normalement déjà chargé");
      PortalService().loadUserInfo();
    }

    pictureUri = "https://${BaseUrl().uPortalBaseURL}${UserInfo().pictureURI}";
    print(pictureUri);
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
      ),
      menuChildren: <Widget>[
        MenuItemButton(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  "Déconnexion",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              Icon(Icons.logout_outlined, color: Colors.red,),
            ],
          ),
          onPressed: () => {
            TokenRepository().deleteAllRows(),
            TokenManager().reset(),
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UnconnectedHomePage() )),
          },
        ),
        MenuItemButton(
          child: const Row(
            children: [
              Text("Lancer le didacticiel"),
              Icon(Icons.play_arrow_outlined),
            ],
          ),
          onPressed: () => {
            print("ouaiiiiiiiiii"),
          },
        ),
        MenuItemButton(
          child: const Row(
            children: [
              Text("Changer d'établissemnet"),
              Icon(Icons.swap_horiz_outlined),
            ],
          ),
          onPressed: () => {},
        ),
        MenuItemButton(
          child: const Row(
            children: [
              Text("Infos de l'établissement"),
              Icon(Icons.info_outline),
            ],
          ),
          onPressed: () => {},
        ),
        MenuItemButton(
          child: const Row(
            children: [
              Text("Mon profil"),
              Icon(Icons.settings),
            ],
          ),
          onPressed: () => {},
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Text("Notifications"),
              Container(
                width: 38,
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: const Center(
                  child: Text("4",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
          onPressed: () => {},
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.grid_view,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("Services list");
                    print("not already on page");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ServicesPage()));
                },
              ),
              IconButton(
                icon: Container(
                  height: 24,
                  width: 24,
                  child: const FittedBox(
                    fit: BoxFit.cover,
                    child: ImageIcon(
                      NetworkImage(
                        "https://lycees.test.recia.dev/images/avatars/gr/1848eefe/avatar0.jpg?34",
                        scale: 1
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  print("user");
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                iconSize: 80,
              ),
            ],
          ),
        );
      },
    );
  }
}