import 'package:flutter/material.dart';
import 'package:netocentre_app_poc/pages/homePage.dart';
import 'package:netocentre_app_poc/pages/loadingPage.dart';
import 'package:netocentre_app_poc/pages/unconnectedHomePage.dart';
import 'package:netocentre_app_poc/repositories/tokenRepository.dart';
import 'package:netocentre_app_poc/services/loginService.dart';
import 'package:netocentre_app_poc/singletons/tokenManager.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("token manager before loaded : ${TokenManager().toString()}");
  await TokenRepository().getLastValidRefreshToken();
  // if we get a valid Refresh Token from Database
  if(TokenManager().refreshToken != ""){
    // if the associated Access Token is expired
    if(TokenManager().accessTokenExpiresDate.isBefore(DateTime.now())){
      // refresh Access Token & associated TGT TODO: not working currently
      await LoginService().refresh(TokenManager().refreshToken);
    }
  }
  print("token manager after loaded : ${TokenManager().toString()}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    if(TokenManager().refreshToken != "") { // refresh token default value
      return const MaterialApp(
        title: 'Netocentre App POC',
        debugShowCheckedModeBanner: false,
        home: LoadingPage(callbackWidget: HomePage()),
      );
    }
    else{
      return const MaterialApp(
        title: 'Netocentre App POC',
        debugShowCheckedModeBanner: false,
        home: UnconnectedHomePage(),
      );
    }
  }
}
