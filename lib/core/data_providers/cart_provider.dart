import 'package:delivery_app/core/models/cart.dart';
import 'package:delivery_app/core/models/order_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';

class CartProvider extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseServices databaseServices = DatabaseServices();  bool _isCartOpen = false;

  bool get isCartOpen => _isCartOpen;

  void toggleCart() {
    _isCartOpen = !_isCartOpen;
    notifyListeners();
  }

  void openCart() {
    _isCartOpen = true;
    notifyListeners();
  }

  void closeCart() {
    _isCartOpen = false;
    notifyListeners();
  }



  Cart _cart = Cart();
  Cart get cart => _cart;

  CartProvider() {
    listenToCart();
  }

  listenToCart() {
    var user = _auth.currentUser;
    if (user != null) {
      Stream<Cart> cartStream = databaseServices.getCartStream(user.uid);
      cartStream.listen(
        (cartData) {
          if (cartData != null) {
            _cart = cartData;
            notifyListeners();
          }
        },
      );
    }
  }

  addItemToCart(OrderItem item) {
    var user = _auth.currentUser;
    if (user == null) {
      _cart.addItem(item);
      notifyListeners();
      return;
    }

    // Check if item already exists in cart
    var existingItem = _cart.items?.firstWhere(
      (element) =>
          element.item?.id == item.item?.id &&
          element.selectedVariations?.toString() ==
              item.selectedVariations?.toString() &&
          element.selectedAddons?.toString() == item.selectedAddons?.toString(),
      orElse: () => OrderItem(),
    );

    if (existingItem?.item != null) {
      // Update quantity if item exists
      _cart.updateItemQuantity(existingItem!, item.quantity);
      databaseServices.updateCart(_cart, user.uid);
      notifyListeners();
      return;
    }
    _cart.addItem(item);
    databaseServices.updateCart(_cart, user.uid);
    notifyListeners();
  }

  removeItemFromCart(OrderItem item) {
    var user = _auth.currentUser;
    if (user == null) {
      _cart.removeItem(item);
      notifyListeners();
      return;
    }
    _cart.removeItem(item);
    databaseServices.updateCart(_cart, user.uid);
    notifyListeners();
  }

  updateItemQuantity(OrderItem item, int newQuantity) {
    var user = _auth.currentUser;
    if (user == null) {
      _cart.updateItemQuantity(item, newQuantity);
      notifyListeners();
      return;
    }
    _cart.updateItemQuantity(item, newQuantity);
    databaseServices.updateCart(_cart, user.uid);
    notifyListeners();
  }

  clearCart() {
    var user = _auth.currentUser;
    if (user == null) {
      _cart.clear();
      notifyListeners();
      return;
    }
    _cart.clear();
    databaseServices.updateCart(_cart, user.uid);
    notifyListeners();
  }

  void reinitialize() {
    _cart = Cart();
    listenToCart();
  }
}
