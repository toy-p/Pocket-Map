import 'package:flutter/material.dart';
import 'package:my_tiny_map/screens/home_screen.dart';
import 'package:my_tiny_map/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: const HomeScreen(),
    );
  }
}
