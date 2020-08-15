import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/forgot_password_view_model.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPasswordViewModel(),
    );
  }
}
