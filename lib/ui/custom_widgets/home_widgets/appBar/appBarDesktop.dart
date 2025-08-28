import 'package:delivery_app/ui/custom_widgets/home_widgets/cart_btn.dart';
import 'package:delivery_app/ui/custom_widgets/home_widgets/login_btn.dart';
import 'package:delivery_app/ui/screens/auth_screens/auth_screen_desktop/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/services.dart';

import '../../../../core/data_providers/cart_provider.dart';
import '../../../screens/my_cart/myCartDesktop.dart';
import '../../../screens/profile_screen/profile_screen_desktop.dart';
import '../../../../core/data_providers/user_provider.dart';

class AppBarDesktop extends StatefulWidget {
  final VoidCallback onPress;
  final VoidCallback onPres;
  final VoidCallback onProfileTap;

  const AppBarDesktop({
    Key? key,
    required this.onPress,
    required this.onPres,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  State<AppBarDesktop> createState() => _AppBarDesktopState();
}

class _AppBarDesktopState extends State<AppBarDesktop> {
  bool _isCartOpen = false;
  OverlayEntry? _profileDropdown;
  final GlobalKey _accountBtnKey = GlobalKey();

  void toggleCart() {
    setState(() {
      _isCartOpen = !_isCartOpen;
    });
  }

  void _showProfileDropdown() {
    if (_profileDropdown != null) return;
    final RenderBox button = _accountBtnKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size size = button.size;
    const double dropdownWidth = 320;
    final double screenWidth = overlay.size.width;
    double left = position.dx;
    // If dropdown would overflow right edge, shift it left
    if (left + dropdownWidth > screenWidth - 16) {
      left = screenWidth - dropdownWidth - 16; // 16px margin from right
      if (left < 16) left = 16; // 16px margin from left if too far
    }

    _profileDropdown = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeProfileDropdown,
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: position.dy + size.height + 8,
              child: Material(
                color: Colors.transparent,
                child: ProfileDropdownMenu(
                  onClose: _removeProfileDropdown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_profileDropdown!);
    // Listen for escape key
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _removeProfileDropdown() {
    _profileDropdown?.remove();
    _profileDropdown = null;
  }



  @override
  void dispose() {
    _removeProfileDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ResponsiveBuilder(
          builder: (context, sizingInformation) {
            double screenWidth = sizingInformation.screenSize.width;
            double logoPadding = screenWidth * 0.05;
            double buttonSpacing = screenWidth * 0.02;
            double searchIconPadding = screenWidth * 0.03;

            return Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: logoPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/Frame 1261155164.png",
                    height: 40,
                  ),
                  Row(
                    children: [
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final itemCount = cartProvider.cart.items?.fold<int>(0, (sum, item) => sum + (item.quantity ?? 1)) ?? 0;
                          return CartButton(
                            itemCount: itemCount,
                            onPressed: () {
                              context.read<CartProvider>().toggleCart();
                            },
                          );
                        },
                      ),
                      SizedBox(width: searchIconPadding),
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          final isAuthenticated = userProvider.appUser.id != null && userProvider.appUser.id!.isNotEmpty;
                          if (isAuthenticated) {
                            return LoginButton(
                              key: _accountBtnKey,
                              onPressed: () {
                                if (_profileDropdown == null) {
                                  _showProfileDropdown();
                                } else {
                                  _removeProfileDropdown();
                                }
                              },
                              text: 'Account',
                            );
                          } else {
                            return LoginButton(text: 'Login', onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        if (_isCartOpen)
          MyCartDesktop(
            toggleCart: toggleCart,
          ),
      ],
    );
  }

  Widget _buildMenuButton(String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}