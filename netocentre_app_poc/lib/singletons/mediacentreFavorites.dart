class MediacentreFavorites {
  static final MediacentreFavorites _instance = MediacentreFavorites._internal();
  List<String> _favorites = [];

  factory MediacentreFavorites() {
    return _instance;
  }

  MediacentreFavorites._internal();

  List<String> get favorites => _favorites;

  setFavorites(List<String> value) {
    _favorites = value;
  }
}