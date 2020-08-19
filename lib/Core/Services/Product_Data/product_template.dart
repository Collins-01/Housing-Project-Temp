// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:housing_project/Constants/orientations.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/Core/Services/Notifiers/favourites_notifier.dart';
// import 'package:housing_project/Utilities/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductTemplate extends StatefulWidget {
  final Product product;
  ProductTemplate({this.product});
  @override
  _ProductTemplateState createState() => _ProductTemplateState();
}

class _ProductTemplateState extends State<ProductTemplate> {
  // bool liked = false;
  bool showOverlay = false;
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    print(widget.product.timeStamp);
    var favouritesNotifier = Provider.of<FavouritesNotifier>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 880,
        width: deviceWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90,
              child: Container(
                child: ListTile(
                  leading: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  // trailing: Text(
                  //   "${widget.product.timeStamp}",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  title: Text(
                    "${widget.product.state},${widget.product.town}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  subtitle: Text("${widget.product.timeStamp}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
            Container(
              height: 580,
              child: Carousel(
                autoplay: false,
                // animationCurve: Curves.easeIn,
                boxFit: BoxFit.contain,
                dotColor: Colors.black,
                // animationDuration: Duration(seconds: 2),
                indicatorBgPadding: 0,
                images: [
                  NetworkImage(widget.product.imageUrl1),
                  NetworkImage(widget.product.imageUrl2),
                  NetworkImage(widget.product.imageUrl3),
                  NetworkImage(widget.product.imageUrl4),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  IconButton(
                    icon: favouritesNotifier.liked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(FontAwesomeIcons.heart),
                    onPressed: () async {
                      favouritesNotifier.toggleFavourites();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.phone_in_talk,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      String number = widget.product.phoneNo;
                      number != null
                          ? launch(('tel://$number'))
                          : throw "No valid Phone No";
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.email,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      String email = authNotifier.user.email;
                      launch("mailto:$email");
                    },
                  ),
                ],
              ),
              trailing: FilterChip(
                backgroundColor: Colors.purple,
                label: Text(
                  "\$${widget.product.price}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onSelected: (bool value) => value != value,
              ),
            ),
            Container(
              margin: EdgeInsets.all(6),
              height: 120,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
