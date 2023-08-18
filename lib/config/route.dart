import 'package:my_tiny_map/pages/home_page.dart';
import 'package:my_tiny_map/screens/addmemory_screen.dart';
import 'package:my_tiny_map/screens/marker_list_screen.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
  static const editLocation = '/editLocation';
  static const markerListScreen = '/markerListScreen';
}

var nameRoutes = {
  RouteName.home: (context) => const HomePage(),
  RouteName.addLocation: (context) => const AddMemoryScreen(),
  RouteName.markerListScreen: (context) => const MarkerListScreen(),
};
