import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/splash_screen.dart';
import 'package:delivery_app/ui/screens/product_detail_screen/product_detail_provider.dart';
import 'package:delivery_app/ui/screens/auth_screens/auth_screens_provider.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_screen_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize if not already initialized
  //WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  //await seedFirestore(); // Call the seeding function
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => AuthScreensProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context)=>AddToCartScreenProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TechSpere\'s',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
