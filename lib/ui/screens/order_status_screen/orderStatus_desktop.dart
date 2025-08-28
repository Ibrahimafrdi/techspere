import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderStatusDesktop extends StatelessWidget {
  final String orderId;
  const OrderStatusDesktop({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final order = userProvider.orders.firstWhere((o) => o.id == orderId);
      int activeStep = _getActiveStep(order.status);
      return Scaffold(
        backgroundColor: primaryColor.withOpacity(0.03),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Order Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1100),
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final panelHeight = constraints.maxHeight > 0 ? constraints.maxHeight : MediaQuery.of(context).size.height - 120;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Panel: Order Info
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: panelHeight,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _OrderInfoCard(order: order, activeStep: activeStep),
                                SizedBox(height: 20),
                                _AddressCard(order: order),
                                SizedBox(height: 20),
                                _PaymentInfoCard(order: order),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      // Right Panel: Items & Summary
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: panelHeight,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _OrderItemsCard(order: order),
                                SizedBox(height: 20),
                                _PriceSummaryCard(order: order),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Stacked layout for smaller screens
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _OrderInfoCard(order: order, activeStep: activeStep),
                        SizedBox(height: 20),
                        _AddressCard(order: order),
                        SizedBox(height: 20),
                        _PaymentInfoCard(order: order),
                        SizedBox(height: 20),
                        _OrderItemsCard(order: order),
                        SizedBox(height: 20),
                        _PriceSummaryCard(order: order),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }

  int _getActiveStep(String? status) {
    switch (status) {
      case pendingOrderString:
        return 0;
      case acceptedOrderString:
        return 1;
      case processingOrderString:
        return 2;
      case outForDeliveryOrderString:
        return 3;
      case deliveredOrderString:
        return 4;
      default:
        return 0;
    }
  }
}

class _OrderInfoCard extends StatelessWidget {
  final OrderModel order;
  final int activeStep;
  const _OrderInfoCard({required this.order, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Order ID: ', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                SelectableText('#${order.id?.substring(0, 8) ?? ''}', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                Spacer(),
                Text(DateFormat('hh:mm a, dd-MM-yyyy').format(order.createdAt ?? DateTime.now()), style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Order Type: ', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                Text(order.deliveryAddress != null ? 'Delivery' : 'Takeaway', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            if (order.estimatedDuration != null) ...[
              SizedBox(height: 16),
              Text('Estimated delivery time', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
              SizedBox(height: 4),
              Text('${order.estimatedDuration!.inMinutes} min', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
            //SizedBox(height: 16),
            // Center(
            //   child: Image.asset('assets/images/delivery.png', height: 60, fit: BoxFit.contain),
            // ),
            SizedBox(height: 12),
            Center(
              child: Text('The chef is preparing your food.', style: TextStyle(color: Colors.grey[700], fontSize: 15)),
            ),
            SizedBox(height: 24),
            _OrderStepper(activeStep: activeStep),
          ],
        ),
      ),
    );
  }
}

class _OrderStepper extends StatelessWidget {
  final int activeStep;
  const _OrderStepper({required this.activeStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Order Placed',
      'Order Accept',
      'Order Preparing',
      'Out For Delivery',
      'Order Delivered',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (i) {
        final isActive = i <= activeStep;
        return Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isActive ? primaryColor : Colors.grey[300],
              child: Icon(Icons.check, color: Colors.white, size: 16),
            ),
            SizedBox(height: 6),
            Text(
              steps[i],
              style: TextStyle(
                fontSize: 12,
                color: isActive ? primaryColor : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final OrderModel order;
  const _AddressCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
            SizedBox(height: 8),
            Text(order.deliveryAddress?.address ?? '-', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  final OrderModel order;
  const _PaymentInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
            SizedBox(height: 8),
            Text('Method: N/A', style: TextStyle(fontSize: 15)),
            SizedBox(height: 4),
            Row(
              children: const [
                Text('Status: ', style: TextStyle(fontSize: 15)),
                Text('Unpaid', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text('Pay Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  final OrderModel order;
  const _OrderItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor)),
            SizedBox(height: 16),
            ...?order.items?.map((item) => Padding(
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
                    child: item.item?.imageUrl != null
                        ? Image.network(item.item!.imageUrl!, fit: BoxFit.cover)
                        : Image.asset('assets/images/wings.png.png', fit: BoxFit.cover),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.item?.title ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        if (item.selectedVariations?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Variations: ${item.selectedVariations?.entries.map((e) => '${e.key}: ${e.value.join(", ")}').join(", ")}',
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rs. ${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                            Text('Qty: ${item.quantity}', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _PriceSummaryCard extends StatelessWidget {
  final OrderModel order;
  const _PriceSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _SummaryRow(title: 'Subtotal', value: 'Rs ${order.subtotal?.toStringAsFixed(0) ?? '0'}'),
            SizedBox(height: 12),
            _SummaryRow(title: 'Discount', value: 'Rs ${order.discount?.toStringAsFixed(0) ?? '0'}'),
            SizedBox(height: 12),
            _SummaryRow(title: 'Delivery Charge', value: order.deliveryCharges != null && (order.deliveryCharges ?? 0) > 0 ? 'Rs ${order.deliveryCharges?.toStringAsFixed(0) ?? '0'}' : 'FREE'),
            Divider(height: 32),
            _SummaryRow(title: 'Total', value: 'Rs ${order.total?.toStringAsFixed(0) ?? '0'}', isBold: true),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  const _SummaryRow({required this.title, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: isBold ? 18 : 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: isBold ? 18 : 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
