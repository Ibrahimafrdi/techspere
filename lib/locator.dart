import 'package:delivery_app/core/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'core/services/auth_services.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerSingleton(AuthServices());
  locator.registerSingleton(NavigationService());
}
