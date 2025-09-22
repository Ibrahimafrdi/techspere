import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:delivery_app/ui/screens/auth_screens/sign_in/signin_mobile.dart';
import 'package:delivery_app/ui/screens/checkOut_screen/chekout_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCartScreenMobile extends StatelessWidget {
  const MyCartScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, ItemsProvider>(
        builder: (context, provider, itemsProvider, child) {
          // Remove unavailable items from cart
          final unAvailableItems = provider.cart.items?.where((orderItem) {
            return !itemsProvider.items.any((item) =>
            item.id == orderItem.item?.id && (item.isAvailable ?? false));
          }).toList();
          unAvailableItems?.forEach((element) {
            provider.cart.removeItem(element);
          });
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'My Cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: provider.cart.items?.isEmpty ?? true
                      ? Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListView.builder(
                      itemCount: provider.cart.items?.length ?? 0,
                      itemBuilder: (context, index) {
                        var orderItem = provider.cart.items?[index];
                        return _buildCartItem(orderItem, provider, context);
                      },
                    ),
                  ),
                ),
                _buildBottomSection(provider, context),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Widget _buildCartItem(orderItem, CartProvider provider, context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.14,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              clipBehavior: Clip.hardEdge,
              child: orderItem?.item?.imageUrl != null
                  ? Image.network(
                orderItem?.item?.imageUrl ?? '',
                fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/macbook 14.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
              )
                  : Image.asset(
                'assets/images/macbook 14.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),

          // Content Section
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        orderItem?.item?.title ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.removeItemFromCart(orderItem);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                // Variations
                ...orderItem?.selectedVariations?.entries.map(
                      (entry) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${entry.key}: ${entry.value.join(", ")}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ) ??
                    [],

                // Addons
                if (orderItem?.selectedAddons?.isNotEmpty ?? false) ...[
                  SizedBox(height: 4),
                  Text(
                    'Add-ons: ${orderItem?.selectedAddons?.map((e) => e.name).join(", ")}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],

                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${orderItem?.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    CounterWidget(
                      count: orderItem?.quantity ?? 1,
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

  Widget _buildBottomSection(CartProvider provider, BuildContext context) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub Total',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500),
                tween: Tween<double>(
                  begin: 0,
                  end: provider.cart.subtotal ?? 0,
                ),
                builder: (context, value, child) {
                  return Text(
                    'Rs. ${value.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (!isAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(
                    //  navigateToScreen: MyCartScreenMobile(),
                    ),
                  ),
                );
              } else {
                // Proceed to checkout if authenticated
                if (provider.cart.items?.isNotEmpty ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreenMobile()),
                  );
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
