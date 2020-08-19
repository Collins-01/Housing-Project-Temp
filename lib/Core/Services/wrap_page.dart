import 'package:flutter/material.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/UIs/Views/authenticate_view.dart';
import 'package:housing_project/UIs/Views/home_view.dart';
import 'package:housing_project/UIs/Views/sign_in_view.dart';
import 'package:provider/provider.dart';

class WrapPage extends StatefulWidget {
  @override
  _WrapPageState createState() => _WrapPageState();
}

class _WrapPageState extends State<WrapPage> {
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthNotifier>(context);
    switch (authProvider.status) {
      case Status.UnInitialized:
        return AuthenticateView();
      case Status.UnAuthenticated:
      case Status.Authenticating:
        return AuthenticateView();
      case Status.Authenticated:
        return HomeView();
        break;
      default:
    }
  }
}
