import 'package:delivery_app/ui/screens/add_to_cart/addtocart_desktop.dart';
import 'package:delivery_app/ui/screens/my_cart/myCartDesktop.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/routing/routing_names.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_Screen.dart';
import '../ui/screens/about_screen/about_screen.dart';
import '../ui/screens/menu_screen/menu_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return _getPageRoute(const HomeScreen());
    case offerRoute:
      return _getPageRoute(const OfferScreen());
    case menuRoute:
      return _getPageRoute(const MenuScreen());
    default:
    // If the route name doesn't match, return a default "Not Found" screen
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
