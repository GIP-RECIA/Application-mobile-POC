import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netocentre_frontend_poc/pages/components/expansionTile.dart';
import 'package:netocentre_frontend_poc/pages/components/myAppBar.dart';
import 'package:netocentre_frontend_poc/pages/components/navBar.dart';

import 'components/servicesCard.dart';

class ServicesPage extends StatelessWidget{
  const ServicesPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar("Lycée fictif"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Tous les services",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            MyExpansionTile("Filtres"),
            Container(
              margin: EdgeInsets.all(18),
              width: MediaQuery.of(context).size.width - 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: const Text(
                      "Trier par : ",
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                  ),
                  DropdownMenu<String>(
                    trailingIcon: const Icon(Icons.keyboard_arrow_down),
                    selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
                    menuStyle: const MenuStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                    ),
                    textStyle: TextStyle(
                      color: Colors.pink,
                    ),
                    onSelected: (value) {
                      print(value);
                    },
                    dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                      DropdownMenuEntry(label: "Popularité", value: "popularite"),
                      DropdownMenuEntry(label: "Plus récents", value: "plus_recents"),
                      DropdownMenuEntry(label: "A-Z", value: "a-z"),
                      DropdownMenuEntry(label: "Z-A", value: "z-a"),
                    ],
                  ),
                ],
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}