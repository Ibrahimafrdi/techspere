import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/models/appUser.dart';
import 'package:delivery_app/core/models/cart.dart';
import 'package:delivery_app/core/models/category.dart';
import 'package:delivery_app/core/models/favorites.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:delivery_app/core/constant/collection_identifiers.dart';
import 'package:delivery_app/core/models/shipping.dart';

class DatabaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser(AppUser user) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      // You might want to rethrow the error or handle it in a specific way
      throw Exception('Failed to create user');
    }
  }

  Future<AppUser?> getUser(String id) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(id)
          .get();
      if (snapshot.data() != null) {
        AppUser appUser = AppUser.fromJson(snapshot.data()!);
        return appUser;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Stream<AppUser> getUserStream(String userId) {
    try {
      return firestore
          .collection(usersCollection)
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return AppUser.fromJson(snapshot.data() as Map<String, dynamic>);
        } else {
          throw Exception('User not found');
        }
      });
    } catch (e) {
      print('Error getting user: $e');
      // You might want to return an empty stream or rethrow the exception
      return Stream.error(Exception('Failed to get user'));
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String userId) async {
    await firestore.collection(usersCollection).doc(userId).delete();
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      final String orderId = await getNextOrderId();
      order.id = orderId;
      await firestore.collection(ordersCollection).doc(orderId).set(order.toJson());
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order');
    }
  }

  Future<OrderModel> getOrder(String orderId) async {
    DocumentSnapshot orderSnapshot =
        await firestore.collection(ordersCollection).doc(orderId).get();
    return OrderModel.fromJson(
        orderSnapshot.data() as Map<String, dynamic>, orderSnapshot.id);
  }

  Future<void> updateOrder(OrderModel order) async {
    await firestore
        .collection(ordersCollection)
        .doc(order.id)
        .update(order.toJson());
  }

  Future<void> deleteOrder(String orderId) async {
    await firestore.collection(ordersCollection).doc(orderId).delete();
  }

  Stream<List<OrderModel>> getOrdersByUserId(String userId) {
    return firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<String> getNextOrderId() async {
    try {
      final counterRef = firestore.collection('counters').doc('orders');
      final counterDoc = await counterRef.get();

      if (!counterDoc.exists) {
        // Initialize counter if it doesn't exist
        await counterRef.set({'last_id': 1});
        return '1';
      }

      final lastId = counterDoc.data()?['last_id'] ?? 0;
      final nextId = lastId + 1;

      // Update the counter
      await counterRef.update({'last_id': nextId});

      return nextId.toString();
    } catch (e) {
      print('Error getting next sale ID: $e');
      throw e;
    }
  }

  Stream<Favorites?> getFavorites(String userId) {
    return firestore
        .collection(favoritesCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Favorites.fromJson(snapshot.data()!);
      }
      return Favorites(userId: userId, itemIds: []);
    });
  }

  Future<void> updateFavorites(Favorites favorites, String userId) async {
    await firestore
        .collection(favoritesCollection)
        .doc(userId)
        .set(favorites.toJson());
  }

  Stream<List<Item>> getItemsStream() {
    return firestore.collection(itemsCollection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) =>
                Item.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<Category>> getCategoriesStream() {
    try {
      return firestore.collection(categoriesCollection).snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => Category.fromJson(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList(),
          );
    } catch (e) {
      print('Error getting categories: $e');
      return Stream.error(Exception('Failed to get categories'));
    }
  }

  Stream<Cart> getCartStream(String userId) {
    return firestore.collection(cartCollection).doc(userId).snapshots().map(
      (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          return Cart.fromJson(snapshot.data()!);
        }
        // Return empty cart if document doesn't exist or is null
        return Cart();
      },
    );
  }

  Future<void> updateCart(Cart cart, String userId) async {
    await firestore.collection(cartCollection).doc(userId).set(cart.toJson());
  }

  Future<void> transferUserData(String oldUserId, String newUserId) async {
    // Transfer cart
    Cart? oldCart = await getCartStream(oldUserId).first;
    if (oldCart != null) {
      await updateCart(oldCart, newUserId);
      await firestore.collection(cartCollection).doc(oldUserId).delete();
    }

    // Transfer favorites
    Favorites? oldFavorites = await getFavorites(oldUserId).first;
    if (oldFavorites != null) {
      await updateFavorites(oldFavorites, newUserId);
      await firestore.collection(favoritesCollection).doc(oldUserId).delete();
    }

    // Transfer orders
    List<OrderModel> oldOrders = await getOrdersByUserId(oldUserId).first;
    for (var order in oldOrders) {
      order.userId = newUserId;
      await createOrder(order);
    }

    // Delete old user data
    await deleteUser(oldUserId);
  }

  Future<Shipping> getShippingArea(String shippingAreaId) async {
    DocumentSnapshot shippingAreaSnapshot = await firestore
        .collection(shippingsCollection)
        .doc(shippingAreaId)
        .get();
    return Shipping.fromJson(
        shippingAreaSnapshot.data() as Map<String, dynamic>,
        shippingAreaSnapshot.id);
  }
}
