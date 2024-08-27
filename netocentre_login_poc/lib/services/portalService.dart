import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../singletons/baseUrl.dart';
import '../singletons/tokenManager.dart';
import 'loginService.dart';

class PortalService{


  http.Client ignoreSslClient() {
    var ioClient = HttpClient(context: SecurityContext(withTrustedRoots: false));
    ioClient.badCertificateCallback = ((cert, host, port) => true);

    return IOClient(ioClient);
  }

  Future<bool> isAuthorizedByUPortal() async{
    if(TokenManager().JSESSIONID != ""){
      return true;
    }
    else{
      return await LoginService().unstackedUPortalLogin();
    }
  }

  Future<void> getAllPortlets() async {
    print("getting portlets");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/portail/api/v4-3/dlm/portletRegistry.json",
        {'category': 'All categories'}
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL
        },
      );

      print(res.statusCode);
      if(res.statusCode == 200) {
        // for(int i = 0; i < res.body.length; i += 800){
        //   print(res.body.substring(i, i+800 > res.body.length ? res.body.length : i+800));
        // }

        /// Parse json and get portlets fname

        final dynamic jsonSubcategories  = json.decode(res.body)["registry"]["categories"][0]["subcategories"];

        Set<String> portletsSet = {};
        int favCount = 0;
        List<String> favNames = [];

        for(var subcategory in jsonSubcategories){
          for (var portlet in subcategory["portlets"]){
            print(portlet["fname"]);
            print(portlet["favorite"]);
            if(portlet["favorite"] == true){
              favCount++;
              favNames.add(portlet["fname"]);
            }
            if(portlet["parameters"].containsKey("mobileIconUrl")){
              print(portlet["parameters"]["mobileIconUrl"]["value"]);
            }
            if(portlet["parameters"].containsKey("alternativeMaximizedLink")){
              print("is auth by cas : " + portlet["parameters"]["alternativeMaximizedLink"]["value"]);
            }
            portletsSet = {...portletsSet, portlet["fname"]};
          }
        }

        final List<String> portlets = portletsSet.toList(growable: false);

        print(portlets.toString());
        print(favCount);
        print(favNames.toString());
      }
      else{
        print("on a un problème là ! :'(");
      }
    }
    else{
      print("JSESSIONID Empty !");
    }
  }

  Future<dynamic> getUserInfo() async{
    print("getting user infos");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/portail/api/v5-1/userinfo",
        {
          'claims': 'private,picture,name,ESCOSIRENCourant,ESCOSIREN',
          'groups': ''
        }
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL
        },
      );

      print(res.statusCode);
      if(res.statusCode == 200) {

        /// Decode base64 and parse json
        print(res.body);

        String base64url = res.body.split('.')[1];
        base64url = base64url.replaceAll("-", "+").replaceAll("_", "/");

        base64url = base64url + ("=" * (4-(base64url.length % 4)));

        print(base64url);

        print(utf8.decode(base64.decode(base64url)));

        return json.decode(utf8.decode(base64.decode(base64url)));
      }
      else{
        print("on a un problème là ! :'(");
        return null;
      }
    }
    else{
      print("JSESSIONID Empty !");
      return null;
    }
  }

  Future<void> mediacentreWorkflow() async {
    String bearer = await getUserInfoMediacentre();

    String groupsRegexData = await getGroupsRegexFromConfig(bearer);

    List<dynamic> groups = await getGroups(bearer);

    /// Filter groups with regex

    List<String> userGroups = [];

    RegExp groupsRegex = RegExp(
        r'^.*:(admin|Inter_etablissements|Etablissements|Applications):.*$', // TODO : à remplacer par groupsRegexData quand fonctionnel
        multiLine: true,
        caseSensitive: true
    );

    for (var group in groups) {
      Map<String, dynamic> currGroup = group;
      if(groupsRegex.hasMatch(currGroup["name"])){
        userGroups.add(currGroup["name"]);
      }
    }

    /// Get favorite ressources

    List<dynamic> ressources = await getRessources(bearer, userGroups);

    Map<String, dynamic> favRessourceIds = await getFavoriteRessourceIds(bearer);

    List<String> favRessources = List<String>.from(favRessourceIds["mediacentreFavorites"] as List);

    for(var ressource in ressources){
      Map<String, dynamic> currRessource = ressource;
      if(favRessources.contains(currRessource["idRessource"])) {
        print("fav : ${currRessource["nomRessource"]}");
      }
    }
  }

  Future<String> getUserInfoMediacentre() async{
    print("getting user infos - mediacentre");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/portail/api/v5-1/userinfo",
        {
          'claims': 'private,ESCOSIRENCourant,ESCOSIREN,ENTPersonGARIdentifiant,profile',
          'groups': ''
        }
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL
        },
      );

      print(res.statusCode);
      if(res.statusCode == 200) {
        return res.body;
      }
      else{
        print("on a un problème là ! :'(");
        return "";
      }
    }
    else{
      print("JSESSIONID Empty !");
      return "";
    }
  }

  /// MediaCentre
  Future<List<dynamic>> getGroups(String bearer) async{
    print("getting user infos");

    final client = ignoreSslClient();

    List<dynamic> data;

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/portail/api/groups",
        {}
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL,
          'Authorization': 'Bearer $bearer'
        },
      );

      print(res.statusCode);
      if(res.statusCode == 200) {

        data = json.decode(res.body)["groups"];

        return data;
      }
      else{
        print("on a un problème là ! :'(");

        data = [];

        return data;
      }
    }
    else{
      print("JSESSIONID Empty !");

      data = [];

      return data;
    }
  }

  /// MediaCentre
  Future<String> getGroupsRegexFromConfig(String bearer) async{
    print("getting user infos");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/mediacentre-api/api/config",
        {}
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL,
          'Authorization': 'Bearer $bearer'
        },
      );

      print(res.statusCode);
      if(res.statusCode == 200) {

        List<dynamic> credentials = json.decode(res.body);

        String regex = credentials[0]["value"];

        return regex;
      }
      else{
        print("on a un problème là ! :'(");
        return "";
      }
    }
    else{
      print("JSESSIONID Empty !");
      return "";
    }
  }

  /// MediaCentre
  Future<List<dynamic>> getRessources(String bearer, List<String> userGroups) async{
    print("getting user infos");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/mediacentre-api/api/resources",
        {}
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    Map<String,dynamic> bodyMap = {
      'isMemberOf': userGroups
    };

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.post(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL,
          'Authorization': 'Bearer $bearer',
          'Content-Type': 'application/json',
          'Accept': 'application/json, text/plain, */*'
        },
        body: jsonEncode(bodyMap)
      );

      print(res.statusCode);
      if(res.statusCode == 200) {

        print(res.body);

        List<dynamic> ressources = json.decode(res.body);

        return ressources;
      }
      else{
        print("on a un problème là ! :'(");
        return [];
      }
    }
    else{
      print("JSESSIONID Empty !");
      return [];
    }
  }

  /// MediaCentre
  Future<Map<String,dynamic>> getFavoriteRessourceIds(String bearer) async{
    print("getting user infos");

    final client = ignoreSslClient();

    Uri request = Uri.https(
        BaseUrl().uPortalBaseURL,
        "/portail/api/prefs/getentityonlyprefs/Mediacentre",
        {}
    );

    print("getting portlet request : $request");
    print("JSESSIONID=${TokenManager().JSESSIONID}");

    if(await isAuthorizedByUPortal()){
      final http.Response res = await client.get(
        request,
        headers: <String, String>{
          'Cookie': 'JSESSIONID=${TokenManager().JSESSIONID}',
          'Host': BaseUrl().uPortalBaseURL,
          'Authorization': 'Bearer $bearer',
          'Content-Type': 'application/json'
        }
      );

      print(res.statusCode);
      if(res.statusCode == 200) {

        print(json.decode(res.body));

        Map<String,dynamic> ressources = json.decode(res.body);

        return ressources;
      }
      else{
        print("on a un problème là ! :'(");
        return {};
      }
    }
    else{
      print("JSESSIONID Empty !");
      return {};
    }
  }

}