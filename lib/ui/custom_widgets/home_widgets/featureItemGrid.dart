import 'package:delivery_app/ui/custom_widgets/home_widgets/menuItem.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

class FeaturedItemsGrid extends StatelessWidget {
  final String selectedCategory;

  const FeaturedItemsGrid({
    required this.selectedCategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulating data from the network based on selected category
    final Map<String, List<Map<String, String>>> featuredItemsData = {
      'Starter': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/cartpic.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
        {
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Vegetarian': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 1',
          'description': 'Healthy vegetarian option...',
          'price': '3.00₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 2',
          'description': 'A tasty and fresh vegetarian meal...',
          'price': '3.75₱',
        },{
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Cold Drinks': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 1',
          'description': 'Healthy vegetarian option...',
          'price': '3.00₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 2',
          'description': 'A tasty and fresh vegetarian meal...',
          'price': '3.75₱',
        },{
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Chicken': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/cartpic.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
        {
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Drinks': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 1',
          'description': 'Healthy vegetarian option...',
          'price': '3.00₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 2',
          'description': 'A tasty and fresh vegetarian meal...',
          'price': '3.75₱',
        },{
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Desserts': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/cartpic.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
        {
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      'Local': [
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 1',
          'description': 'Healthy vegetarian option...',
          'price': '3.00₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Vegetarian Dish 2',
          'description': 'A tasty and fresh vegetarian meal...',
          'price': '3.75₱',
        },{
          'image': 'assets/images/chiken fries.png.png',
          'title': 'Starter Item 1',
          'description': 'Delicious starter with fresh ingredients...',
          'price': '1.50₱',
        },
        {
          'image': 'assets/images/wings.png.png',
          'title': 'Starter Item 2',
          'description': 'Aromatic and crispy starter...',
          'price': '2.50₱',
        },
      ],
      // Add more categories here
    };

    // Fetch the items for the selected category
    final featuredItems = featuredItemsData[selectedCategory] ?? [];

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double width = sizingInformation.screenSize.width;
        int crossAxisCount;
        double childAspectRatio;

        if (width > 1200) {
          crossAxisCount = 4;
          childAspectRatio = 0.85;
        } else if (width > 800 && width <= 1200) {
          crossAxisCount = 3;
          childAspectRatio = 0.89;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 0.7;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: featuredItems.length,
          itemBuilder: (context, index) {
            final item = featuredItems[index];
            return FeaturedItemCard(
              image: item['image']!,
              title: item['title']!,
              description: item['description']!,
              price: item['price']!,
            );
          },
        );
      },
    );
  }
}