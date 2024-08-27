import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';


class AuthenticationInAppBrowser extends InAppBrowser {

  late String OCToken;
  late String RefreshToken;

  late Map<String, dynamic> loginResponseBody;


  String? getOCToken(WebUri url){
    return url.queryParameters["code"];
  }


  String casBaseURL = "10.209.27.76:8443";


  http.Client ignoreSslClient() {
    var ioClient = HttpClient(context: SecurityContext(withTrustedRoots: false));
    ioClient.badCertificateCallback = ((cert, host, port) => true);

    return IOClient(ioClient);
  }


  Future<Map<String, dynamic>> login() async {
    print("in login");

    final client = ignoreSslClient();


    Map<String, dynamic> credentials;

    Uri request = Uri.https(
        casBaseURL,
        "/cas/oauth2.0/accessToken",
        {
          'client_id': 'client',
          'client_secret': 'secret',
          'redirect_uri': 'https://oauthtest/test',
          'grant_type': 'authorization_code',
          'code': OCToken
        }
    );
    print("request : $request");
    final http.Response res = await client.post(
        request
    );

    print(res.statusCode);
    //return res;
    if(res.statusCode == 200) {
      credentials = json.decode(res.body);
      loginResponseBody = credentials;
      if(loginResponseBody.containsKey("refresh_token")){
        RefreshToken = loginResponseBody["refresh_token"];
      }
      print("login headers : ${res.headers}");
    }
    else{
      credentials = {};
    }

    print("login creds : $credentials");
    return credentials;
  }

  Future<Map<String, dynamic>> refresh() async {
    print("in refresh");

    final client = ignoreSslClient();


    Map<String, dynamic> credentials;

    Uri request = Uri.https(
        casBaseURL,
        "/cas/oauth2.0/accessToken",
        {
          'client_id': 'client',
          'client_secret': 'secret',
          'grant_type': 'refresh_token',
          'refresh_token': RefreshToken
        }
    );
    print("request : $request");
    final http.Response res = await client.post(
        request
    );

    print(res.statusCode);
    //return res;
    if(res.statusCode == 200) {
      credentials = json.decode(res.body);
      print("refresh headers : ${res.headers}");

    }
    else{
      credentials = {};
    }
    //credentials["statusCode"] = res.statusCode;
    print("refresh creds : $credentials");
    return credentials;
  }

  Future<Map<String, dynamic>> profile() async {
    print("in profile");

    final client = ignoreSslClient();


    Map<String, dynamic> credentials;

    Uri request = Uri.https(
        casBaseURL,
        "/cas/oauth2.0/profile",
        {
          // 'client_id': 'client',
          // 'client_secret': 'secret',
          // 'grant_type': 'refresh_token',
          'access_token': loginResponseBody['access_token']
        }
    );
    print("request : $request");
    final http.Response res = await client.post(
        request
    );

    print(res.statusCode);
    //return res;
    if(res.statusCode == 200) {
      credentials = json.decode(res.body);
      print("refresh headers : ${res.headers}");

    }
    else{
      credentials = {};
    }
    //credentials["statusCode"] = res.statusCode;
    print("refresh creds : $credentials");
    return credentials;
  }

  Future<Map<String, dynamic>> refreshTokenIntrospect() async {
    print("in profile");

    final client = ignoreSslClient();


    Map<String, dynamic> credentials;

    Uri request = Uri.https(
        casBaseURL,
        "/cas/oauth2.0/introspect",
        {
          'token': loginResponseBody['refresh_token']
        }
    );
    print("request : $request");

    var base64Basic = base64Encode(utf8.encode("client:secret"));

    print("base64: $base64Basic");

    final http.Response res = await client.post(
        request,
        headers: <String, String>{
          'Authorization': 'Basic $base64Basic'
        },
    );

    print(res.statusCode);
    //return res;
    if(res.statusCode == 200) {
      credentials = json.decode(res.body);
      print("refresh headers : ${res.headers}");

    }
    else{
      credentials = {};
    }
    //credentials["statusCode"] = res.statusCode;
    print("refresh creds : $credentials");
    return credentials;
  }

  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
    if(url != null){
      if(url.toString().contains("https://oauthtest/test")){
        OCToken = getOCToken(url)!;
        print("OCToken : $OCToken");
        close();
      }
      //print(url.toString());
    }
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    print("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }

  @override
  Future<ServerTrustAuthResponse> onReceivedServerTrustAuthRequest(
      URLAuthenticationChallenge challenge) async {
    return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
  }


}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final browser = AuthenticationInAppBrowser();

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppBrowser Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  browser.openUrlRequest(
                      urlRequest: URLRequest(url: WebUri("https://10.209.27.76:8443/cas/oauth2.0/authorize?response_type=code&redirect_uri=https://oauthtest/test&client_id=client&scope=profile")),
                      settings: settings);
                },
                child: const Text("Se connecter")),

            ElevatedButton(
                onPressed: () {
                  browser.login();
                },
                child: const Text("Login")),

            ElevatedButton(
                onPressed: () {
                  browser.refresh();
                },
                child: const Text("Refresh")),

            ElevatedButton(
                onPressed: () {
                  browser.profile();
                },
                child: const Text("Profile")),

            ElevatedButton(
                onPressed: () {
                  browser.refreshTokenIntrospect();
                },
                child: const Text("Refresh Token Introspect")),
          ],
        ),
      ),
    );
  }
}