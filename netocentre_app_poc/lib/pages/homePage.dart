import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netocentre_app_poc/entities/service.dart';
import 'package:netocentre_app_poc/pages/components/expansionTile.dart';
import 'package:netocentre_app_poc/pages/components/myAppBar.dart';
import 'package:netocentre_app_poc/pages/components/navBar.dart';
import 'package:netocentre_app_poc/pages/components/newsCard.dart';
import 'package:netocentre_app_poc/pages/components/servicesCard.dart';
import 'package:netocentre_app_poc/pages/loadingPage.dart';
import 'package:netocentre_app_poc/pages/servicesPage.dart';
import 'package:netocentre_app_poc/services/portalService.dart';
import 'package:netocentre_app_poc/singletons/mediacentreFavorites.dart';
import 'package:netocentre_app_poc/singletons/userInfo.dart';

import '../singletons/servicesList.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  static const String title = 'Une actualité concernant des évènements actuels';
  static const String type = 'Établissement';
  static const String desc = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  List<Service> renderedServices = Services().servicesList;
  List<Service> renderedFavoriteServices = Services().favoritesList;

  void _switchPortletIsFavoriteState(int index) async {
    bool isTaskValidated = await PortalService().switchPortletIsFavoriteState(renderedServices[index]);

    if (isTaskValidated){
      final Service currService = renderedServices[index];
      setState(() {
        renderedServices[index] = currService;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // if(ServicesList().list.isEmpty){
    //   print("services list was empty");
    //   ServicesList().list.add(Service.CASBased(text: "Espaces Moodle", serviceUri: "https://e-education.recia.fr/moodle", fname: "Moodle", iconUri: "", isFavorite: false));
    //   ServicesList().list.add(Service.UPortalBased(text: "MenuCantine", serviceUri: "MenuCantine.ctf2/max/render.uP", iconUri: "", isFavorite: false));
    //   ServicesList().list.add(Service.UPortalBased(text: "ESUP FileManager", serviceUri: "esup-filemanager", iconUri: "", isFavorite: false));
    //   ServicesList().list.add(Service.UPortalBased(text: "Mediacentre", serviceUri: "Mediacentre", iconUri: "", isFavorite: false));
    //   ServicesList().list.add(Service.UPortalBased(text: "ESUP Pod", serviceUri: "ESUPpod", iconUri: "", isFavorite: false));
    // }

    //PortalService().loadUserInfo();
    //PortalService().getAllPortlets();

    if(UserInfo().firstname == ""){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoadingPage(callbackWidget: HomePage())));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar: const MyAppBar('Lycée fictif',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Bienvenue sur votre ENT, ${UserInfo().firstname}",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const MyExpansionTile("Espace vie scolaire", nbNotifications: 6, dataset: [
              (name: "notification 1", url: null),
              (name: "notification 2", url: null),
              (name: "notification 3", url: null),
              (name: "notification 4", url: null),
              (name: "notification 5", url: null),
            ],),
            MyExpansionTile(
              "Favoris",
              dataset: Services().favoritesList.map( (fav) => (
                name: fav.text,
                url: null
              )).toList()
            ),
            MyExpansionTile("Médiacentre", subtitle: "Favoris",
              dataset: MediacentreFavorites().favorites.map( (fav) => (
                name: fav,
                url: null
              )).toList()
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Actualités",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const NewsCard(title, type, desc),
            const NewsCard(title, type, desc),
            const NewsCard(title, type, desc),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clicked on Toutes les actualités'))
                );
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "voir toutes les actualités",
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Services",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                child:
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: (1 / 1.15),
                  ),
                  itemCount: renderedServices.length,
                  itemBuilder: (context, index) {
                    final Service service = renderedServices[index];
                    return ServicesCard(service, onPressed: () => _switchPortletIsFavoriteState(index));
                  },
                )
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clicked on Tous les services'))
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ServicesPage()));
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "voir tous les services",
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

}