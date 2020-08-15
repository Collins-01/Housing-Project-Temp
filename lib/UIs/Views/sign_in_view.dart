import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SignInViewModel(),
      ),
    );
  }
}
