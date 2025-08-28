import 'package:delivery_app/core/models/category.dart';
import 'package:delivery_app/core/models/favorites.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemsProvider extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseServices _databaseServices = DatabaseServices();

  // Grouped items by category
  Map<String, List<Item>> _itemsByCategory = {};
  Map<String, List<Item>> get itemsByCategory => _itemsByCategory;

  void _groupItemsByCategory() {
    _itemsByCategory = {};
    for (var item in _items) {
      if (item.categoryId != null) {
        if (!_itemsByCategory.containsKey(item.categoryId)) {
          _itemsByCategory[item.categoryId!] = [];
        }
        _itemsByCategory[item.categoryId]!.add(item);
      }
    }
    notifyListeners();
  }

  // items
  List<Item> _items = [];
  List<Item> get items => _items;

  // categories
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // User favorites
  List<Item> _favorites = [];
  List<Item> get favorites => _favorites;

  ItemsProvider() {
    listenToCategories();
    listenToItems();
    listenToFavorites();
  }

  listenToCategories() {
    Stream<List<Category>> categoriesStream =
        _databaseServices.getCategoriesStream();
    categoriesStream.listen((categories) {
      _categories =
          categories.where((category) => category.isAvailable ?? true).toList();
      notifyListeners();
    });
  }

  listenToItems() {
    Stream<List<Item>> itemsStream = _databaseServices.getItemsStream();
    itemsStream.listen((items) {
      print(items);
      _items = items.where((item) => item.isAvailable == true).toList();
      _groupItemsByCategory();
      notifyListeners();
    });
  }

  listenToFavorites() {
    var userId = _auth.currentUser?.uid;
    if (userId != null) {
      Stream<Favorites?> favoritesStream =
          _databaseServices.getFavorites(userId);
      favoritesStream.listen(
        (favorite) {
          if (favorite != null && favorite.itemIds != null) {
            _favorites = favorite.itemIds!
                .map((id) => _items.firstWhere(
                      (item) => item.id == id && (item.isAvailable ?? true),
                      orElse: () => Item(),
                    ))
                .where((item) => item.id != null)
                .toList();
            notifyListeners();
          } else {
            _favorites = [];
            notifyListeners();
          }
        },
      );
    }
  }

  Future<void> toggleFavorite(Item item) async {
    var userId = _auth.currentUser?.uid;
    if (userId == null) return;

    if (_favorites.contains(item)) {
      _favorites.remove(item);
    } else {
      _favorites.add(item);
    }
    notifyListeners();

    // Update favorites in database
    await _databaseServices.updateFavorites(
      Favorites(
        userId: userId,
        itemIds: _favorites.map((item) => item.id!).toList(),
      ),
      userId,
    );
  }

  bool isFavorite(Item item) {
    return _favorites.contains(item);
  }

  void reinitialize() {
    _itemsByCategory = {};
    _items = [];
    _categories = [];
    _favorites = [];
    listenToCategories();
    listenToItems();
    listenToFavorites();
  }
}
