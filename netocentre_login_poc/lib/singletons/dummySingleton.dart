class Dummysingleton {
  static final Dummysingleton _instance = Dummysingleton._internal();

  String _dummyData = "";

  factory Dummysingleton() {
    return _instance;
  }

  Dummysingleton._internal();

  String get dummyData => _dummyData;

  setDummyData(String value) {
    _dummyData = value;
  }
}