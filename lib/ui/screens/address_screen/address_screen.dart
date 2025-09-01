import 'package:delivery_app/ui/screens/address_screen/address_mobile.dart';
import 'package:delivery_app/ui/screens/homeScreen/homeScreen_mobile.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenProvider(),
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: AddressScreenMobile(),
          // desktop: AddressScreenDesktop(),
        ),
      ),
    );
  }
}
