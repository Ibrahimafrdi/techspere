import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/ui/screens/my_cart/my_cart_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              _buildSliverAppBar(
                item,
                context,
                Provider.of<ItemsProvider>(context, listen: false),
              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                                  // Expanded(
                                  //   child: OutlinedButton.icon(
                                  //     onPressed: () {
                                  //       // Add to wishlist logic
                                  //     },
                                  //     icon: Icon(Icons.favorite_border),
                                  //     label: Text('Add to Wishlist'),
                                  //     style: OutlinedButton.styleFrom(
                                  //       padding:
                                  //           EdgeInsets.symmetric(vertical: 12),
                                  //       side: BorderSide(
                                  //           color: Color(0xFF4A90E2)),
                                  //       foregroundColor: Color(0xFF4A90E2),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(12),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(width: 12),
                                
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

  Widget _buildSliverAppBar(
    Item item,
    BuildContext context,
    ItemsProvider itemsProvider,


  ) {
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
  Consumer<ItemsProvider>(
    builder: (context, itemsProvider, _) {
      final isFav = itemsProvider.isFavorite(item);
      return GestureDetector(
        onTap: () {
          itemsProvider.toggleFavorite(item);
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
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.grey[600],
            size: 20,
          ),
        ),
      );
    },
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
              child: SizedBox(
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
}
