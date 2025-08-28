import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/address.dart';
import 'package:delivery_app/core/utils/icon_utils.dart';
import 'package:delivery_app/ui/screens/address_screen/address_mobile.dart';
import 'package:delivery_app/ui/screens/address_screen/address_form_dialog_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreenDesktop extends StatefulWidget {
  const AddressScreenDesktop({super.key});

  @override
  State<AddressScreenDesktop> createState() => _AddressScreenDesktopState();
}

class _AddressScreenDesktopState extends State<AddressScreenDesktop> {
  void _showAddressDialog({Address? addressToEdit}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await showDialog<Address>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddressFormDialogDesktop(addressToEdit: addressToEdit),
    );
    if (result != null) {
      if (addressToEdit != null) {
        userProvider.updateAddress(addressToEdit, result);
      } else {
        userProvider.addAddress(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddressDialog(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: userProvider.addresses.isEmpty
                    ? const Center(
                        child: Text(
                          'No addresses added yet',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 0,
                          childAspectRatio: 2.8,
                        ),
                        itemCount: userProvider.addresses.length,
                        itemBuilder: (context, index) {
                          final address = userProvider.addresses[index];
                          return _buildAddressCard(context, address, userProvider);
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address, UserProvider userProvider) {
    final type = address.name ?? otherString;
    final Color typeColor = const Color(0xFF0096A6); // blue shade for type
    final Color cardBg = const Color(0xFFF7F8FC); // very light blue/gray
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                IconUtils.getAddressTypeIcon(type),
                color: typeColor,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: typeColor,
                  ),
                ),
              ),
              Row(
                children: [
                  // Edit button
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                      onPressed: () => _showAddressDialog(addressToEdit: address),
                      tooltip: 'Edit',
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Address'),
                            content: const Text('Are you sure you want to delete this address?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  userProvider.removeAddress(address);
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      tooltip: 'Delete',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF8A8BB3), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.address ?? '',
                  style: const TextStyle(fontSize: 17, color: Color(0xFF23234B)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
