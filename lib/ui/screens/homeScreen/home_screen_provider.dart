import 'package:delivery_app/core/view_models/base_view_model.dart';
import 'package:delivery_app/core/services/auth_services.dart';
import 'package:delivery_app/locator.dart';
import 'package:flutter/material.dart';

class HomeScreenProvider extends BaseViewModel {
  AuthServices authServices = locator<AuthServices>();
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;
  String? searchText;

  TextEditingController searchController = TextEditingController();

  // In your provider
  bool isLoading = false;



  void setSelectedCategory(String categoryId) {
    _selectedCategory = categoryId;
    print('Category set to: $categoryId'); // Debug log
    notifyListeners();
  }

  search(text) {
    text = searchText;
    notifyListeners();
  }

  logout() async {
    await authServices.signOut();
  }
}
