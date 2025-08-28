import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/models/appUser.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:delivery_app/core/services/auth_services.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';
import 'package:delivery_app/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _authServices = locator<AuthServices>();
  DatabaseServices databaseServices = DatabaseServices();
  // User model
  AppUser _appUser = AppUser();
  AppUser get appUser => _appUser;

  // User orders
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  // User addresses
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  UserProvider() {
    fetchUserData();
  }

  fetchUserData() {
    listenToUser();

    listenToOrders();
  }

  listenToUser() {
    var userId = _auth.currentUser?.uid;
    if (userId != null) {
      Stream<AppUser?> userStream = databaseServices.getUserStream(userId);
      userStream.listen(
        (userData) {
          if (userData != null) {
            print(userData.toJson().toString());
            _appUser = userData;
            _addresses = userData.addresses ?? [];
            notifyListeners();
          }
        },
      );
    }
  }

  listenToOrders() {
    var userId = _auth.currentUser?.uid;
    if (userId != null) {
      Stream<List<OrderModel>> ordersStream =
          databaseServices.getOrdersByUserId(userId);
      ordersStream.listen(
        (orderData) {
          print(orderData);
          _orders = orderData;
          notifyListeners();
        },
      );
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      // Update the local user object
      appUser.name = newName;
      notifyListeners();

      // Update the user name in the database
      await databaseServices.updateUser(appUser);
    } catch (e) {
      print('Error updating user name: $e');
      // You might want to handle the error appropriately
    }
  }

  Future<void> addAddress(Address address) async {
    try {
      // Add the new address to the local list
      _addresses.add(address);

      // Update the user's addresses in the appUser model
      _appUser.addresses = _addresses;

      // Notify listeners of the change
      notifyListeners();

      // Update the user data in the database
      await databaseServices.updateUser(_appUser);
    } catch (e) {
      print('Error adding address: $e');
      // Remove the address from local list if database update fails
      _addresses.remove(address);
      _appUser.addresses = _addresses;
      notifyListeners();
      rethrow; // Rethrow the error so it can be handled by the UI
    }
  }

  // Optional: Add method to remove address
  Future<void> removeAddress(Address address) async {
    try {
      // Remove the address from the local list
      _addresses.removeWhere((addr) =>
          addr.address == address.address && addr.location == address.location);

      // Update the user's addresses
      _appUser.addresses = _addresses;

      // Notify listeners of the change
      notifyListeners();

      // Update the user data in the database
      await databaseServices.updateUser(_appUser);
    } catch (e) {
      print('Error removing address: $e');
      // Restore the address if database update fails
      _addresses.add(address);
      _appUser.addresses = _addresses;
      notifyListeners();
      rethrow;
    }
  }

  void reinitialize() {
    _appUser = AppUser();
    _orders = [];
    _addresses = [];
    fetchUserData();
  }

  void updateAddress(Address oldAddress, Address newAddress) {
    final index = addresses.indexOf(oldAddress);
    if (index != -1) {
      addresses[index] = newAddress;
      notifyListeners();
    }
  }
}
