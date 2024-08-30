import 'package:flutter/material.dart';
import 'package:netocentre_login_poc/singletons/dummySingleton.dart';

class SyncNeedingPage extends StatefulWidget {
  const SyncNeedingPage({super.key});

  @override
  State<StatefulWidget> createState() => SyncNeedingPageState();
}

class SyncNeedingPageState extends State<SyncNeedingPage> {

  @override
  void initState() {
    super.initState();
    if(Dummysingleton().dummyData == ""){
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoadingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Dummysingleton().dummyData),
          ],
        ),
      ),
    );

  }


}