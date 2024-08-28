import 'package:netocentre_login_poc/repositories/tokenRepository.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  String _accessToken = "";
  String _refreshToken = "";
  String _TGT = "";
  String _JSESSIONID = "";
  String _idPortal = "";
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


  String get idPortal => _idPortal;

  setIdPortal(String value, {bool flush = false}) {
    _idPortal = value;

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

  void reset() {
    _accessToken = "";
    _refreshToken = "";
    _TGT = "";
    _JSESSIONID = "";
    _accessTokenExpiresDate = DateTime.now();
    _refreshTokenExpiresDate = DateTime.now();
  }

  @override
  String toString() {
    return 'TokenManager{_accessToken: $_accessToken, _refreshToken: $_refreshToken, _TGT: $_TGT, _JSESSIONID: $_JSESSIONID, _idPortal: $_idPortal, _accessTokenExpiresDate: $_accessTokenExpiresDate, _refreshTokenExpiresDate: $_refreshTokenExpiresDate}';
  }
}