class Urls {
  static const String restBaseUrl = "https://dummyjson.com/";

  static const String todosEndpoint = "todos";
  static const String authEndpoint = "auth";

  static const String addTodoEndpoint = "$todosEndpoint/add";
  static const String getRandomTodoEndpoint = "$todosEndpoint/random";

  static const String loginEndpoint = "$authEndpoint/login";
  static const String meEndpoint = "$authEndpoint/me";
  static const String refreshEndpoint = "$authEndpoint/refresh";
}
