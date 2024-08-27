import 'package:flutter/material.dart';
import 'package:netocentre_login_poc/pages/homePage.dart';
import 'package:netocentre_login_poc/pages/loginPage.dart';
import 'package:netocentre_login_poc/repositories/tokenRepository.dart';
import 'package:netocentre_login_poc/services/loginService.dart';
import 'package:netocentre_login_poc/singletons/tokenManager.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("token manager before loaded : ${TokenManager().toString()}");
  await TokenRepository().getLastValidRefreshToken();
  if(TokenManager().refreshToken != ""){
    if(TokenManager().accessTokenExpiresDate.isBefore(DateTime.now())){
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
        title: 'CAS Authentication Test',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    }
    else{
      return const MaterialApp(
        title: 'CAS Authentication Test',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      );
    }
  }
}
