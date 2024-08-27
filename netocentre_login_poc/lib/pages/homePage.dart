import 'package:flutter/material.dart';
import 'package:netocentre_login_poc/pages/components/externalAppButton.dart';
import 'package:netocentre_login_poc/pages/components/webviewButton.dart';
import 'package:netocentre_login_poc/pages/loadingPage.dart';
import 'package:netocentre_login_poc/pages/loginPage.dart';
import 'package:netocentre_login_poc/pages/serviceWebviews/collabsoftServiceWebview.dart';
import 'package:netocentre_login_poc/pages/syncNeedingPage.dart';
import 'package:netocentre_login_poc/services/loginService.dart';
import 'package:netocentre_login_poc/services/portalService.dart';
import 'package:netocentre_login_poc/singletons/dummySingleton.dart';
import 'package:netocentre_login_poc/singletons/tokenManager.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text("Directly Authenticated by CAS"),
                  WebviewButton.forCasService(text: "Espaces Moodle", serviceUri: "https://e-education.recia.fr/moodle", fname: "Moodle")
                ],
              ),
              Column(
                children: [
                  const Text("Authenticated by uPortal - with JSESSIONID"),
                  WebviewButton.forUPortalService(text: "MenuCantine", serviceUri: "MenuCantine.ctf2/max/render.uP"),
                  WebviewButton.forUPortalService(text: "ESUP FileManager", serviceUri: "esup-filemanager"),
                  WebviewButton.forUPortalService(text: "Mediacentre", serviceUri: "Mediacentre"),
                  WebviewButton.forUPortalService(text: "ESUP Pod", serviceUri: "ESUPpod"),
                ],
              ),
              const Column(
                children: [
                  Text("Service app directly opened"),
                  ExternalAppButton(text: "Pronote", androidPackageName: "com.IndexEducation.Pronote", iosUrlScheme: "pronote://", appStoreLink: "itms-apps://apps.apple.com/fr/app/pronote/id1138223804"),
                  ExternalAppButton(text: "Nextcloud", androidPackageName: "com.nextcloud.client", iosUrlScheme: "nextcloud://", appStoreLink: "itms-apps://apps.apple.com/fr/app/nextcloud/id1125420102"),
                ],
              ),
              Column(
                children: [
                  const Text("Tests"),
                  ElevatedButton(
                      onPressed: () async => await PortalService().getAllPortlets(),
                      child: const Text("Get all portlets")
                  ),
                  ElevatedButton(
                      onPressed: () async => await PortalService().getUserInfo(),
                      child: const Text("Get user info")
                  ),
                  ElevatedButton(
                      onPressed: () async => await LoginService().profile(),
                      child: const Text("Get user profile")
                  ),
                  ElevatedButton(
                      onPressed: () async => await PortalService().isAuthorizedByUPortal(),
                      child: const Text("Generate JSESSIONID")
                  ),
                  ElevatedButton(
                      onPressed: () => print(TokenManager()),
                      child: const Text("Print TokenManager")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                            if(Dummysingleton().dummyData == ""){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoadingPage(callbackWidget: SyncNeedingPage())))
                            }
                            else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SyncNeedingPage()))
                            }
                          },
                      child: const Text("Loading during sync")
                  ),
                  ElevatedButton(
                      onPressed: () async => await PortalService().mediacentreWorkflow(),
                      child: const Text("Get Mediacentre Favs")
                  ),
                ],
              )
            ]
        ),
      ),
    );
  }

  const HomePage({super.key});

}