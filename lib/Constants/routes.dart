import 'package:flutter/material.dart';
import 'package:housing_project/UIs/Views/authenticate_view.dart';
import 'package:housing_project/UIs/Views/change_password_view.dart';
import 'package:housing_project/UIs/Views/create_document_view.dart';
import 'package:housing_project/UIs/Views/favourites_view.dart';
import 'package:housing_project/UIs/Views/forgot_password_view.dart';
import 'package:housing_project/UIs/Views/home_view.dart';
import 'package:housing_project/UIs/Views/sign_in_view.dart';
import 'package:housing_project/UIs/Views/sign_up_view.dart';
import 'package:housing_project/UIs/Views/splash_screen.dart';
import 'package:housing_project/UIs/Views/user_profile_view.dart';
import 'package:housing_project/UIs/Views/view_image_view.dart';

class GenerateRoutes {
  // ignore: missing_return
  static Route<dynamic> genereteRouteSettings(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/homeView":
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case "/authenticateView":
        return MaterialPageRoute(
            builder: (BuildContext context) => AuthenticateView());

      case "/splashScreen":
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
      case "/viewImage":
        return MaterialPageRoute(
            builder: (BuildContext context) => ViewImageView());
      case "/createProducts":
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateDocumentView());
      case "/profile":
        return MaterialPageRoute(
            builder: (BuildContext context) => UserProfileView());
      case "/signIn":
        return MaterialPageRoute(
            builder: (BuildContext context) => SignInView());
      case "/signUp":
        return MaterialPageRoute(
            builder: (BuildContext context) => SignUpView());
      case "/forgotPassword":
        return MaterialPageRoute(
            builder: (BuildContext context) => ForgotPasswordView());
      case "/favourites":
        return MaterialPageRoute(
            builder: (BuildContext context) => FavouritesView());
      case "/changePassword":
        return MaterialPageRoute(
            builder: (BuildContext context) => ChangePasswordView());
        break;
      default:
        Scaffold(
          body: Center(
              child:
                  Text("OOOOOpsy,No Route defined for ${routeSettings.name}")),
        );
    }
  }
}
