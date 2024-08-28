import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netocentre_app_poc/entities/service.dart';
import 'package:netocentre_app_poc/singletons/baseUrl.dart';

import '../../services/portalService.dart';
import '../serviceWebviews/casServiceWebview.dart';
import '../serviceWebviews/uPortalServiceWebview.dart';

class ServicesCard extends StatelessWidget{

  final Service service;

  final bool isNew = true;

  final VoidCallback? onPressed;

  ServicesCard(this.service, {super.key, required this.onPressed}) {
    print("construct ${this.service.text} card | isFav : ${this.service.isFavorite}");
  }

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
      child: GestureDetector(
        onTapUp: (_) async {
          print(service.text);
          if(service.isAuthByUPortal){
            if(await PortalService().isAuthorizedByUPortal()){
              if(context.mounted){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UPortalServiceWebview(text: service.text, uri: service.serviceUri)));
              }
            }
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CASServiceWebview(text: service.text, uri: service.serviceUri, fname: service.fname!,)));
          }
        },
        child: Center(
          child: Stack(
            children: [
              Column(
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
                  LogoRow(service, onPressed: onPressed,),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                      "Type Service",
                    style: TextStyle(
                     color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    service.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextButton(
                    onPressed: () => print("click on En savoir plus"),
                    child: const Text(
                      "En savoir plus",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogoRow extends StatelessWidget{

  final Service service;

  final VoidCallback? onPressed;

  const LogoRow(this.service, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    print("icon uri : ${service.iconUri}");
    return Stack(
      alignment: Alignment.center,
      children: [
        if (service.isNew) Positioned(
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
          child: SvgPicture.network(
            "https://${BaseUrl().uPortalBaseURL}${service.iconUri}",
            height: 50,
            width: 50,
          ),

        ),
        if (service.isFavorite) Positioned(
          right: 5,
          child: TextButton(
            onPressed: onPressed,
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFFF1C903),
              size: 32.0,
            ),
          )
        ) else Positioned(
          right: 5,
          child: TextButton(
            onPressed: onPressed,
            child: Icon(
              Icons.star_border_rounded,
              color: Colors.grey.shade600,
              size: 32.0,
            ),
          ),
        )
      ],
    );
  }
}