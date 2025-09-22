import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/models/order_item.dart';
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:delivery_app/ui/screens/my_cart/my_cart_screen_mobile.dart';
import 'package:delivery_app/ui/screens/product_detail_screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class FavoriteScreenMobile extends StatelessWidget {
  const FavoriteScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, itemsProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: _buildBody(itemsProvider, context),
        ),
      );
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Favorites',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [_buildCartIcon(context), SizedBox(width: 16)],
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCartScreenMobile()),
        );
      },
      child: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return badges.Badge(
          badgeContent: Text(
            '${cartProvider.cart.items?.length}',
            style: TextStyle(color: Colors.white),
          ),
          badgeStyle: badges.BadgeStyle(badgeColor: primaryColor),
          showBadge: cartProvider.cart.items?.isNotEmpty ?? false,
          child: Icon(
            Icons.shopping_cart_checkout_outlined,
            size: 30,
            color: Colors.black,
          ),
        );
      }),
    );
  }

  Widget _buildBody(ItemsProvider itemsProvider, BuildContext context) {
    if (itemsProvider.favorites.isEmpty) {
      return _buildEmptyState();
    }
    return _buildFavoritesList(itemsProvider, context);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No favorites yet',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
      ItemsProvider itemsProvider, BuildContext context) {
    return ListView.separated(
      itemCount: itemsProvider.favorites.length,
      separatorBuilder: (context, index) => SizedBox(height: 5),
      itemBuilder: (context, index) {
        final item = itemsProvider.favorites[index];
        return _buildFavoriteItem(item, itemsProvider, context);
      },
    );
  }

  Widget _buildFavoriteItem(
      item, ItemsProvider itemsProvider, BuildContext context) {
    final isAvailable = itemsProvider.items.any(
            (element) => element.id == item.id && (element.isAvailable ?? true));
    return isAvailable
        ? GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreenMobile(item: item  ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
          color: !isAvailable ? Colors.black12.withOpacity(0.15) : null,
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildItemImage(item),
                SizedBox(width: 10),
                _buildItemDetails(item,itemsProvider),
              ],
            ),
          ],
        ),
      ),
    )
        : SizedBox();
  }

  Widget _buildItemImage(item) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.hardEdge,
        child: item.imageUrl != null
            ? Image.network(item.imageUrl!, fit: BoxFit.cover)
            : Image.asset('assets/images/macbook 14.jpg', fit: BoxFit.scaleDown),
      ),
    );
  }

  Widget _buildItemDetails(item,ItemsProvider itemsProvider) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
            _buildFavoriteButton(item, itemsProvider),
                ],
              ),
              Text(
                item.description ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceSection(item),
              _buildAddButton(item),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPriceSection(dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rs. ${item.price?.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (item.variations?.any((variation) => variation.isPrimary == true) ??
            false)
          Text(
            'Starting price',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton(item) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return cartProvider.cart.items
          ?.any((orderItem) => orderItem.item?.id == item.id) ??
          false
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
            // If no variations or addons, add directly to cart
            cartProvider.addItemToCart(
              OrderItem(
                  item: item,
                  quantity: 1,
                  selectedVariations: {},
                  selectedAddons: []),
            );
          } else {
            // If has variations or addons, go to add to cart screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreenMobile(item: item),
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10),
          side: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.add,
              size: 26,
              color: primaryColor,
            ),
            SizedBox(
              width: 5,
            ),
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
      );
    });
  }

  Widget _buildFavoriteButton(item, ItemsProvider itemsProvider) {
    return Positioned(
      child: GestureDetector(
        child: Icon(
          Icons.delete,
          color: Colors.red,
          size: 26,
        ),
        onTap: () {
          itemsProvider.toggleFavorite(item);
        },
      ),
    );
  }
}
