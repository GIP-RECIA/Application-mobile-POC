import 'package:netocentre_login_poc/repositories/tokenRepository.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  String _accessToken = "";
  String _refreshToken = "";
  String _TGT = "";
  String _JSESSIONID = "";
  DateTime _accessTokenExpiresDate = DateTime.now();
  DateTime _refreshTokenExpiresDate = DateTime.now();


  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  String get accessToken => _accessToken;

  setAccessToken(String token, {bool flush = false}) {
    _accessToken = token;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  String get refreshToken => _refreshToken;

  setRefreshToken(String token, {bool flush = false}) {
    _refreshToken = token;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  String get TGT => _TGT;

  setTGT(String token, {bool flush = false}) {
    _TGT = token;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  String get JSESSIONID => _JSESSIONID;

  setJSESSIONID(String token, {bool flush = false}) {
    _JSESSIONID = token;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  DateTime get refreshTokenExpiresDate => _refreshTokenExpiresDate;

  setRefreshTokenExpiresDate(DateTime value, {bool flush = false}) {
    _refreshTokenExpiresDate = value;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  DateTime get accessTokenExpiresDate => _accessTokenExpiresDate;

  setAccessTokenExpiresDate(DateTime value, {bool flush = false}) {
    _accessTokenExpiresDate = value;

    if(flush){
      TokenRepository().flushTokens();
    }
  }

  @override
  String toString() {
    return 'TokenManager{_accessToken: $_accessToken, _refreshToken: $_refreshToken, _TGT: $_TGT, _JSESSIONID: $_JSESSIONID, _accessTokenExpiresDate: $_accessTokenExpiresDate, _refreshTokenExpiresDate: $_refreshTokenExpiresDate}';
  }
}