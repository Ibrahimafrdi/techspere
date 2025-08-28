import 'package:delivery_app/ui/screens/order_status_screen/orderStatus_mobile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/ui/screens/order_status_screen/orderStatus_desktop.dart';

class OrderScreenDesktop extends StatelessWidget {
  OrderScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final activeOrders = userProvider.orders
            .where((order) =>
                order.status?.toLowerCase() == pendingOrderString.toLowerCase() ||
                order.status?.toLowerCase() == processingOrderString.toLowerCase() ||
                order.status?.toLowerCase() == acceptedOrderString.toLowerCase() ||
                order.status?.toLowerCase() == outForDeliveryOrderString.toLowerCase())
            .toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        final previousOrders = userProvider.orders
            .where((order) =>
                order.status?.toLowerCase() != pendingOrderString.toLowerCase() &&
                order.status?.toLowerCase() != processingOrderString.toLowerCase() &&
                order.status?.toLowerCase() != acceptedOrderString.toLowerCase() &&
                order.status?.toLowerCase() != outForDeliveryOrderString.toLowerCase())
            .toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return Scaffold(
          backgroundColor: primaryColor.withOpacity(0.05),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: primaryColor,
            title: Text(
              'My Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
          body: userProvider.orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  const [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your orders will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 1200),
                        padding: const EdgeInsets.all(32.0),
                        child: isWide
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Active Orders Column
                                  Expanded(
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height - 180, // Adjust for app bar and padding
                                      child: SingleChildScrollView(
                                        child: OrderColumn(
                                          title: "Active Orders",
                                          orders: activeOrders,
                                          emptyText: "No active orders",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 32),
                                  // Previous Orders Column
                                  Expanded(
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height - 180, // Adjust for app bar and padding
                                      child: SingleChildScrollView(
                                        child: OrderColumn(
                                          title: "Previous Orders",
                                          orders: previousOrders,
                                          emptyText: "No previous orders",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    OrderColumn(
                                      title: "Active Orders",
                                      orders: activeOrders,
                                      emptyText: "No active orders",
                                    ),
                                    SizedBox(height: 32),
                                    OrderColumn(
                                      title: "Previous Orders",
                                      orders: previousOrders,
                                      emptyText: "No previous orders",
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class OrderColumn extends StatelessWidget {
  final String title;
  final List<OrderModel> orders;
  final String emptyText;

  const OrderColumn({
    super.key,
    required this.title,
    required this.orders,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 24),
        if (orders.isEmpty)
          Text(emptyText, style: TextStyle(color: Colors.grey)),
        ...orders.map((order) => OrderCard(order: order)).toList(),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    var itemColor;
    switch (order.status) {
      case pendingOrderString:
        itemColor = pendingOrderColor;
        break;
      case processingOrderString:
        itemColor = processingOrderColor;
        break;
      case outForDeliveryOrderString:
        itemColor = outForDeliveryOrderColor;
        break;
      case deliveredOrderString:
        itemColor = deliveredOrderColor;
        break;
      case canceledOrderString:
        itemColor = canceledOrderColor;
        break;
      case returnedOrderString:
        itemColor = returnedOrderColor;
        break;
      case rejectedOrderString:
        itemColor = rejectedOrderColor;
        break;
      default:
        itemColor = primaryColor;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: # 2${order.id?.substring(0, 8)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status ?? '',
                  style: TextStyle(
                    color: itemColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            order.createdAt != null
                ? DateFormat('hh:mm a, dd-MM-yyyy').format(order.createdAt!)
                : '',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.restaurant, color: primaryColor, size: 32),
              SizedBox(width: 10),
              Text(
                order.deliveryAddress != null ? 'Delivery' : 'Takeaway',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Total: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            '\$${order.total?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusDesktop(orderId: order.id ?? ''),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'See Details',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
