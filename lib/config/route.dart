import 'package:my_tiny_map/screen/add_location_screen.dart';
import 'package:my_tiny_map/screen/home_screen.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
}

var nameRoutes = {
  RouteName.home: (context) => const HomeScreen(),
  RouteName.addLocation: (context) => const AddLocationScreen(),
};
