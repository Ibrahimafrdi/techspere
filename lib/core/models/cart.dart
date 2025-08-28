import 'package:delivery_app/core/models/order_item.dart';

class Cart {
  String? userId;
  List<OrderItem>? items;
  double? subtotal;

  Cart({this.userId, this.items}) {
    calculateSubtotal();
  }

  Cart.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }
    calculateSubtotal();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = subtotal;
    return data;
  }

  void calculateSubtotal() {
    subtotal =
        items?.fold(0, (sum, item) => (sum ?? 0) + (item.totalPrice)) ?? 0;
  }

  void addItem(OrderItem item) {
    items ??= [];
    items!.add(item);
    calculateSubtotal();
  }

  void removeItem(OrderItem item) {
    items?.remove(item);
    calculateSubtotal();
  }

  void updateItemQuantity(OrderItem item, int newQuantity) {
    final index = items?.indexWhere((i) =>
            i.item!.id == item.item!.id &&
            i.selectedAddons == item.selectedAddons &&
            i.selectedVariations == item.selectedVariations) ??
        -1;
    if (index != -1) {
      if (newQuantity == 0) {
        items!.removeAt(index);
      } else {
        items![index].quantity = newQuantity;
      }
      calculateSubtotal();
    }
  }

  void clear() {
    items?.clear();
    calculateSubtotal();
  }
}
