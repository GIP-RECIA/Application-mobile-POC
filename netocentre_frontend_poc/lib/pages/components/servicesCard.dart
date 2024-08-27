import 'package:flutter/material.dart';

class ServicesCard extends StatelessWidget{

  final int index;

  final bool isFavorite = true;
  final bool isNew = true;

  const ServicesCard(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 18,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                color: Color(0xFFAD0780)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            LogoRow(false, isFavorite),
            const SizedBox(
              height: 2,
            ),
            Text(
                "Type Service",
              style: TextStyle(
               color: Colors.grey.shade500,
              ),
            ),
            const Text(
                "Nom Service",
              style: TextStyle(
               fontWeight: FontWeight.w700,
               color: Colors.black
              ),
            ),
            TextButton(
              onPressed: () => print("click on En savoir plus"),
              child: const Text(
                  "En savoir plus",
                style: TextStyle(
                 fontWeight: FontWeight.w700,
                 color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoRow extends StatelessWidget{

  final bool isNew;
  final bool isFavorite;


  const LogoRow(this.isNew, this.isFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isNew) Positioned(
          left: 5,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFFad1919),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: const Text(
              "Nouveau",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.camera_outlined,
            size: 60.0,
            color: Colors.grey.shade500,
          ),
        ),
        if (isFavorite) const Positioned(
          right: 5,
          child: Icon(
            Icons.star_rounded,
            color: Color(0xFFF1C903),
            size: 32.0,
          ),
        ) else Positioned(
          right: 5,
          child: Icon(
            Icons.star_border_rounded,
            color: Colors.grey.shade600,
            size: 32.0,
          ),
        )
      ],
    );
  }
}