import 'package:flutter/material.dart';
import 'package:housing_project/Core/Services/Apis/authenticate_api.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/UIs/Views/user_profile_view.dart';
import 'package:provider/provider.dart';

class DrawerViewModel extends StatefulWidget {
  @override
  _DrawerViewModelState createState() => _DrawerViewModelState();
}

class _DrawerViewModelState extends State<DrawerViewModel> {
  bool val;
  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    // var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/logos/2.jpg"),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            accountName: Text(authNotifier.user.displayName),
            accountEmail: Text(authNotifier.user.email),
          ),
          SizedBox(
            height: 10,
          ),
          RadioListTile(
              title: Text("DarkMode"),
              value: val,
              groupValue: val,
              onChanged: (bool val) {
                setState(() {
                  val = !val;
                });
              }),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UserProfileView()));
              },
              child: ListTile(
                title: Text("Profile"),
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              )),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UserProfileView()));
              },
              child: ListTile(
                title: Text("Favourites"),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              )),
          InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("ChangePin"),
                leading: Icon(
                  Icons.vpn_key,
                  color: Colors.blue,
                ),
              )),
          InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Are You Sure you wanna LogOut???"),
                        content: Text(
                            "By doing this,You will be Taken out this app and will require Password to LoginNext Time"),
                        actions: <Widget>[
                          InkWell(
                            onTap: () =>
                                signOutWithEmail(authNotifier, context),
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Decline",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      );
                    });
              },
              child: ListTile(
                title: Text("LogOut"),
                leading: Icon(
                  Icons.last_page,
                  color: Colors.blue,
                ),
              )),
          InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("About"),
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.blue,
                ),
              )),
        ],
      ),
    );
  }
}
