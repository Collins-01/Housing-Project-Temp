import 'package:flutter/material.dart';
import 'package:housing_project/Constants/orientations.dart';
import 'package:housing_project/Constants/raised_buttons.dart';

class AuthenticateView extends StatelessWidget {
  static Button button = Button();
  @override
  Widget build(BuildContext context) {
    createAccount() {
      Navigator.pushNamed(context, "/signUp");
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(height: deviceHeight(context) * 0.40),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "See Beautiful Houses Around The World And  Select Your Choice",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              raisedButton(createAccount, "Create Account", Colors.red),
              SizedBox(
                height: 30,
              ),
              InkWell(
                child: Text("Forgot Password??",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pushNamed(context, "/forgotPassword");
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Text("Have An Account Already?? Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.purple)),
                  onTap: () {
                    Navigator.pushNamed(context, "/signIn");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
