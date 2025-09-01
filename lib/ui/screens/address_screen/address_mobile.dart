import 'package:delivery_app/core/constant/collection_identifiers.dart';
import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/shipping.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/core/models/address.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressScreenMobile extends StatefulWidget {
  final Address? addressToEdit;
  const AddressScreenMobile({super.key, this.addressToEdit});

  @override
  State<AddressScreenMobile> createState() => _AddressScreenMobileState();
}

class _AddressScreenMobileState extends State<AddressScreenMobile> {
  GoogleMapController? _mapController;
  LatLng _currentLocation =
  const LatLng(34.0151, 71.5249); // Default to Peshawar
  String _currentAddress = '';
  final Location _location = Location();
  final TextEditingController _addressController = TextEditingController();
  String _addressType = homeString; // Default address type
  Shipping? selectedShipping;
  List<Shipping> shippingAreas = [];
  bool isLoadingAreas = true;

  @override
  void initState() {
    super.initState();
    loadShippingAreas();
    if (widget.addressToEdit != null) {
      // Pre-fill the form if editing
      _addressController.text = widget.addressToEdit!.address ?? '';
      _addressType = widget.addressToEdit!.name ?? homeString;
      if (widget.addressToEdit!.location != null) {
        _currentLocation = widget.addressToEdit!.location!;
      }
    }
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentLocation),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentLocation = position.target;
    });
  }

  Future<void> loadShippingAreas() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(shippingsCollection)
        .where('isAvailable', isEqualTo: true)
        .get();

    setState(() {
      shippingAreas = snapshot.docs
          .map((doc) => Shipping.fromJson(doc.data(), doc.id))
          .toList();
      isLoadingAreas = false;
    });
  }

  void _saveAddress() {
    final addressText = _addressController.text.trim();
    if (addressText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address')),
      );
      return;
    }

    if (selectedShipping == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery area')),
      );
      return;
    }

    final address = Address(
      name: _addressType,
      location: _currentLocation,
      address: addressText,
      shippingAreaId: selectedShipping?.id,
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.addressToEdit != null) {
      userProvider.updateAddress(widget.addressToEdit!, address);
    } else {
      userProvider.addAddress(address);
    }

    Navigator.pop(context);
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
            'Add Address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation,
                          zoom: 15,
                        ),
                        onMapCreated: (controller) => _mapController = controller,
                        onCameraMove: _onCameraMove,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                      ),
                    ),
                  ),
                  // Centered marker pin
                  Positioned(
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(
                          bottom: 25), // Offset to account for pin point
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              size: 30,
                              color: primaryColor,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Location button with consistent style
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.my_location, color: Colors.white),
                        onPressed: _getCurrentLocation,
                      ),
                    ),
                  ),
                  // Info card with consistent styling
                  Positioned(
                    top: 8,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                        ),
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
                              Icons.info_outline,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Move map to select location',
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
                ],
              ),
              // Bottom section with consistent styling
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Address Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShippingAreaDropdown(),
                          SizedBox(height: 16),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Complete Address',
                              hintText: 'House#, Street#, city...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon:
                              Icon(Icons.location_on, color: primaryColor),
                              labelStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9\s,#\-./()]')),
                            ],
                            onChanged: (value) {
                              final cleanedText = value.replaceAll(
                                  RegExp(r'[^a-zA-Z0-9\s,#\-./()]'), '');
                              if (value != cleanedText) {
                                _addressController.text = cleanedText;
                                _addressController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(offset: cleanedText.length),
                                    );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Save Address As',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildAddressTypeChip(homeString, Icons.home),
                                SizedBox(width: 10),
                                _buildAddressTypeChip(workString, Icons.work),
                                SizedBox(width: 10),
                                _buildAddressTypeChip(
                                    otherString, Icons.location_on),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _saveAddress,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Save Address",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddressTypeChip(String type, IconData icon) {
    final isSelected = _addressType == type;
    return GestureDetector(
      onTap: () => setState(() => _addressType = type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingAreaDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16).copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Area',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          isLoadingAreas
              ? CircularProgressIndicator()
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Shipping>(
                isExpanded: true,
                value: selectedShipping,
                hint: Text('Select delivery area'),
                dropdownColor: primaryColor,
                items: shippingAreas.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text('${area.areaName}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedShipping = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
