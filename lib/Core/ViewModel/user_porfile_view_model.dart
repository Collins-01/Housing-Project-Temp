import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Apis/authenticate_api.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/Core/Services/Notifiers/database_notifier.dart';
import 'package:housing_project/Core/Services/Product_Data/user_profile_product_template.dart';
import 'package:housing_project/UIs/Views/create_document_view.dart';
import 'package:housing_project/Utilities/loading.dart';

import 'package:provider/provider.dart';

class UserProfileViewModel extends StatefulWidget {
  @override
  _UserProfileViewModelState createState() => _UserProfileViewModelState();
}

class _UserProfileViewModelState extends State<UserProfileViewModel> {
  List<Product> productList;
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = AuthNotifier();
    var authProvider = Provider.of<AuthNotifier>(context);
    var productProvider = Provider.of<DatabaseNotf>(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesomeIcons.featherAlt),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CreateDocumentView(),
                ),
              );
            }),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return [
              SliverAppBar(
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        print("Logging Out");
                        await signOutWithEmail(authNotifier, context);
                      },
                      icon: Icon(Icons.person_outline),
                      label: Text("LogOut"))
                ],
                expandedHeight: 250,
                backgroundColor: Colors.grey[400],
                pinned: true,
                // snap: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            authProvider.user.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            authProvider.user.email,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: StreamBuilder(
            stream: productProvider.fetchProductsAsStream(),
            // ignore: missing_return
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                // String docsId = snapshot.data.documents.documentID;
                productList = snapshot.data.documents
                    .map(
                      (docs) => Product.fromJson(docs.data, docs.documentID),
                    )
                    .toList();
                return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return UserProfileProductTemplate(
                        product: productList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(color: Colors.black),
                    itemCount: productList.length);
              } else {
                print("No created Document in your history");
                return Loading();
              }
            },
          ),
        ),
      ),
    );
  }
}

// ListView(
//         children: <Widget>[
//           // First Row(App bar)
//           Padding(
//             padding: EdgeInsets.only(
//               top: 45,
//               bottom: 40,
//             ),
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                     icon: Icon(Icons.arrow_back_ios),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     }),
//                 Container(
//                   child: Row(
//                     children: <Widget>[
//                       IconButton(
//                           icon: Icon(Icons.person_outline), onPressed: () {}),
//                       FlatButton.icon(
//                         onPressed: () {
//                           print("Logging Out");
//                         },
//                         icon: Icon(Icons.settings),
//                         label: Text("Log Out"),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           //Display Text for appbar
//         ],
//       ),
