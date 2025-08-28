import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/models/order_item.dart';

class OrderModel {
  String? id;
  String? userId;
  String? riderId;
  String? userName;
  String? userPhone;
  List<OrderItem>? items;
  double? subtotal;
  double? discount;
  double? deliveryCharges;
  double? total;
  String? status;
  Duration? estimatedDuration;
  DateTime? createdAt;
  DateTime? processedAt;
  Address? deliveryAddress;

  OrderModel({
    this.id,
    this.userId,
    this.riderId,
    this.userName,
    this.userPhone,
    this.items,
    this.subtotal,
    this.discount,
    this.deliveryCharges,
    this.total,
    this.status,
    this.estimatedDuration,
    this.createdAt,
    this.processedAt,
    this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, id) {
    return OrderModel(
      id: id,
      userId: json['userId'],
      riderId: json['riderId'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal']?.toDouble(),
      discount: json['discount']?.toDouble(),
      deliveryCharges: json['deliveryCharges']?.toDouble(),
      total: json['total']?.toDouble(),
      status: json['status'],
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(minutes: json['estimatedDuration'] as int)
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      deliveryAddress: json['deliveryAddress'] != null
          ? Address.fromJson(json['deliveryAddress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'riderId': riderId,
      'userName': userName,
      'userPhone': userPhone,
      'items': items?.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryCharges': deliveryCharges,
      'total': total,
      'status': status,
      'estimatedDuration': estimatedDuration?.inMinutes,
      'createdAt': createdAt?.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'deliveryAddress': deliveryAddress?.toJson(),
    };
  }

  void calculateTotals() {
    subtotal =
        items?.fold<double>(0, (sum, item) => sum + (item.totalPrice ?? 0)) ??
            0;
    total = (subtotal ?? 0) - (discount ?? 0) + (deliveryCharges ?? 0);
  }
}
