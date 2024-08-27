import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Color containerColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                onPressed: () async {
                  await LaunchApp.openApp(
                    androidPackageName: 'com.IndexEducation.Pronote',
                    iosUrlScheme: 'nextcloud://',
                    appStoreLink: 'itms-apps://apps.apple.com/fr/app/nextcloud/id1125420102',
                    // openStore: false
                  );

                  // Enter the package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
                  // The `openStore` argument decides whether the app redirects to PlayStore or AppStore.
                  // For testing purpose you can enter com.instagram.android
                },
                child: const Center(
                  child: Text("Open",
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}