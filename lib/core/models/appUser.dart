import 'package:delivery_app/core/models/address.dart';

class AppUser {
  String? id;
  String? name;
  String? phone;
  List<Address>? addresses;
  bool isAnonymous;
  String? email;

  // Add these for phone verification
  String? verificationId;
  String? smsCode;

  AppUser({
    this.id,
    this.name,
    this.phone,
    this.addresses,
    this.isAnonymous = false,
    this.verificationId,
    this.smsCode,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'addresses': addresses?.map((address) => address.toJson()).toList(),
      'isAnonymous': isAnonymous,
      'verificationId': verificationId,
      'smsCode': smsCode,
      'email': email,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
              .map((address) =>
                  Address.fromJson(address as Map<String, dynamic>))
              .toList()
          : [],
      isAnonymous: json['isAnonymous'] ?? false,
      verificationId: json['verificationId'],
      smsCode: json['smsCode'],
    );
  }
}
