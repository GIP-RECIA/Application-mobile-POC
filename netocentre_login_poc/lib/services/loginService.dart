import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:netocentre_login_poc/singletons/baseUrl.dart';
import 'package:netocentre_login_poc/singletons/tokenManager.dart';

class LoginService {

 // Dev only - allow self-signed ssl certificates
 http.Client ignoreSslClient() {
   var ioClient = HttpClient(context: SecurityContext(withTrustedRoots: false));
   ioClient.badCertificateCallback = ((cert, host, port) => true);

   return IOClient(ioClient);
 }


 Future<Map<String, dynamic>> login(String OCToken) async {
   print("in login");

   final client = ignoreSslClient();

   Map<String, dynamic> credentials;

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/oauth2.0/token",
       {
         'client_id': 'client',
         'client_secret': 'secret',
         'redirect_uri': 'https://${BaseUrl().casBaseURL}/cas',
         'grant_type': 'authorization_code',
         'code': OCToken
       }
   );
   print("login request : $request");
   final http.Response res = await client.post(
       request
   );

   if(res.statusCode == 200) {
     credentials = json.decode(res.body);
     if(credentials.containsKey("access_token")){
       TokenManager().setAccessToken(credentials["access_token"]);
     }
     if(credentials.containsKey("expires_in")){
       TokenManager().setAccessTokenExpiresDate(DateTime.now().add(Duration(seconds: credentials["expires_in"])));
     }
     if(credentials.containsKey("refresh_token")){
       TokenManager().setRefreshToken(credentials["refresh_token"], flush: true);
     }
     // if(credentials.containsKey("TGT")){
     //   print("Tu ne devrais pas êàtre la");
     //   TokenManager().setTGT(credentials["TGT"], flush: true);
     // }
     print("login headers : ${res.headers}");
   }
   else{
     credentials = {};
   }
   print("login status code : ${res.statusCode}");
   print("login creds : $credentials");
   return credentials;
 }

 Future<bool> uPortalLogin() async {
   print("in uPortal login");

   final client = ignoreSslClient();

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/login",
       {
         'service': 'https://${BaseUrl().uPortalBaseURL}/portail/Login'
       }
   );
   print("uPortal login request : $request");
   final http.Response res = await client.get(
       request,
       headers: <String, String>{
         'Cookie': 'TGC=${TokenManager().TGT}',
         'Host': BaseUrl().casBaseURL
       },
   );


   if(res.statusCode == 200) {
     print("uPortalLogin request headers : ${res.request?.headers.toString()}");
     print("uPortalLogin response headers : ${res.headers.toString()}");
     print("uPortalLogin response headers (cookies) : ${res.headers["set-cookie"]}");
     print("uPortalLogin body : ${res.body}");
     Cookie responseCookie = Cookie.fromSetCookieValue(res.headers["set-cookie"]!);

     if(responseCookie.name == "JSESSIONID"){
       TokenManager().setJSESSIONID(responseCookie.value, flush: true);
       return true;
     }
   }
   return false;
 }

 Future<bool> unstackedUPortalLogin() async {

   print("=== Start of unstacked uPortal login ===");

   final client = HttpClient();
   var uri = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/login",
       {
         'service': 'https://${BaseUrl().uPortalBaseURL}/portail/Login'
       }
   );
   var request = await client.getUrl(uri);
   request.followRedirects = false;
   request.headers.add('Cookie', 'TGC=${TokenManager().TGT}');

   /// Request 0 - initial request
   print("Request 0 :");
   print(request.headers);

   var response = await request.close();

   int requestCounter = 0;
   String jsessionidCookie = "";


   while (response.isRedirect) {
     final location = response.headers.value(HttpHeaders.locationHeader);
     if (location != null) {
       uri = uri.resolve(location);
       request = await client.getUrl(uri);

       request.followRedirects = false;

       /// PARSE JSESSIONID

       print(response.headers["set-cookie"]);
       if(response.headers["set-cookie"]!.isNotEmpty){

         List<String> cookiesList = response.headers["set-cookie"]!;
         //List<String> cookiesList = cookies.split(";");
         print(cookiesList.toString());

         Iterable<String> jsessionidParser = cookiesList.where((str) => str.contains("JSESSIONID"));
         if(jsessionidParser.isNotEmpty){
           jsessionidCookie = jsessionidParser.first.substring(jsessionidParser.first.indexOf("=")+1);
           print("JSESSIONID COOKIE : $jsessionidCookie");
         }
         else{
           print("jsessionid not found");
         }
       }

       if(jsessionidCookie != ""){
         request.headers.add('Cookie', "JSESSIONID=$jsessionidCookie");
       }

       print("\n");
       print("Response $requestCounter :");
       print(response.headers);
       print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
       print("Request ${requestCounter + 1} :");
       print(request.headers);

       requestCounter++;

       response = await request.close();
     }
   }

   /// Parse last JSESSIONID
   print(response.headers["set-cookie"]);
   if(response.headers["set-cookie"] != null){
     List<String> cookies = response.headers["set-cookie"]!;
     List<String> cookiesList = [];
     for(var cookie in cookies){
       cookiesList += cookie.split(";");
     }

     Iterable<String> jsessionidParser = cookiesList.where((str) => str.contains("JSESSIONID"));
     if(jsessionidParser.isNotEmpty){
       jsessionidCookie = jsessionidParser.first.substring(jsessionidParser.first.indexOf("=")+1);
       print("JSESSIONID COOKIE : $jsessionidCookie");
     }
     else{
       print("jsessionid not found");
     }
   }

   /// Last response
   print("Response $requestCounter :");
   print(response.statusCode);
   print(response.headers);

   /// Redirects stack printing
   response.redirects.forEach((l) {
     print(l.location.toString());
   });

   print("Final JSESSIONID : $jsessionidCookie");

   print("=== End of unstacked uPortal login ===");

   if(jsessionidCookie != ""){
     TokenManager().setJSESSIONID(jsessionidCookie, flush: true);
     return true;
   }
   return false;
 }


 Future<Map<String, dynamic>> refresh(String refreshToken) async {
   print("in refresh");

   final client = ignoreSslClient();


   Map<String, dynamic> credentials;

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/oauth2.0/accessToken",
       {
         'client_id': 'client',
         'client_secret': 'secret',
         'grant_type': 'refresh_token',
         'refresh_token': refreshToken
       }
   );
   print("request : $request");
   final http.Response res = await client.post(
       request
   );

   print(res.statusCode);
   if(res.statusCode == 200) {
     credentials = json.decode(res.body);
     if(credentials.containsKey("access_token")){
       TokenManager().setAccessToken(credentials["access_token"]);
     }
     if(credentials.containsKey("expires_in")){
       TokenManager().setAccessTokenExpiresDate(DateTime.now().add(Duration(seconds: credentials["expires_in"])));
     }
     if(credentials.containsKey("TGT")){
       TokenManager().setTGT(credentials["TGT"], flush: true);
       //uPortalLogin(); // also refresh JSESSIONID
     }
     print("refresh headers : ${res.headers}");
   }
   else{
     credentials = {};
   }
   print("refresh creds : $credentials");
   return credentials;
 }

 /// Pratique pour le multi-domaine
 Future<Map<String, dynamic>> profile() async {
   print("in profile");

   final client = ignoreSslClient();

   Map<String, dynamic> credentials;

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/oauth2.0/profile",
       {
         'access_token': TokenManager().accessToken
       }
   );

   print("request : $request");
   final http.Response res = await client.post(
       request
   );

   print(res.statusCode);
   if(res.statusCode == 200) {
     credentials = json.decode(res.body);
     print("profile headers : ${res.headers}");
   }
   else{
     credentials = {};
   }
   print("profile creds : $credentials");
   print("esco siren courant : ${credentials["attributes"]["ESCOSIRENCourant"]}");
   if(credentials["attributes"]["ESCOSIRENCourant"] != null){
     await getEtab(credentials["attributes"]["ESCOSIRENCourant"]);
   }
   return credentials;
 }

 Future<Map<String, dynamic>> tokenIntrospect({isAccess = false}) async {
   print("in token introspect");

   final client = ignoreSslClient();


   Map<String, dynamic> credentials;

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/oauth2.0/introspect",
       {
         'token': isAccess ? TokenManager().accessToken : TokenManager().refreshToken
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
     print("token introspect headers : ${res.headers}");
     if(credentials.containsKey("exp")){
       TokenManager().setRefreshTokenExpiresDate(DateTime.fromMillisecondsSinceEpoch(credentials["exp"]*1000), flush: true);
       print("Refresh token exp DateTime : ${TokenManager().refreshTokenExpiresDate}");
     }
   }
   else{
     credentials = {};
   }
   //credentials["statusCode"] = res.statusCode;
   print("token introspect creds : $credentials");
   return credentials;
 }

 Future<int> revokeToken() async {
   print("in revoke token");

   final client = ignoreSslClient();

   Uri request = Uri.https(
       BaseUrl().casBaseURL,
       "/cas/oauth2.0/revoke",
       {
         'token': TokenManager().accessToken
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
     // credentials = json.decode(res.body);
     // print("refresh headers : ${res.headers}");
     // if(credentials.containsKey("exp")){
     //   TokenManager().setRefreshTokenExpiresDate(DateTime.fromMillisecondsSinceEpoch(credentials["exp"]*1000), flush: true);
     //   print("Refresh token exp DateTime : ${TokenManager().refreshTokenExpiresDate}");
     // }
   }
   else{
     // credentials = {};
   }
   //credentials["statusCode"] = res.statusCode;
   // print("refresh creds : $credentials");
   return res.statusCode;
 }

 /// Pratique pour le multi-domaine
 Future<Map<String, dynamic>> getEtab(String ESCOSIRENCourant) async {
   print("in get etab");

   final client = ignoreSslClient();

   Map<String, dynamic> credentials;

   Uri request = Uri.https(
       BaseUrl().uPortalBaseURL,
       "change-etablissement/rest/v2/structures/structs/",
       {
         'ids': ESCOSIRENCourant
       }
   );

   print("request : $request");
   final http.Response res = await client.get(
       request
   );

   print(res.statusCode);
   if(res.statusCode == 200) {
     credentials = json.decode(res.body);
     print("get etab headers : ${res.headers}");
   }
   else{
     credentials = {};
   }
   print("get etab creds : $credentials");
   //print("esco siren courant : ${credentials["attributes"]["ESCOSIRENCourant"]}");
   return credentials;
 }
}