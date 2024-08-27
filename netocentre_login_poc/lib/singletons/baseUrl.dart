class BaseUrl {
  static final BaseUrl _instance = BaseUrl._internal();

  //final String _casBaseURL ="secure.giprecia.net";
  //final String _casBaseURL = "10.209.27.76:8443"; // cas1 local server
  //final String _casBaseURL = "10.209.27.77:8443"; // cas2 local server
  //final String _casBaseURL = "cas.test.recia.dev"; // cas external server
  final String _casBaseURL = "auth.test.recia.dev"; // cas external server 2
  final String _uPortalBaseURL = "lycees.test.recia.dev"; // uportal external server

  factory BaseUrl() {
    return _instance;
  }

  BaseUrl._internal();

  String get casBaseURL => _casBaseURL;
  String get uPortalBaseURL => _uPortalBaseURL;
}