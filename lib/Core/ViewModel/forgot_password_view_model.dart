import 'package:flutter/material.dart';
import 'package:housing_project/Constants/custom_text_form_field.dart';
import 'package:housing_project/Constants/orientations.dart';
import 'package:housing_project/Constants/raised_buttons.dart';
import 'package:housing_project/Core/Models/user_model.dart';

// ignore: must_be_immutable
class ForgotPasswordViewModel extends StatelessWidget {
  final UserModel userModel = UserModel();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: deviceHeight(context) * 0.40),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Please Enter Your Email Address,A link Will be Sent to you Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              CustomTextFormField(
                hintText: "Email Address",
                onSaved: (String value) => userModel.userEmail,
                validator: (String val) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (val.isEmpty || !regex.hasMatch(val)) {
                    return "Please Enter a valid Email Address!!";
                  } else {
                    return null;
                  }
                },
                obscureText: false,
              ),
              raisedButton(function(), "Submit", Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  function() {
    //   if (_formkey.currentState.validate()) {
    //     _formkey.currentState.save();
    //   } else {
    //     print("invalid form");
    //     return;
    //   }
  }
}
