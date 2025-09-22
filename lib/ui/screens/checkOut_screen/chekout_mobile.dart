import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/utils/icon_utils.dart';
import 'package:delivery_app/ui/custom_widgets/custom_text_field.dart';
import 'package:delivery_app/ui/screens/checkOut_screen/checkout_screen_provider.dart';
import 'package:delivery_app/ui/screens/order_sucess/orderSucess_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../address_screen/address_selection/address_selection_screen.dart';

class CheckoutScreenMobile extends StatelessWidget {
  const CheckoutScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CheckoutScreenProvider(),
      child: Consumer3<CartProvider, CheckoutScreenProvider, UserProvider>(
          builder:
              (context, cartProvider, checkoutProvider, userProvider, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Checkout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDeliveryDetails(
                          checkoutProvider, userProvider, context),
                      _buildDeliveryAddress(
                          checkoutProvider, userProvider, context),
                      _buildOrderItems(cartProvider),
                      _buildOrderSummary(cartProvider, context),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          // Validate inputs
                          if (checkoutProvider.nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please enter your full name')),
                            );
                            return;
                          }

                          if (checkoutProvider.phoneController.text.length != 11) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Phone number must be exactly 11 digits')),
                            );
                            return;
                          }

                          if (checkoutProvider.selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Please select a delivery address')),
                            );
                            return;
                          }

                          await checkoutProvider.createOrder(cartProvider);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderSuccessScreenMobile()),
                          );
                          cartProvider.clearCart();
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Place Order",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildDeliveryDetails(CheckoutScreenProvider checkoutProvider,
      UserProvider userProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          CustomTextField(
            labelText: "Full Name",
            hintText: "Full Name",
            textAlign: TextAlign.start,
            controller: checkoutProvider.nameController,
          ),
          SizedBox(height: 12),
          Row(
            children: [
            
 
              Expanded(
                child: CustomTextField(
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  textAlign: TextAlign.start,
                  controller: checkoutProvider.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(CheckoutScreenProvider checkoutProvider,
      UserProvider userProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: checkoutProvider.selectedAddress != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconUtils.getAddressTypeIcon(
                            checkoutProvider.selectedAddress!.name ?? ''),
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${checkoutProvider.selectedAddress!.address}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressSelectionScreen(),
                    ),
                  );
                  if (selectedAddress != null) {
                    checkoutProvider.setSelectedAddress(selectedAddress);
                  }
                },
                child: Text(
                  checkoutProvider.selectedAddress != null
                      ? 'Change'
                      : 'Select',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Text(
              "Select delivery address",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final selectedAddress = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressSelectionScreen(),
                ),
              );
              if (selectedAddress != null) {
                checkoutProvider.setSelectedAddress(selectedAddress);
              }
            },
            child: Text(
              checkoutProvider.selectedAddress != null
                  ? 'Change'
                  : 'Select',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Items",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Column(
            children: (cartProvider.cart.items?.asMap().entries.map((entry) {
              final orderItem = entry.value;
              final isNotLast =
                  entry.key < (cartProvider.cart.items?.length ?? 1) - 1;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: isNotLast ? 6 : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: orderItem.item?.imageUrl != null
                              ? Image.network(
                            orderItem.item!.imageUrl!,
                            fit: BoxFit.cover,   errorBuilder: (context, error, stackTrace) {
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
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderItem.item?.title ?? "",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (orderItem
                                  .selectedVariations?.isNotEmpty ??
                                  false) ...[
                                SizedBox(height: 8),
                                Text(
                                  "Variations: ${orderItem.selectedVariations?.entries.map((entry) => '${entry.key}: ${entry.value.join(", ")}').join(", ")}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${orderItem.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                       color: Color(0xFF4A90E2),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${orderItem.quantity}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isNotLast) Divider(thickness: 1),
                  SizedBox(height: 6),
                ],
              );
            }).toList() ??
                []),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider, context) {
    final subtotal = cartProvider.cart.subtotal ?? 0.0;
    final deliveryCharge = Provider.of<CheckoutScreenProvider>(context)
        .selectedShippingArea
        ?.deliveryCharge ??
        0.0;
    final total = subtotal + deliveryCharge;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Spacer(),
              Text(
                'Rs. ${subtotal.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Delivery Charges',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Spacer(),
              Text(
                'Rs. ${deliveryCharge.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Text(
                'Rs. ${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}