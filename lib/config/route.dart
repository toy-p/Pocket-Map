import 'package:my_tiny_map/pages/home_page.dart';
import 'package:my_tiny_map/screens/edit_location_screen.dart';

import '../screens/add_location_screen.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
  static const editLocation = '/editLocation';
}

var nameRoutes = {
  RouteName.home: (context) => const HomePage(),
  RouteName.addLocation: (context) => const AddLocationScreen(),
  RouteName.editLocation: (contxt) => const EditLocationScreen(),
};
