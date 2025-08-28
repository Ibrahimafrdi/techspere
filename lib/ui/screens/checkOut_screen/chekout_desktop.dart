
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/ui/screens/address_screen/address_form_dialog_desktop.dart';
import 'package:delivery_app/ui/screens/checkOut_screen/checkout_screen_provider.dart';
import 'package:delivery_app/ui/screens/order_sucess/orderSucess_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:delivery_app/core/models/address.dart';

class CheckoutScreenDesktop extends StatelessWidget {
  const CheckoutScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CheckoutScreenProvider(),
      child: Consumer3<CartProvider, CheckoutScreenProvider, UserProvider>(
        builder: (context, cartProvider, checkoutProvider, userProvider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Address and Delivery Time
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAddressSection(context, userProvider, checkoutProvider),
                              SizedBox(height: 24),
                              //_buildDeliveryTime(checkoutProvider),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      // Right Column: Cart Summary, Coupon, Order Summary, Place Order
                      Expanded(
                        flex: 4,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCartSummaryTabs(),
                                  SizedBox(height: 16),
                                  _buildOrderItems(cartProvider),
                                  SizedBox(height: 16),
                                  _buildCouponSection(),
                                  SizedBox(height: 16),
                                  _buildOrderSummary(cartProvider, context),
                                  SizedBox(height: 16),
                                  _buildPlaceOrderButton(context, checkoutProvider, cartProvider),
                                  SizedBox(height: 24),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context, UserProvider userProvider, CheckoutScreenProvider checkoutProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery Address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () async {
                  final newAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressFormDialogDesktop(),
                    ),
                  );
                  if (newAddress != null) {
                    userProvider.addAddress(newAddress);
                    checkoutProvider.setSelectedAddress(newAddress);
                  }
                },
                icon: Icon(Icons.add, color: Colors.orange),
                label: Text('Add', style: TextStyle(color: Colors.orange)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: userProvider.addresses.map((address) {
              final isSelected = checkoutProvider.selectedAddress == address;
              return GestureDetector(
                onTap: () => checkoutProvider.setSelectedAddress(address),
                child: Container(
                  width: 260,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange.withOpacity(0.08) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.black12,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Radio<Address>(
                            value: address,
                            groupValue: checkoutProvider.selectedAddress,
                            onChanged: (val) => checkoutProvider.setSelectedAddress(val!),
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        address.address ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget _buildDeliveryTime(CheckoutScreenProvider checkoutProvider) {
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.black12),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Preferred Time Frame For Delivery",
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //         SizedBox(height: 12),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: RadioListTile<bool>(
  //                 value: true,
  //                 groupValue: checkoutProvider.isNow,
  //                 onChanged: (val) {
  //                   checkoutProvider.setIsNow(val ?? true);
  //                 },
  //                 title: Text("Now"),
  //                 subtitle: Text("30 minutes"),
  //                 activeColor: Colors.orange,
  //               ),
  //             ),
  //             Expanded(
  //               child: RadioListTile<bool>(
  //                 value: false,
  //                 groupValue: checkoutProvider.isNow,
  //                 onChanged: (val) {
  //                   checkoutProvider.setIsNow(val ?? true);
  //                 },
  //                 title: Text("Schedule for later"),
  //                 subtitle: Text("Choose a time"),
  //                 activeColor: Colors.orange,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCartSummaryTabs() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Delivery',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // SizedBox(width: 12),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.grey[200],
        //     borderRadius: BorderRadius.circular(24),
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        //   child: Text(
        //     'Takeaway',
        //     style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOrderItems(CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...((cartProvider.cart.items ?? []).asMap().entries.map((entry) {
            final orderItem = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: orderItem.item?.imageUrl != null
                        ? Image.network(orderItem.item!.imageUrl!, fit: BoxFit.cover)
                        : Image.asset('assets/images/wings.png.png', fit: BoxFit.cover),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderItem.item?.title ?? "",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (orderItem.selectedVariations?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              orderItem.selectedVariations?.entries.map((e) => '${e.key}: ${e.value.join(", ") }').join(", ") ?? '',
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        SizedBox(height: 4),
                        Text(
                          'Rs. ${orderItem.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('x${orderItem.quantity}', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          })).toList(),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text('Select Offer/Apply Coupon\nGet discount with your order', style: TextStyle(fontSize: 15)),
          ),
          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider, BuildContext context) {
    final subtotal = cartProvider.cart.subtotal ?? 0.0;
    final deliveryCharge = Provider.of<CheckoutScreenProvider>(context).selectedShippingArea?.deliveryCharge ?? 0.0;
    final total = subtotal + deliveryCharge;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', 'Rs. ${subtotal.toStringAsFixed(2)}'),
          _summaryRow('Discount', 'Rs. 0.00'),
          _summaryRow('Delivery Charge', 'Rs. ${deliveryCharge.toStringAsFixed(2)}', valueColor: Colors.green),
          Divider(),
          _summaryRow('Total', 'Rs. ${total.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 16, color: valueColor, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context, CheckoutScreenProvider checkoutProvider, CartProvider cartProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (checkoutProvider.selectedAddress == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a delivery address')),
            );
            return;
          }
          await checkoutProvider.createOrder(cartProvider);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderSuccessScreenDesktop()),
          );
          cartProvider.clearCart();
        },
        child: Text(
          'Place Order',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
