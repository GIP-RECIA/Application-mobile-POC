import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netocentre_frontend_poc/pages/components/expansionTile.dart';
import 'package:netocentre_frontend_poc/pages/components/myAppBar.dart';
import 'package:netocentre_frontend_poc/pages/components/navBar.dart';
import 'package:netocentre_frontend_poc/pages/components/newsCard.dart';
import 'package:netocentre_frontend_poc/pages/components/servicesCard.dart';
import 'package:netocentre_frontend_poc/pages/servicesPage.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  static const String title = 'Une actualité concernant des évènements actuels';
  static const String type = 'Établissement';
  static const String desc = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar:   const MyAppBar("Lycée fictif"),
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
                  "Bienvenue sur votre ENT, {inser_name}",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const MyExpansionTile("Espace vie scolaire", nbNotifications: 6,),
            const MyExpansionTile("Favoris",),
            const MyExpansionTile("Médiacentre", subtitle: "Consultés récemment",),
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
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return ServicesCard(index);
                },
              ),
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