import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Apis/database_api.dart';

class DatabaseNotf with ChangeNotifier {
  DatabaseApi _databaseApi = DatabaseApi();
  List<Product> productList;
  CollectionReference collectionReference =
      Firestore.instance.collection("Products");

  Future<List<Product>> fetchProductsAsFuture() async {
    var result = await _databaseApi.getFutureDataCollection();
    productList = result.documents
        .map((docs) => Product.fromJson(docs.data, docs.documentID))
        .toList();
    return productList;
  }

  // Stream<QuerySnapshot> fetchUserProductsAsStream() async* {
  //   yield* _databaseApi.fetchUserProfileData();
  // }

  Stream<QuerySnapshot> fetchProductsAsStream() async* {
    yield* _databaseApi.getStreamdataCollection();
  }

  Stream<QuerySnapshot> fetchRefreshedProductsAsStream() async* {
    yield* _databaseApi.fetchRefreshedDocumentsAsStream();
  }

  // Stream<QuerySnapshot> userProfileData() async* {
  //   // var profile=await _databaseApi.fetchUserProfileData();
  //   yield* _databaseApi.fetchUserProfileData();
  // }

  Future<Product> getProductBtId(String id) async {
    var doc = await _databaseApi.getDocumentsById(id);
    return Product.fromJson(doc.data, doc.documentID);
  }

  Future deleteProduct(String id) async {
    await _databaseApi.deleteDocument(id);
    return;
  }

  Future updateProduct(Product product, String id) async {
    await _databaseApi.updateDocument(product.toJson(), id);
    return;
  }

  Future addProduct(Product product) async {
    await _databaseApi.addDocument(product.toJson());
    return;
  }

  Future addProfileProduct(Product product) async {
    await _databaseApi.addDocument(product.toJson());
    return;
  }
}
