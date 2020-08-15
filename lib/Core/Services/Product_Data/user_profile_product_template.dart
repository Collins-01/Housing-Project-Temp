import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/colors.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Core/Models/product_model.dart';
import 'package:housing_project/Core/Services/Notifiers/database_notifier.dart';
import 'package:provider/provider.dart';

class UserProfileProductTemplate extends StatefulWidget {
  final Product product;
  final String docId;
  UserProfileProductTemplate({this.product, this.docId});
  @override
  _UserProfileProductTemplateState createState() =>
      _UserProfileProductTemplateState();
}

class _UserProfileProductTemplateState
    extends State<UserProfileProductTemplate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        alertDialog(context);
      },
      child: Container(
        height: 850,
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              child: ListTile(
                leading: Text(
                  "${widget.product.state},${widget.product.town}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                trailing: Text("${widget.product.timeStamp}Pm"),
              ),
            ),
            Divider(),
            Container(
              height: 550,
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
              trailing: FilterChip(
                  backgroundColor: appColor(),
                  label: Text(
                    widget.product.price,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onSelected: (bool val) {}),
            ),
            Container(
              margin: EdgeInsets.all(8),
              height: 140,
              child: Wrap(
                children: <Widget>[Text(widget.product.description)],
              ),
            )
          ],
        ),
      ),
    );
  }

  void alertDialog(BuildContext context) async {
    var databaseNotifier = Provider.of<DatabaseNotf>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                "What Operation Would you want to perform?.",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                FlatButton(onPressed: () {}, child: Text("Update")),
                FlatButton(
                    onPressed: () async {
                      await databaseNotifier
                          .deleteProduct(widget.product.id)
                          .whenComplete(() {
                        ToastMessages().showToast("Item deleted");
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text("Delete")),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            ));
  }
}
