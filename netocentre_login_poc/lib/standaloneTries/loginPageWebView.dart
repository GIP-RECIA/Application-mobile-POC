import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPageWebView extends StatefulWidget {
  const LoginPageWebView({super.key});

  @override
  State<LoginPageWebView> createState() => _LoginPageWebViewState();
}

class _LoginPageWebViewState extends State<LoginPageWebView> {
  late final WebViewController controller;

  Future<void> _onListCookies(WebViewController controller) async {
    final Object cookies = await controller.runJavaScriptReturningResult('document.cookie');
    print(cookies.toString().isNotEmpty ? cookies.toString() : 'There are no cookies.');
  }

  Future<void> _tryToGetAllCookies(WebViewController controller) async {
    final Object cookies = await controller.runJavaScriptReturningResult('''
    
    if(typeof originalFetch === 'undefined') {
    const originalFetch = window.fetch;
    };
    window.fetch = function() {
    return originalFetch.apply(this, arguments)
    .then(response => {
    const cookies = response.headers.get('set-cookie');
    console.log("fetch cookies : " + cookies);
    return response;
    });
    };
    
    if(typeof originalOpen === 'undefined') {
    const originalOpen = window.XMLHttpRequest.prototype.open;
    };
    window.XMLHttpRequest.prototype.open = function() {
    this.addEventListener('load', function() {
    const cookies = this.getResponseHeader('set-cookie');
    console.log("XMLHttpRequest cookies : " + cookies);
    });
    return originalOpen.apply(this, arguments);
    };
    
    ''');
    print(cookies.toString().isNotEmpty ? cookies.toString() : 'There are no cookies.');
  }


  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            //_onListCookies(controller);
            _tryToGetAllCookies(controller);
          },
          onPageStarted: (String url) {
            _tryToGetAllCookies(controller);
          },
          onPageFinished: (String url) {
            _tryToGetAllCookies(controller);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print(request.url);
            if (!request.url.startsWith('https://')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://10.209.27.76:8443/cas/login'));
      //..loadRequest(Uri.parse('https://secure.giprecia.net/cas/login'));
      //..loadRequest(Uri.parse('https://ent.netocentre.fr/cas/login?service=https://ent.recia.fr/portail/Login&idpId=eleves-parents&token=acd3f7983ba9e0f8b64dd9de391e8b4d'));
    // #enddocregion webview_controller
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion à l\'ENT')),
      body: WebViewWidget(controller: controller),
    );
  }
}