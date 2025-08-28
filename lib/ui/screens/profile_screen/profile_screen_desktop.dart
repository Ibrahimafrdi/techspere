import 'package:delivery_app/ui/screens/address_screen/address_desktop.dart';
import 'package:delivery_app/ui/screens/homeScreen/homeScreen_desktop.dart';
import 'package:delivery_app/ui/screens/order_screen/orderScreen_desktop.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/core/services/auth_services.dart';
class ProfileDropdownMenu extends StatelessWidget {
  final VoidCallback? onClose;
  const ProfileDropdownMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 420,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Kabir Afridi", // Replace with dynamic user name
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "kabir@gmail.com", // Replace with dynamic email
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "\$120.00", // Replace with dynamic balance
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 18),
            const Divider(),
            _ProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              text: 'My Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreenDesktop(),
                  ),
                );
                if (onClose != null) onClose!();
              },
            ),
            _ProfileMenuItem(
              icon: Icons.edit_outlined,
              text: 'Edit Profile',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.home_outlined,
              text: 'Address',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreenDesktop(),
                  ),
                );
                if (onClose != null) onClose!();
              },
            ),
            _ProfileMenuItem(
              icon: Icons.lock_outline,
              text: 'Change Password',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await locator<AuthServices>().signOut();
                  if (onClose != null) onClose!();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreenDesktop()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ProfileMenuItem({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            SizedBox(width: 18),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
