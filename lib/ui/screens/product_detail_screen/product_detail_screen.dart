import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/models/addon.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:delivery_app/ui/screens/my_cart/my_cart_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'product_detail_provider.dart';

class ProductDetailScreenMobile extends StatelessWidget {
  final Item item;
  const ProductDetailScreenMobile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddToCartScreenProvider(),
      child: Consumer2<AddToCartScreenProvider, CartProvider>(
          builder: (context, model, cartProvider, child) {
        model.initItem(item);
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductInfo(),
                      SizedBox(height: 20),
                      _buildAboutSection(),
                      SizedBox(height: 25),               
                      _buildTechnicalSpecs(),
                      SizedBox(height: 22),
                      Container(
              
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Price',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 300),
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: model.orderItem.totalPrice,
                                    ),
                                    builder: (context, value, child) {
                                      return Text(
                                        '\$${value.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        // Add to wishlist logic
                                      },
                                      icon: Icon(Icons.favorite_border),
                                      label: Text('Add to Wishlist'),
                                      style: OutlinedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        side: BorderSide(
                                            color: Color(0xFF4A90E2)),
                                        foregroundColor: Color(0xFF4A90E2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Validate required variations are selected
                                        for (var variation
                                            in item.variations ?? []) {
                                          if (variation.isRequired ?? false) {
                                            if (!model.orderItem
                                                    .selectedVariations!
                                                    .containsKey(
                                                        variation.name) ||
                                                model
                                                    .orderItem
                                                    .selectedVariations![
                                                        variation.name]!
                                                    .isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(Icons.error,
                                                          color: Colors.white,
                                                          size: 20),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          'Please select ${variation.name}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.red[400],
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                          }
                                        }
                                        cartProvider
                                            .addItemToCart(model.orderItem);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: const [
                                                Icon(Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                    'Added to cart successfully!'),
                                              ],
                                            ),
                                            backgroundColor: Colors.green[400],
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyCartScreenMobile()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4A90E2),
                                        foregroundColor: Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.shopping_cart),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  // Recommend to friend logic
                                },
                                icon: Icon(Icons.share, size: 18),
                                label: Text('Recommend to a Friend'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // Space for bottom buttons
                    
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border, color: Colors.black),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFFFFF3CD),
                Color(0xFFFFE69C),
              ],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'product_image_${item.id}',
              child: Container(
                height: 400,
                width: 400,
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/images/macbook 14.jpg',
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title ?? 'Product Name',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        // Text(
        //   'Brand: ${item.brand ?? "InnovateTech"}',
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: Colors.grey[600],
        //   ),
        // ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              '\$${item.price?.toStringAsFixed(2) ?? "1799.99"}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),
            // SizedBox(width: 8),
            // Text(
            //   '\$1999.99',
            //   style: TextStyle(
            //     fontSize: 16,
            //     decoration: TextDecoration.lineThrough,
            //     color: Colors.grey[500],
            //   ),
            // ),
            // SizedBox(width: 8),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //   decoration: BoxDecoration(
            //     color: Colors.red[100],
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Text(
            //     '10% OFF',
            //     style: TextStyle(
            //       fontSize: 12,
            //       color: Colors.red[700],
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildStarRating(4.7),
            SizedBox(width: 8),
            Text('(4.7 / 5.0)', style: TextStyle(color: Colors.grey[600])),
            SizedBox(width: 8),
            Text('• 245 Reviews', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Text(
          item.description ??
              'Experience the future with the ElectroSuggest Z-Fold Pro, a revolutionary foldable smartphone designed for ultimate productivity and entertainment. Unfold a stunning cinematic display for immersive viewing and multitasking, or enjoy the compact form factor for on-the-go convenience.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildVariationsSection(AddToCartScreenProvider model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Text(
          'Product Options',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        ...List.generate(
          item.variations?.length ?? 0,
          (variationIndex) {
            var variation = item.variations?[variationIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVariationTitle(variation),
                SizedBox(height: 10),
                _buildVariationOptions(variation, model),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildVariationTitle(dynamic variation) {
    return badges.Badge(
      badgeStyle: badges.BadgeStyle(badgeColor: Colors.transparent),
      badgeContent: Text(
        '*',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
      child: Text(
        "${variation?.name}",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      showBadge: variation?.isRequired ?? false,
    );
  }

  Widget _buildVariationOptions(
      dynamic variation, AddToCartScreenProvider model) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        variation?.options?.length ?? 0,
        (optionIndex) {
          var option = variation?.options?[optionIndex];
          bool isSelected = _isOptionSelected(model, variation, option);
          return _buildOptionChip(option, isSelected, () {
            model.updateVariation(variation?.name ?? '', option?.name ?? '');
          });
        },
      ),
    );
  }

  bool _isOptionSelected(
      AddToCartScreenProvider model, dynamic variation, dynamic option) {
    var selectedVariation =
        model.orderItem.selectedVariations?.entries.firstWhere(
      (element) => element.key == variation?.name,
      orElse: () => MapEntry('', []),
    );
    return selectedVariation?.value?.contains(option?.name) ?? false;
  }

  Widget _buildAddonsSection(AddToCartScreenProvider model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Text(
          'Add-ons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            item.addons?.length ?? 0,
            (index) => _buildAddonChip(item.addons?[index], model),
          ),
        ),
      ],
    );
  }

  Widget _buildAddonChip(Addon? addon, AddToCartScreenProvider model) {
    bool isSelected = model.orderItem.selectedAddons!.contains(addon);
    return _buildOptionChip(
      addon,
      isSelected,
      () {
        model.updateAddon(addon!);
      },
    );
  }

  Widget _buildOptionChip(dynamic item, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Color(0xFF4A90E2).withOpacity(0.1) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? Color(0xFF4A90E2) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item?.name ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Color(0xFF4A90E2) : Colors.black87,
              ),
            ),
            if (item?.price != null && item.price > 0)
              Text(
                '+\$${item?.price?.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Color(0xFF4A90E2) : Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Text(
          'Technical Specifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        ...List.generate(item.technicalSpecs.entries.length, (index) {
          var entry = item.technicalSpecs.entries.elementAt(index);
          return _buildSpecRow(entry.key, entry.value);
        }),
       
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        _buildReviewItem('Alex Johnson', 5,
            'This phone is a game-changer! The screen is incredibly vibrant, and the camera takes stunning photos. Battery life is impressive too. Highly recommend for anyone looking for a premium smartphone.'),
        _buildReviewItem('Sophia Miller', 4,
            'Overall, a fantastic smartphone. The performance is top-notch, and it handles everything I throw at it with ease. My only minor gripe is the size, a bit large for one-handed use, but still great.'),
        _buildReviewItem('David Chen', 5,
            'Absolutely blown away by the speed and fluidity of this device. From gaming to multitasking, it doesn\'t break a sweat. The design is sleek, and it feels premium in hand.'),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String review) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF4A90E2),
                child: Text(
                  name.substring(0, 2).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        _buildStarRating(rating.toDouble()),
                        SizedBox(width: 8),
                     
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
             Text(
                          'Reviewed on Apr 24, 2024',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
          SizedBox(height: 12),
          Text(
            review,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text('Helpful',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
