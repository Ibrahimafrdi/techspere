import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/utils/icon_utils.dart';
import 'package:flutter/material.dart';

class AddressFormDialogDesktop extends StatefulWidget {
  final Address? addressToEdit;
  const AddressFormDialogDesktop({Key? key, this.addressToEdit}) : super(key: key);

  @override
  State<AddressFormDialogDesktop> createState() => _AddressFormDialogDesktopState();
}

class _AddressFormDialogDesktopState extends State<AddressFormDialogDesktop> {
  final TextEditingController _addressController = TextEditingController();
  String _label = homeString;

  @override
  void initState() {
    super.initState();
    if (widget.addressToEdit != null) {
      _addressController.text = widget.addressToEdit!.address ?? '';
      _label = widget.addressToEdit!.name ?? homeString;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 200, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text('Map Placeholder', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.location_on, color: primaryColor, size: 28),
              const SizedBox(height: 12),
              const Text(
                'Apartment & Flat No',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter address',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Label',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildLabelButton(homeString, Icons.home, Colors.teal),
                  const SizedBox(width: 16),
                  _buildLabelButton(workString, Icons.work, Colors.blue),
                  const SizedBox(width: 16),
                  _buildLabelButton(otherString, Icons.more_horiz, Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an address')),
                      );
                      return;
                    }
                    final address = Address(
                      name: _label,
                      address: _addressController.text.trim(),
                      // location and shippingAreaId can be added if needed
                    );
                    Navigator.pop(context, address);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Confirm Location',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelButton(String label, IconData icon, Color color) {
    final bool selected = _label == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _label = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 