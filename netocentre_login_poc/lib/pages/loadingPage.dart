import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../singletons/dummySingleton.dart';

class LoadingPageUtils {

  BuildContext context;
  Widget callbackWidget;

  LoadingPageUtils(this.context, this.callbackWidget);

  /// API call to a dummy API to test if we can do the same thing with the real app
  Future<void> loadDataFromAPI() async {

    List<dynamic> data = [];

    Uri request = Uri.https(
      "binaryjazz.us",
      "wp-json/genrenator/v1/genre/3",

    );
    print("login request : $request");
    final http.Response res = await http.get(
        request
    );

    if(res.statusCode == 200){
      data = json.decode(res.body);
      Dummysingleton().setDummyData(data[1]);
    }
    print(data.toString());
    print(Dummysingleton().dummyData);
    sleep(const Duration(seconds: 10));
    navigatorPush();
  }

  navigatorPush(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => callbackWidget));
  }
}

class LoadingPage extends StatefulWidget {

  final Widget callbackWidget;

  const LoadingPage({required this.callbackWidget, super.key});

  @override
  State<StatefulWidget> createState() => LoadingPageState();

}

class LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    LoadingPageUtils(context, widget.callbackWidget).loadDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Loading"),
            LinearProgressIndicator(value: null,)
          ],
        ),
      ),
    );

  }
}