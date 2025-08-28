import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  String? name;
  LatLng? location;
  String? address;
  String? shippingAreaId;

  Address({
    this.name,
    this.location,
    this.address,
    this.shippingAreaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
      'address': address,
      'shippingAreaId': shippingAreaId,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : null,
      address: json['address'],
      shippingAreaId: json['shippingAreaId'],
    );
  }
}
