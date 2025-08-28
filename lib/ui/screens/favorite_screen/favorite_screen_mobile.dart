import 'package:flutter/material.dart';

class FavoriteScreenMobile extends StatelessWidget {
  const FavoriteScreenMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Center(
        child: Text(
          'Favorites Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 