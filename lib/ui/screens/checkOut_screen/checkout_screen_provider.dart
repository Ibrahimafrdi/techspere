import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/models/shipping.dart';
import 'package:delivery_app/core/services/auth_services.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/enums/view_state.dart';
import 'package:delivery_app/locator.dart';
import 'package:flutter/material.dart';

class CheckoutScreenProvider extends BaseViewModel {
  final AuthServices _authService = locator<AuthServices>();
  final DatabaseServices _databaseService = DatabaseServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Address? selectedAddress;
  Shipping? selectedShippingArea;
  CheckoutScreenProvider() {
    nameController.text = _authService.appUser.name ?? '';
    phoneController.text = _authService.appUser.phone?.substring(3) ?? '';
  }

  Future<bool> createOrder(CartProvider cartProvider) async {
    try {
      print('Creating order...');
      setState(ViewState.busy);

      final order = OrderModel(
        userId: _authService.appUser.id,
        userName: nameController.text,
        userPhone: phoneController.text,
        items: cartProvider.cart.items,
        subtotal: cartProvider.cart.subtotal,
        deliveryCharges: selectedShippingArea?.deliveryCharge ?? 0.0,
        discount: 0.0,
        status: pendingOrderString,
        createdAt: DateTime.now(),
        deliveryAddress: selectedAddress,
      );

      // Calculate totals before saving
      order.calculateTotals();
      print('Order totals calculated');
      // Save to Firebase
      await _databaseService.createOrder(order);
      print('Order saved to Firebase');

      setState(ViewState.idle);
      return true;
    } catch (e) {
      print('Error creating order: $e');
      setState(ViewState.idle);
      return false;
    }
  }

  void setSelectedAddress(Address address) async {
    selectedAddress = address;
    selectedShippingArea = await (address.shippingAreaId != null
        ? _databaseService.getShippingArea(address.shippingAreaId!)
        : null);
    notifyListeners();
  }

  void setSelectedShippingArea(Shipping shipping) {
    selectedShippingArea = shipping;
    notifyListeners();
  }
      
bool _isNow = true;
bool get isNow => _isNow;
void setIsNow(bool value) {
  _isNow = value;
  notifyListeners();
}
}
