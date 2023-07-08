import 'package:my_tiny_map/pages/home_page.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
  static const searchLocation = '/searchLocation';
}

var nameRoutes = {
  RouteName.home: (context) => const HomePage(),
  RouteName.searchLocation: (context) => const HomePage(),
};
