
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:netocentre_login_poc/pages/homePage.dart';
import 'package:netocentre_login_poc/services/loginService.dart';
import 'package:netocentre_login_poc/singletons/baseUrl.dart';
import 'package:netocentre_login_poc/singletons/tokenManager.dart';


class AuthenticationInAppBrowser extends InAppBrowser {

  late String OCToken;
  BuildContext context;

  CookieManager cookieManager = CookieManager.instance();

  AuthenticationInAppBrowser(this.context);

  @override
  InAppWebViewController? get webViewController => super.webViewController;

  LoginService loginService = LoginService();


  String? getOCToken(WebUri url){
    return url.queryParameters["code"];
  }

  void navigateToHomePage(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
  }

  Future<void> getMyCookies() async{
    List<Cookie> cookies = await cookieManager.getCookies(url: WebUri("https://${BaseUrl().casBaseURL}/cas"));
    for(var current in cookies) {
      print("in login webview - from cookie manager : $current");
      if(current.name == "TGC"){
        print("=======================================\n=== $current ===\n=======================================\n");
        TokenManager().setTGT(current.value, flush: true);
      }
    }
  }

  /// Whe we use the OAuth2.0 protocol - can be applied for OIDC protocol
  Future<void> oauthTokenCatching(WebUri url) async {
    print("url who potentially have OCToken : ${url.toString()}");
    OCToken = getOCToken(url)!;
    print("OCToken : $OCToken");
    if(OCToken != ""){
      cookieManager.removeSessionCookies();
      close();
      Map<String, dynamic> res = await loginService.login(OCToken);
      if(res.isNotEmpty){
        loginService.tokenIntrospect();
        print("In Login Page : ${TokenManager().toString()}");
        navigateToHomePage();
      }
    }
  }

  /// When we use only CAS protocol
  Future<void> casTokenCatching() async {
    if(TokenManager().TGT != ""){
      print("tgt catched");
      cookieManager.removeSessionCookies();
      close();
      navigateToHomePage();
    }
    else{
      print("tgt not catched");
    }
  }

  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    await getMyCookies(); // get cookies of the newly loaded page
    print("Started $url");
    if(url != null){
      if(url.toString().contains("https://${BaseUrl().casBaseURL}/cas")){
        //oauthTokenCatching(url);
        casTokenCatching();
      }
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

  @override
  Future<WebResourceResponse?>? shouldInterceptRequest(
      WebResourceRequest request) {
      print("request intercepted : ${request.url.toString()}");
     return null;
  }

  @override
  void onUpdateVisitedHistory(WebUri? url, bool? isReload) {
    if(url != null){
      print("updated history : ${url.toString()}");
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  late InAppBrowser browser;

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode, useShouldInterceptRequest: true, userAgent: HttpClient().userAgent!));


  @override
  void initState() {
    super.initState();
    browser = AuthenticationInAppBrowser(context);
  }

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
                      // OAuth2.0 Version
                      //urlRequest: URLRequest(url: WebUri("https://${BaseUrl().casBaseURL}/cas/oauth2.0/authorize?response_type=code&redirect_uri=https://${BaseUrl().casBaseURL}/cas&client_id=client&scope=profile")),

                      // CAS Version
                      urlRequest: URLRequest(url: WebUri("https://${BaseUrl().casBaseURL}/cas/login?service=https://${BaseUrl().casBaseURL}/cas")),
                      settings: settings);
              },
              child: const Text("Se connecter")
            ),
          ]
        ),
      ),
    );
  }
}