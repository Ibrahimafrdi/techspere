import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/ui/custom_widgets/home_widgets/customFooter.dart';
import 'package:delivery_app/ui/screens/add_to_cart/addtocart_desktop.dart';
import 'package:delivery_app/ui/screens/extre_screen.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/data_providers/cart_provider.dart';
import '../../../core/data_providers/items_provider.dart';
import '../../../core/data_providers/user_provider.dart';
import '../../../core/models/order_item.dart';
import '../../custom_widgets/counter_widget.dart';
import '../my_cart/myCartDesktop.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  bool isCartOpen = false;

  void toggleCart() {
    setState(() {
      isCartOpen = !isCartOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemsModel = Provider.of<ItemsProvider>(context, listen: false);
      final homeScreenModel = Provider.of<HomeScreenProvider>(context, listen: false);
      if (itemsModel.categories.isNotEmpty) {
        homeScreenModel.setSelectedCategory(itemsModel.categories.first.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // if (user == null) {
    //   // Redirect to sign in if not authenticated
    //   return SignInDesktop();
    // }

    return Consumer4<ItemsProvider, UserProvider, HomeScreenProvider, CartProvider>(
      builder: (context, itemsModel, userModel, homeScreenModel, cartProvider, child) {
        if (homeScreenModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        // Use the selected category or default to first category id
        final selectedCategory = homeScreenModel.selectedCategory ?? (itemsModel.categories.isNotEmpty ? itemsModel.categories.first.id! : '');

        // Filter items by selected category
        final featuredItems = itemsModel.items
            .where((item) => item.categoryId == selectedCategory)
            .toList();

        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildCategoryChips(itemsModel, homeScreenModel),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Text(
                        'Menu Items',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: FeaturedItemsGrid(featuredItems: featuredItems),
                    ),
                    SizedBox(height: 122),
                    CustomFooter(),
                  ],
                ),
              ),
              if (cartProvider.isCartOpen) ...[
                Container(color: Colors.black54),
                MyCartDesktop(
                  toggleCart: cartProvider.toggleCart,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget buildCategoryChips(ItemsProvider itemsModel, HomeScreenProvider homeScreenModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        children: itemsModel.categories.map((category) {
          final selectedCategory = homeScreenModel.selectedCategory ?? itemsModel.categories.first.id!;
          final isSelected = selectedCategory == category.id;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => homeScreenModel.setSelectedCategory(category.id!),
              child: Chip(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                label: Text(
                  category.name!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? primaryColor : Colors.black,
                  ),
                ),
                side: BorderSide(
                  width: isSelected ? 1.5 : 1,
                  color: isSelected ? primaryColor : Colors.black12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FeaturedItemsGrid extends StatelessWidget {
  final List<dynamic> featuredItems;

  const FeaturedItemsGrid({required this.featuredItems, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double width = sizingInformation.screenSize.width;
        int crossAxisCount = width > 1200 ? 4 : width > 800 ? 3 : 2;
        double childAspectRatio = 0.86;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: featuredItems.length,
          itemBuilder: (context, index) {
            final item = featuredItems[index];
            return FeaturedItemCard(item: item);
          },
        );
      },
    );
  }
}
class FeaturedItemCard extends StatelessWidget {
  final dynamic item;

  const FeaturedItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    bool isInCart = cartProvider.cart.items?.any((orderItem) => orderItem.item?.id == item.id) ?? false;

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Implement onTap if needed
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: Image.asset(
                    item.imageUrl ?? 'assets/images/wings.png.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.title ?? 'No title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(  // or Expanded if parent height is fixed
                child: Text(
                  item.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'price',
                      child: Text(
                        '  Rs. ${item.price?.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // SizedBox(width: 10),
                    Spacer(),
                    Hero(
                      tag: 'button_${item.id}',
                      child: isInCart
                          ? CounterWidget(
                        count: cartProvider.cart.items!
                            .firstWhere((orderItem) => orderItem.item?.id == item.id)
                            .quantity,
                        onChanged: (newCount) {
                          OrderItem orderItem = cartProvider.cart.items!
                              .firstWhere((orderItem) => orderItem.item?.id == item.id);
                          if (newCount == 0) {
                            cartProvider.removeItemFromCart(orderItem);
                          } else {
                            orderItem.quantity = newCount;
                            cartProvider.updateItemQuantity(orderItem, newCount);
                          }
                        },
                      )
                          : OutlinedButton(
                        onPressed: () {

                          if ((item.variations?.isEmpty ?? true) &&
                              (item.addons?.isEmpty ?? true)) {
                            cartProvider.addItemToCart(
                              OrderItem(
                                item: item,
                                quantity: 1,
                                selectedVariations: {},
                                selectedAddons: [],
                              ),
                            );
                          } else {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AddToCartScreenMobile(item: item),
                            //   ),
                            // );
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return Dialog(
                            //       insetPadding: EdgeInsets.all(90), // You can control size
                            //       backgroundColor: Colors.transparent, // For a clean overlay look
                            //       child: AddToCartScreenDesktop(item: item,), // Your custom widget
                            //     );
                            //   },
                            // );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          side: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 26,
                              color: primaryColor,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'ADD',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}