import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/favourites_view_model.dart';

class FavouritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FavouritesViewModel(),
      ),
    );
  }
}
