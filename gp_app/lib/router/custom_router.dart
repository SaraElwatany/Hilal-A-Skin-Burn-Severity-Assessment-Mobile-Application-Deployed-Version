import 'package:flutter/material.dart';
import 'package:gp_app/screens/welcome_page.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case "home":
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      default:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
    }
  }
}
