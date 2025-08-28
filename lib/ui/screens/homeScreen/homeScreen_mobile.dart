// ignore: file_names
import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/core/models/order_item.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:delivery_app/ui/screens/add_to_cart/addtocart_mobile.dart';
import 'package:delivery_app/ui/screens/address_screen/my_address_screen.dart';
import 'package:delivery_app/ui/screens/auth_screens/sign_in/signin_mobile.dart';
import 'package:delivery_app/ui/screens/extre_screen.dart';
import 'package:delivery_app/ui/screens/favorite_screen/favortie_mobile.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_screen_provider.dart';
import 'package:delivery_app/ui/screens/my_cart/my_cart_screen_mobile.dart';
import 'package:delivery_app/ui/screens/order_screen/orderScreen_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';

/// Mobile layout for the home screen that displays food items and categories
class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenMobileState createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

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

  void _handleAuthenticationRequired(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ItemsProvider, UserProvider, HomeScreenProvider, CartProvider>(
      builder: (context, itemsModel, userModel, homeScreenModel, cartProvider, child) {
        final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

        // Add debug prints
        print('Selected category: ${homeScreenModel.selectedCategory}');
        print('Available categories: ${itemsModel.categories.map((c) => c.id).toList()}');
        print('Items by category: ${itemsModel.itemsByCategory.keys.toList()}');

        // In your UI
        if (homeScreenModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        var list = [];
        if (homeScreenModel.searchController.text.isNotEmpty) {
          list = itemsModel.items
              .where((element) => element.title?.toLowerCase()
                  .contains(homeScreenModel.searchController.text.toLowerCase()) ?? false)
              .toList();
        } else if (homeScreenModel.selectedCategory != null) {
          list = itemsModel.itemsByCategory[homeScreenModel.selectedCategory] ?? [];
        } else if (itemsModel.categories.isNotEmpty) {
          list = itemsModel.itemsByCategory[itemsModel.categories.first.id] ?? [];
        }

        if (list.isEmpty && homeScreenModel.searchController.text.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  if (!isAuthenticated) {
                    _handleAuthenticationRequired(context);
                  } else {
                    scaffoldKey.currentState?.openDrawer();
                  }
                },
                icon: Icon(
                  isAuthenticated ? Icons.menu : Icons.account_circle_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              title: Row(
                children: const[
                  Text(
                    'TechSphere',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Container(
                  //   padding: EdgeInsets.all(4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: Icon(
                  //     Icons.notifications,
                  //     size: 16,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyCartScreenMobile()),
                    );
                  },
                  child: badges.Badge(
                    badgeContent: Text(
                      '${cartProvider.cart.items?.length ?? 0}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: primaryColor,
                    ),
                    showBadge: (cartProvider.cart.items?.isNotEmpty ?? false),
                    child: Icon(
                      Icons.shopping_cart_checkout_outlined,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
            drawer: isAuthenticated ? _homeDrawer(userModel, context, homeScreenModel) : null,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  // Container(
                  //   width: double.infinity,
                  //   margin: EdgeInsets.all(16),
                  //   padding: EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [Colors.blue.shade400, Colors.blue.shade600],
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //     ),
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Welcome, Tech Enthusiast!',
                  //         style: TextStyle(
                  //           fontSize: 24,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       SizedBox(height: 8),
                  //       Text(
                  //         'Discover the latest and greatest gadgets, devices,\nand tech innovations just for you.',
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: Colors.white.withOpacity(0.9),
                  //         ),
                  //       ),
                  //       SizedBox(height: 16),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           // Start exploring action
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.white,
                  //           foregroundColor: Colors.blue.shade600,
                  //           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25),
                  //           ),
                  //         ),
                  //         child: Text(
                  //           'Start Exploring',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: homeScreenModel.searchController,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        homeScreenModel.search(value);
                      },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        hintText: 'Search your favorite tech products',
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Quick Categories Section
                  if (homeScreenModel.searchController.text.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Quick Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: itemsModel.categories.length,
                        itemBuilder: (context, index) {
                          final category = itemsModel.categories[index];
                          final isSelected = homeScreenModel.selectedCategory == category.id;
                          
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Device Finder screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceFinderScreen(
                                    categoryId: category.id!,
                                    categoryName: category.name!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category.name ?? ''),
                                      color: isSelected ? Colors.blue : Colors.grey[600],
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    category.name ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? Colors.blue : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                  ],

                  // Personalized Picks Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      homeScreenModel.searchController.text.isEmpty 
                          ? 'Personalized Picks'
                          : 'Search Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Items Grid
                  list.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var item = list[index];
                              return buildItemCard(item, context, itemsModel, cartProvider);
                            },
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No items found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'smartphones':
      case 'phone':
      case 'mobile':
        return Icons.smartphone;
      case 'laptops':
      case 'laptop':
        return Icons.laptop_mac;
      case 'wearables':
      case 'watch':
      case 'smartwatch':
        return Icons.watch;
      case 'headphones':
      case 'audio':
        return Icons.headphones;
      case 'tablets':
      case 'tablet':
        return Icons.tablet_mac;
      case 'gaming':
      case 'games':
        return Icons.sports_esports;
      case 'accessories':
        return Icons.cable;
      default:
        return Icons.devices;
    }
  }

  // Updated Card builder for grid layout
  Widget buildItemCard(Item item, BuildContext context, ItemsProvider itemsModel, CartProvider cartProvider) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreenMobile(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Favorite Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Hero(
                    tag: 'image_${item.id}',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/macbook 14.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        itemsModel.toggleFavorite(item);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          itemsModel.isFavorite(item) ? Icons.favorite : Icons.favorite_border,
                          color: itemsModel.isFavorite(item) ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Hero(
                      tag: 'title_${item.id}',
                      child: Text(
                        item.title ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    SizedBox(height: 4),
                    
                    // Description (shortened for grid)
                    Text(
                      item.description ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),

                    // Price and Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'price_${item.id}',
                                child: Text(
                                  'Rs. ${item.price?.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (item.variations?.any((element) => element.isPrimary ?? false) ?? false)
                                Text(
                                  'Starting price',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        // Add to Cart Button
                        Hero(
                          tag: 'button_${item.id}',
                          child: cartProvider.cart.items?.any((orderItem) => orderItem.item?.id == item.id) ?? false
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
                              : GestureDetector(
                                  onTap: () {
                                    if ((item.variations?.isEmpty ?? true) && (item.addons?.isEmpty ?? true)) {
                                      cartProvider.addItemToCart(
                                        OrderItem(
                                          item: item,
                                          quantity: 1,
                                          selectedVariations: {},
                                          selectedAddons: [],
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailScreenMobile(item: item),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the existing drawer and dialog widgets unchanged
_homeDrawer(UserProvider userProvider, BuildContext context, HomeScreenProvider homeScreenProvider) {
  return Drawer(
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userProvider.appUser.name ?? "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  userProvider.appUser.phone ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_note_sharp,
                    color: primaryColor,
                    size: 25,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _EditNameDialog(
                        initialName: userProvider.appUser.name ?? "",
                        onSave: (newName) {
                          userProvider.updateUserName(newName);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _DrawerItem(
            title: 'My Orders',
            icon: Icons.lunch_dining_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderScreenMobile()),
            ),
          ),
          _DrawerItem(
            title: 'My Addresses',
            icon: Icons.location_city_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAddressesScreen()),
            ),
          ),
          _DrawerItem(
            title: 'My Favorites',
            icon: Icons.favorite_border,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreenMobile()),
            ),
          ),
          Spacer(),
          _DrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await homeScreenProvider.logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MyApp(),
                                ),
                                (_) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            ),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(icon, size: 25),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

class _EditNameDialog extends StatefulWidget {
  final String initialName;
  final Function(String) onSave;

  const _EditNameDialog({
    required this.initialName,
    required this.onSave,
  });

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Name'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: 'Enter your name',
          border: OutlineInputBorder(),
        ),
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.trim().isNotEmpty) {
              widget.onSave(_nameController.text.trim());
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}