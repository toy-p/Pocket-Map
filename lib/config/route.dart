import 'package:my_tiny_map/pages/home_page.dart';
import 'package:my_tiny_map/screens/add_location_screen.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
}

var nameRoutes = {
  RouteName.home: (context) => const HomePage(),
  RouteName.addLocation: (context) => const AddLocationScreen(),
};
