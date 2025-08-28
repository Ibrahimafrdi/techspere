import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:delivery_app/ui/screens/checkOut_screen/chekout_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartDesktop extends StatelessWidget {
  final Function toggleCart;

  const MyCartDesktop({Key? key, required this.toggleCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cartWidth = MediaQuery.of(context).size.width * 0.30;

    return Consumer2<CartProvider, ItemsProvider>(
      builder: (context, cartProvider, itemsProvider, child) {
        // Remove unavailable items
        final unAvailableItems = cartProvider.cart.items?.where((orderItem) {
          return !itemsProvider.items.any((item) =>
          item.id == orderItem.item?.id && (item.isAvailable ?? false));
        }).toList();
        unAvailableItems?.forEach((element) {
          cartProvider.cart.removeItem(element);
        });

        return Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          width: cartWidth,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text('My Cart'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        toggleCart();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: cartProvider.cart.items?.isEmpty ?? true
                      ? Center(child: Text('Your cart is empty'))
                      : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: cartProvider.cart.items?.length ?? 0,
                      itemBuilder: (context, index) {
                        var orderItem = cartProvider.cart.items![index];
                        return _buildCartItem(orderItem, cartProvider);
                      },
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 500),
                        tween: Tween<double>(
                          begin: 0,
                          end: cartProvider.cart.subtotal ?? 0,
                        ),
                        builder: (context, value, child) {
                          return Text(
                            'Rs. ${value.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 322,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: TextButton(
                      child: Text(
                        "Proceed to Checkout",
                        style: const TextStyle(
                            fontFamily: 'ProximaSoft',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      onPressed: () {
                        if (cartProvider.cart.items?.isNotEmpty ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreenDesktop()),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItem(orderItem, CartProvider provider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            clipBehavior: Clip.hardEdge,
            child: orderItem?.item?.imageUrl != null
                ? Image.network(orderItem.item?.imageUrl ?? '',
                fit: BoxFit.cover)
                : Image.asset('assets/images/wings.png.png',
                fit: BoxFit.cover),
          ),
          SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and remove
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        orderItem.item?.title ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        provider.removeItemFromCart(orderItem);
                      },
                    ),
                  ],
                ),

                // Variations
                ...orderItem.selectedVariations?.entries.map((entry) {
                  return Text(
                    '${entry.key}: ${entry.value.join(", ")}',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  );
                }) ??
                    [],

                // Addons
                if (orderItem.selectedAddons?.isNotEmpty ?? false)
                  Text(
                    'Add-ons: ${orderItem.selectedAddons?.map((e) => e.name).join(", ")}',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                SizedBox(height: 6),

                // Price and counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${orderItem.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    CounterWidget(
                      count: orderItem.quantity ?? 1,
                      onChanged: (value) {
                        provider.updateItemQuantity(orderItem, value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
