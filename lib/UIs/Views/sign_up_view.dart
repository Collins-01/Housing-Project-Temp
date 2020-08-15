import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SignUpViewModel(),
      ),
    );
  }
}
