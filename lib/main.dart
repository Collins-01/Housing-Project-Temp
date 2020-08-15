import 'package:housing_project/Constants/routes.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Core/Services/Notifiers/favourites_notifier.dart';
import 'package:housing_project/Core/Services/Notifiers/theme_notifier.dart';
import 'package:housing_project/UIs/Views/authenticate_view.dart';
import 'package:provider/provider.dart';

import 'Core/Services/Notifiers/database_notifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
            create: (BuildContext context) => DatabaseNotf()),
        ChangeNotifierProvider(
            create: (BuildContext context) => FavouritesNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Housing Project',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: AuthenticateView(),
        // initialRoute: "/splashScreen",
        onGenerateRoute: GenerateRoutes.genereteRouteSettings,
      ),
    );
  }
}
