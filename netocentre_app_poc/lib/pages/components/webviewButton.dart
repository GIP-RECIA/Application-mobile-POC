import 'package:flutter/material.dart';

import '../../services/portalService.dart';
import '../../singletons/tokenManager.dart';
import '../serviceWebviews/casServiceWebview.dart';
import '../serviceWebviews/uPortalServiceWebview.dart';
import '../unconnectedHomePage.dart';


class WebviewButton extends StatelessWidget {
  final String text;
  final String serviceUri;
  late final String fname;
  late final bool isAuthByUPortal;

  WebviewButton.forUPortalService({required this.text, required this.serviceUri,super.key}){
    isAuthByUPortal = true;
    fname = "";
  }

  WebviewButton.forCasService({required this.text, required this.serviceUri, required this.fname, super.key}){
    isAuthByUPortal = false;
  }

  @override
  Widget build(BuildContext context) {
    if(isAuthByUPortal) {
      return ElevatedButton(
          child: Text(text),
          onPressed: () async => {
            if(await PortalService().isAuthorizedByUPortal()){
              if(context.mounted){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UPortalServiceWebview(text: text, uri: serviceUri))),
              }
            }
            else {
              TokenManager().reset(flush: true),
              if(context.mounted){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UnconnectedHomePage())),
                print("Unauthorized - JSESSIONID not got")
              }
            }
          });
    }
    else {
      return ElevatedButton(
        child: Text(text),
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => CASServiceWebview(text: text, uri: serviceUri, fname: fname,))),
      );
    }

  }

}