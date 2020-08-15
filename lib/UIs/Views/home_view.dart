import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/home_view_model.dart';
import 'package:housing_project/UIs/Views/widgets/appBar.dart';
import 'package:housing_project/UIs/Views/widgets/bottom_navigation_bar.dart';
import 'package:housing_project/UIs/Views/widgets/drawer.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: GestureDetector(
              child: AppBarBottom(),
              onTap: () {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          title: Text("Housing_Project"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        body: HomeViewModel(),
        drawer: DrawerView(),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
// AppBar()
