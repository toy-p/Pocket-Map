import 'package:my_tiny_map/pages/home_page.dart';
import 'package:my_tiny_map/screens/add_location_screen.dart';
import 'package:my_tiny_map/utils/show_all_memory.dart';

class RouteName {
  static const home = '/';
  static const addLocation = '/addLocation';
  static const customBottomSheet = '/customBottomSheet';
}

var nameRoutes = {
  RouteName.home: (context) => const HomePage(),
  RouteName.addLocation: (context) => const AddLocationScreen(),
  RouteName.customBottomSheet: (context) => const CustomBottomSheet(),
};
