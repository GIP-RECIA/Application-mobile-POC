class UserInfo {
  static final UserInfo _instance = UserInfo._internal();
  String _firstname = "";
  String _lastname = "";
  String _pictureURI = "";

  factory UserInfo() {
    return _instance;
  }

  UserInfo._internal();

  String get pictureURI => _pictureURI;

  setPictureURI(String value) {
    _pictureURI = value;
  }

  String get lastname => _lastname;

  setLastname(String value) {
    _lastname = value;
  }

  String get firstname => _firstname;

  setFirstname(String value) {
    _firstname = value;
  }
}