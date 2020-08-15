import 'package:flutter/material.dart';

class FavouritesViewModel extends StatefulWidget {
  @override
  _FavouritesViewModelState createState() => _FavouritesViewModelState();
}

class _FavouritesViewModelState extends State<FavouritesViewModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[Icon(Icons.favorite)],
          title: Text("Favourites"),
        ),
        body: ListView(),
      ),
    );
  }
}
