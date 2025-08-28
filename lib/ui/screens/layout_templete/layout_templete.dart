import 'package:delivery_app/core/services/navigation_service.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/routing/router.dart';
import 'package:delivery_app/routing/routing_names.dart';
import 'package:delivery_app/ui/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/home_widgets/appBar/appBarDesktop.dart';
import '../../../core/data_providers/cart_provider.dart';

class LayoutTemplate extends StatefulWidget {
  const LayoutTemplate({super.key});

  @override
  State<LayoutTemplate> createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  bool _isProfileOpen = false;

  void _toggleProfile() {
    setState(() {
      _isProfileOpen = !_isProfileOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool desktop = screenWidth > 800;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if(desktop) AppBarDesktop(
                onPress: () {
                  context.read<CartProvider>().toggleCart();
                },
                onPres: (){},
                onProfileTap: _toggleProfile,
              ),
              Expanded(
                child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: homeRoute,
                ),
              ),
            ],
          ),
          if (_isProfileOpen) ProfileScreen(toggleProfile: _toggleProfile),
        ],
      ),
    );
  }
}