import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Notifiers/database_notifier.dart';
import 'package:housing_project/Core/Services/Product_Data/product_template.dart';
import 'package:housing_project/Utilities/loading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeViewModel extends StatefulWidget {
  @override
  _HomeViewModelState createState() => _HomeViewModelState();
}

class _HomeViewModelState extends State<HomeViewModel> {
  TextEditingController scrollController = TextEditingController();

  List<Product> _productList;
  List<Product> _newProductList;
  bool refreshListOfProducts = false;
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<DatabaseNotf>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // xhange refreshListOfProducts=true
          // setState(() {
          //   refreshListOfProducts = true;
          // });
          print("Refreshing List of Products");
        },
        child: Container(
          child: StreamBuilder<QuerySnapshot>(

              // refreshListOfProducts=true?productProvider.fetchrefreshProductsAsStream:productProvider.fetchProductsAsSream
              stream: refreshListOfProducts
                  ? productProvider.fetchRefreshedProductsAsStream()
                  : productProvider.fetchProductsAsStream(),
              builder:
                  // ignore: missing_return
                  (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                print("Stream Builder");
                if (snapshot.hasData) {
                  // Convert our new list of products to a list of data snapshots for each data and all to List
                  _newProductList = snapshot.data.documents
                      .map((document) =>
                          Product.fromJson(document.data, document.documentID))
                      .toList();

                  _productList = snapshot.data.documents
                      .map((docs) =>
                          Product.fromJson(docs.data, docs.documentID))
                      .toList();

                  return ListView.separated(
                      scrollDirection: Axis.vertical,
                      // controller: _scrollController.,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, index) {
                        return Divider(
                          color: Colors.black,
                        );
                      },
                      // if refreshProduct=true?_newProductList.lenght:_productList.lenght
                      itemCount: refreshListOfProducts
                          ? _newProductList
                          : _productList.length,
                      itemBuilder: (BuildContext context, index) {
                        return ProductTemplate(
                          // if refreshProductlist=true?_newProductList[index]:_productList[index]
                          product: refreshListOfProducts
                              ? _newProductList
                              : _productList[index],
                        );
                      });
                } else if (snapshot.hasData == null) {
                  return Center(child: Text("No Item on List!!!!!!"));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Loading();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                      child: Text(
                          "No Internet Connection,Please Connect to a Network!!!!!!"));
                } else {
                  return Loading();
                }
              }),
        ),
      ),
    );
  }
}
