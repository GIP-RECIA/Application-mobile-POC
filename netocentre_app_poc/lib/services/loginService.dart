import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:netocentre_app_poc/singletons/baseUrl.dart';
import 'package:netocentre_app_poc/singletons/tokenManager.dart';

class LoginService {

 // Dev only - allow self-signed ssl certificates
 http.Client ignoreSslClient() {
   var ioClient = HttpClient(context: SecurityContext(withTrustedRoots: false));
   ioClient.badCertificateCallback = ((cert, host, port) => true);

   return IOClient(ioClient);
 }

 /// Parser - JSESSIONID & idPortal

 ({String jsessionid, String idportal}) uPortalLoginParser(HttpClientResponse response){

   String jsessionidCookie = "";
   String idPortalCookie = "";

   if(response.headers["set-cookie"]!.isNotEmpty){

     List<String> rawCookiesList = response.headers["set-cookie"]!;
     List<String> cookiesList = [];

     for (var rawCookies in rawCookiesList){
       cookiesList.addAll(rawCookies.split(";"));
     }

     print(cookiesList.length);
     print(cookiesList.toString());

     Iterable<String> jsessionidParser = cookiesList.where((str) => str.contains("JSESSIONID"));
     Iterable<String> idPortalParser = cookiesList.where((str) => str.contains("clusterIDPortail"));
     if(jsessionidParser.isNotEmpty){
       jsessionidCookie = jsessionidParser.first.substring(jsessionidParser.first.indexOf("=")+1);
       print("JSESSIONID COOKIE : $jsessionidCookie");
     }
     else{
       print("jsessionid not found");
     }
     if(idPortalParser.isNotEmpty){
       idPortalCookie = idPortalParser.first.substring(idPortalParser.first.indexOf("=")+1);
       print("idPortal COOKIE : $idPortalCookie");
     }
     else{
       print("idPortal not found");
     }
   }

   return (jsessionid: jsessionidCookie, idportal: idPortalCookie);
 }

 Future<Map<String, dynamic>> login(String OCToken) async {
   print("in login");

   // create custom client who ignore ssl - surely dev only
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
     /// Get credentials from the response body
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
     //   print("Tu ne devrais pas être la");
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

 /// Used to earn the JSESSIONID
 Future<bool> unstackedUPortalLogin() async {

   // init variables
   int requestCounter = 0;
   String jsessionidCookie = "";
   String idPortalCookie = "";

   print("=== Start of unstacked uPortal login ===");

   /// Request 0 - initial request
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

   print("\nRequest $requestCounter :");
   print(request.uri.toString());
   print("request headers : ${request.headers}");

   // Get the first response
   var response = await request.close();

   // While we get a redirect
   while (response.isRedirect && requestCounter < 10) {

     // redirect url
     final location = response.headers.value(HttpHeaders.locationHeader);

     if (location != null) {
       uri = uri.resolve(location);

       //Configure the new request
       request = await client.getUrl(uri.resolve(location));

       /// PARSE JSESSIONID & idPortal

       print("\nResponse $requestCounter :");
       print(response.statusCode);
       print("response headers : ${response.headers["set-cookie"]}");
       print("response location : $location");

       ({String jsessionid, String idportal}) parsingResult = uPortalLoginParser(response);
       if(parsingResult.jsessionid != "" ){
         jsessionidCookie = parsingResult.jsessionid;
       }
       if(parsingResult.idportal != "" ){
         idPortalCookie = parsingResult.idportal;
       }

       request.followRedirects = false;

       if(jsessionidCookie != ""){
         request.cookies.add(Cookie("JSESSIONID", jsessionidCookie));
       }
       if(idPortalCookie != ""){
         request.cookies.add(Cookie("clusterIDPortail", idPortalCookie));
       }

       print("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
       print("\nRequest ${requestCounter + 1} :");
       print(request.uri.toString());
       print("request headers : ${request.headers}");

       requestCounter++;

       response = await request.close();
     }
   }

   /// Last response
   /// Parse last JSESSIONID & idPortal
   print("\nResponse $requestCounter :");
   print(response.statusCode);
   print("response headers : ${response.headers["set-cookie"]}");

   ({String jsessionid, String idportal}) parsingResult = uPortalLoginParser(response);
   if(parsingResult.jsessionid != "" ){
     jsessionidCookie = parsingResult.jsessionid;
   }
   if(parsingResult.idportal != "" ){
     idPortalCookie = parsingResult.idportal;
   }

   print("Final JSESSIONID : $jsessionidCookie");
   print("Final idPortal : $idPortalCookie");

   print("=== End of unstacked uPortal login ===");

   if(idPortalCookie != ""){
     TokenManager().setIdPortal(idPortalCookie, flush: true);
   }
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
     print("refresh headers : ${res.headers}");
   }
   else{
     credentials = {};
   }
   print("refresh creds : $credentials");
   return credentials;
 }

 /// Used to earn refresh token expires date
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
     //
   }
   else{
     //
   }
   return res.statusCode;
 }
}