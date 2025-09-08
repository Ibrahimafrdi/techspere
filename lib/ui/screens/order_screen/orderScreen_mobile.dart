import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:delivery_app/ui/screens/order_status_screen/orderStatus_mobile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreenMobile extends StatelessWidget {
  OrderScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final activeOrders = userProvider.orders
            .where((order) =>
        order.status?.toLowerCase() ==
            pendingOrderString.toLowerCase() ||
            order.status?.toLowerCase() ==
                processingOrderString.toLowerCase() ||
            order.status?.toLowerCase() ==
                acceptedOrderString.toLowerCase() ||
            order.status?.toLowerCase() ==
                outForDeliveryOrderString.toLowerCase())
            .toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        final previousOrders = userProvider.orders
            .where((order) =>
        order.status?.toLowerCase() !=
            pendingOrderString.toLowerCase() &&
            order.status?.toLowerCase() !=
                processingOrderString.toLowerCase() &&
            order.status?.toLowerCase() !=
                acceptedOrderString.toLowerCase() &&
            order.status?.toLowerCase() !=
                outForDeliveryOrderString.toLowerCase())
            .toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'My Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: userProvider.orders.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeOrders.isNotEmpty) ...[
                    Text(
                      "Active Orders",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    ContainerList(orders: activeOrders),
                    SizedBox(height: 20),
                  ],
                  if (previousOrders.isNotEmpty) ...[
                    Text(
                      "Previous Orders",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    ContainerList(orders: previousOrders),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContainerList extends StatelessWidget {
  final List<OrderModel> orders;

  const ContainerList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final order = orders[index];
        Color itemColor;
        switch (order.status) {
          case pendingOrderString:
            itemColor = pendingOrderColor;
          case processingOrderString:
            itemColor = processingOrderColor;
          case outForDeliveryOrderString:
            itemColor = outForDeliveryOrderColor;
          case deliveredOrderString:
            itemColor = deliveredOrderColor;
          case canceledOrderString:
            itemColor = canceledOrderColor;
          case returnedOrderString:
            itemColor = returnedOrderColor;
          case rejectedOrderString:
            itemColor = rejectedOrderColor;
          default:
            itemColor = primaryColor;
        }
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: itemColor.withOpacity(0.1),
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
              SizedBox(height: 12),
              Text(
                order.createdAt != null
                    ? DateFormat('MMM dd, yyyy hh:mm a')
                    .format(order.createdAt!)
                    : '',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shopping_bag_outlined, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    '${order.items?.length ?? 0} items',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Rs ${order.total?.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderStatusScreenMobile(
                            orderId: order.id ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Track Order',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}