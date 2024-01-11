abstract class AppRoutes {
  static const String home = '/';
  static const String addPlayers = '/add-players';
  static const String game = '/game';
  static const String play = '/play';
}

abstract class AppRouteNames {
  static const String home = 'home';
  static const String addPlayers = 'add-players';
  static const String game = 'game';
  static const String play = 'play';
}

abstract class AppRouteList {
  static const List<String> routes = [
    AppRoutes.home,
    AppRoutes.addPlayers,
    AppRoutes.game,
    AppRoutes.play,
  ];
}
