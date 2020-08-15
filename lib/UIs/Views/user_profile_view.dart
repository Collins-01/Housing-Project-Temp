import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/user_porfile_view_model.dart';

class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: UserProfileViewModel(),
      ),
    );
  }
}
