import 'package:delivery_app/core/view_models/base_view_model.dart';

class AddressScreenProvider extends BaseViewModel {
  String _currentAddress = '';
  String get currentAddress => _currentAddress;
  void setCurrentAddress(String address) {
    _currentAddress = address;
    notifyListeners();
  }
}
