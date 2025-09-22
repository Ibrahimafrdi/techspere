import 'dart:async';

import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/order.dart';
import 'package:delivery_app/core/utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderStatusScreenMobile extends StatefulWidget {
  final String orderId;
  OrderStatusScreenMobile({super.key, required this.orderId});

  @override
  State<OrderStatusScreenMobile> createState() =>
      _OrderStatusScreenMobileState();
}

class _OrderStatusScreenMobileState extends State<OrderStatusScreenMobile> {
  late OrderModel orderModel;
  late int activeStep;
  Duration? remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    orderModel = Provider.of<UserProvider>(context, listen: false)
        .orders
        .firstWhere((order) => order.id == widget.orderId);
    // Map order status to stepper index
    switch (orderModel.status) {
      case pendingOrderString:
        activeStep = 0;
        break;
      case acceptedOrderString:
        activeStep = 1;
        break;
      case processingOrderString:
        activeStep = 2;
        break;
      case outForDeliveryOrderString:
        activeStep = 3;
        break;
      case deliveredOrderString:
        activeStep = 4;
        break;
      default:
        activeStep = 0;
    }

    // Calculate remaining time based on creation time and estimated duration
    if (orderModel.createdAt != null && orderModel.estimatedDuration != null) {
      final DateTime now = DateTime.now();
      final DateTime creationTime = orderModel.createdAt!;
      final DateTime? processedTime = orderModel.processedAt;
      final Duration estimatedDuration = orderModel.estimatedDuration!;
      DateTime estimatedDeliveryTime;
      if (processedTime != null && processedTime.isAfter(creationTime)) {
        estimatedDeliveryTime = processedTime.add(estimatedDuration);
      } else {
        estimatedDeliveryTime = creationTime.add(estimatedDuration);
      }

      if (now.isBefore(estimatedDeliveryTime)) {
        remainingTime = estimatedDeliveryTime.difference(now);
        _startTimer();
      } else {
        remainingTime = Duration.zero;
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime != null) {
        setState(() {
          remainingTime = remainingTime! - Duration(seconds: 1);
          if (remainingTime!.inSeconds <= 0) {
            remainingTime = Duration.zero;
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--';
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildTimeDisplay(String timeStr) {
    // Ensure timeStr has the correct format (MM:SS)
    if (timeStr.length != 5) {
      return Text(
        timeStr,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minutes
        Container(
          width: 32,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              timeStr[0],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Container(
          width: 32,
          height: 40,
          margin: EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              timeStr[1],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: primaryColor.withOpacity(0.8),
          ),
        ),
        // Seconds
        Container(
          width: 32,
          height: 40,
          margin: EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              timeStr[3],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Container(
          width: 32,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              timeStr[4],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Order Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID and Date Section
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          colors: [
                            Colors.white,
                            Colors.orange.withOpacity(0.1),
                            Colors.white,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "#${orderModel.id}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Order Date",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                orderModel.createdAt != null
                                    ? DateFormat('MMM d, yyyy • h:mm a')
                                        .format(orderModel.createdAt!)
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15),

                    // Delivery Status Section
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Estimated Delivery",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        (orderModel.status?.toLowerCase() ==
                                                    pendingOrderString
                                                        .toLowerCase() ||
                                                orderModel.status
                                                        ?.toLowerCase() ==
                                                    acceptedOrderString
                                                        .toLowerCase() ||
                                                orderModel.status
                                                        ?.toLowerCase() ==
                                                    deliveredOrderString
                                                        .toLowerCase() ||
                                                orderModel.status
                                                        ?.toLowerCase() ==
                                                    canceledOrderString
                                                        .toLowerCase() ||
                                                orderModel.status
                                                        ?.toLowerCase() ==
                                                    rejectedOrderString
                                                        .toLowerCase() ||
                                                orderModel.status
                                                        ?.toLowerCase() ==
                                                    returnedOrderString
                                                        .toLowerCase())
                                            ? Text(
                                                '--',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : _buildTimeDisplay(
                                                _formatDuration(remainingTime)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Modern Progress Indicator
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: CircularProgressIndicator(
                                        value: activeStep / 4,
                                        strokeWidth: 4,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                primaryColor),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${(activeStep / 4 * 100).toInt()}%",
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Modern Address Display
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    IconUtils.getAddressTypeIcon(
                                        orderModel.deliveryAddress?.name ?? ''),
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delivery Address",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${orderModel.deliveryAddress?.address}",
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Order Tracking Stepper
                    EasyStepper(
                      activeStep: activeStep,
                      lineStyle: LineStyle(
                        lineType: LineType.normal,
                        defaultLineColor: Colors.grey.shade200,
                        finishedLineColor: primaryColor,
                        lineThickness: 2.0,
                      ),
                      activeStepTextColor: Colors.black87,
                      finishedStepTextColor: Colors.black87,
                      enableStepTapping: false,
                      internalPadding: 20,
                      showLoadingAnimation: false,
                      stepRadius: 18,
                      showStepBorder: true,
                      borderThickness: 0,
                      activeStepBorderColor: Colors.transparent,
                      finishedStepBorderColor: Colors.transparent,
                      unreachedStepBorderColor: Colors.transparent,
                      steps: [
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 16,
                            backgroundColor: activeStep >= 0
                                ? primaryColor
                                : Colors.grey.shade100,
                            child: Icon(
                              activeStep >= 0
                                  ? Icons.task_alt
                                  : Icons.radio_button_unchecked,
                              color: activeStep >= 0
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          customTitle: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: activeStep >= 0
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                size: 18,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Order\nPlaced',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeStep >= 0
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: activeStep >= 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 16,
                            backgroundColor: activeStep >= 1
                                ? primaryColor
                                : Colors.grey.shade100,
                            child: Icon(
                              activeStep >= 1
                                  ? Icons.task_alt
                                  : Icons.radio_button_unchecked,
                              color: activeStep >= 1
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          customTitle: Column(
                            children: [
                              Icon(
                                Icons.thumb_up_outlined,
                                color: activeStep >= 1
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                size: 18,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Order\nAccepted',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeStep >= 1
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: activeStep >= 1
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 16,
                            backgroundColor: activeStep >= 2
                                ? primaryColor
                                : Colors.grey.shade100,
                            child: Icon(
                              activeStep >= 2
                                  ? Icons.task_alt
                                  : Icons.radio_button_unchecked,
                              color: activeStep >= 2
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          customTitle: Column(
                            children: [
                              Icon(
                                Icons.kitchen,
                                color: activeStep >= 2
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                size: 18,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Preparing',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeStep >= 2
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: activeStep >= 2
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 16,
                            backgroundColor: activeStep >= 3
                                ? primaryColor
                                : Colors.grey.shade100,
                            child: Icon(
                              activeStep >= 3
                                  ? Icons.task_alt
                                  : Icons.radio_button_unchecked,
                              color: activeStep >= 3
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          customTitle: Column(
                            children: [
                              Icon(
                                Icons.delivery_dining,
                                color: activeStep >= 3
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                size: 18,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'On the\nWay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeStep >= 3
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: activeStep >= 3
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 16,
                            backgroundColor: activeStep >= 4
                                ? primaryColor
                                : Colors.grey.shade100,
                            child: Icon(
                              activeStep >= 4
                                  ? Icons.task_alt
                                  : Icons.radio_button_unchecked,
                              color: activeStep >= 4
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          customTitle: Column(
                            children: [
                              Icon(
                                Icons.celebration,
                                color: activeStep >= 4
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                size: 18,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Delivered',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeStep >= 4
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: activeStep >= 4
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Order Details Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    // Items Container with more padding
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Items",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Column(
                            children: (orderModel.items
                                    ?.asMap()
                                    .entries
                                    .map((entry) {
                                  final orderItem = entry.value;
                                  final isNotLast = entry.key <
                                      (orderModel.items?.length ?? 1) - 1;

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: isNotLast ? 6 : 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.black12),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: orderItem.item?.imageUrl !=
                                                      null
                                                  ? Image.network(
                                                      orderItem.item!.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    orderItem.item?.title ?? "",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  if (orderItem
                                                          .selectedVariations
                                                          ?.isNotEmpty ??
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Rs. ${orderItem.totalPrice.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF4A90E2),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Qty: ${orderItem.quantity}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
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
                    ),

                    SizedBox(height: 10),

                    // Price Summary Container
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          PriceSummaryRow(
                            title: 'Sub Total',
                            amount:
                                'Rs ${orderModel.subtotal?.toStringAsFixed(0) ?? '0'}',
                            titleStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            amountStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          PriceSummaryRow(
                            title: 'Discount',
                            amount:
                                'Rs ${orderModel.discount?.toStringAsFixed(0) ?? '0'}',
                            titleStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                            amountStyle:
                                TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          SizedBox(height: 16),
                          PriceSummaryRow(
                            title: 'Delivery Charges',
                            amount: orderModel.deliveryCharges != null &&
                                    (orderModel.deliveryCharges ?? 0) > 0
                                ? 'Rs ${orderModel.deliveryCharges?.toStringAsFixed(0) ?? '0'} '
                                : 'FREE',
                            titleStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                            amountStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: Colors.grey.shade300),
                          ),
                          PriceSummaryRow(
                            title: 'Total Amount',
                            amount:
                                'Rs ${orderModel.total?.toStringAsFixed(0) ?? '0'}',
                            titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            amountStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Cancel Order?'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'NO',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle order cancellation
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('YES, CANCEL', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PriceSummaryRow extends StatelessWidget {
  final String title;
  final String amount;
  final TextStyle titleStyle;
  final TextStyle amountStyle;

  const PriceSummaryRow({
    required this.title,
    required this.amount,
    required this.titleStyle,
    required this.amountStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle),
        Text(amount, style: amountStyle),
      ],
    );
  }
}
