import 'dart:core';

import 'package:flutter/material.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Notifiers/database_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesNotifier with ChangeNotifier {
  DatabaseNotf databaseNotf = DatabaseNotf();
  //  databaseNotf. fetchProductsAsFuture();
  SharedPreferences sharedPreferences;
  static List<Product> _favouritesList;
  List<Product> _productList;

  toggleFavouriteStatus() {
    int index;
    // bool isCurrentlyFavourite = _productList[index].isFavourite;
    // bool newFavouriteStatus = !isCurrentlyFavourite;
    Product updatedProduct = Product().toJson();
    _productList[index] = updatedProduct;
    notifyListeners();
  }

// get elements by id function
// check if isfavourites=favList for anyWhere
  favourites(Product product) async {
    // checking if product is in favourites
    bool isfavourite = _favouritesList.any((value) => value.id == product.id);
    if (isfavourite) {
      // since fav=true=>add to to favourite List
      _favouritesList.add(product);
      _productList.map((val) {
        if (val == product) {
          // if the val equals the the argument(product),change val.fav=true
          val.isFavourite = true;
          return val;
        } else {
          return val;
        }
      });
      notifyListeners();
    } else {
      // since fav=false=>remove from favourite List
      _favouritesList.remove(product);
      _productList.map((val) {
        if (val == product) {
          // if the val equals the the argument(product),change val.fav=false
          val.isFavourite = false;
          return val;
        } else {
          return val;
        }
      });
      notifyListeners();
    }
  }

  bool _liked = false;
  bool get liked => _liked;
  toggleFavourites() {
    _liked = !_liked;
    notifyListeners();
  }
}
