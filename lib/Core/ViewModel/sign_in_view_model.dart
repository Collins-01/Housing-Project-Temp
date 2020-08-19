import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/custom_text_form_field.dart';
import 'package:housing_project/Constants/enum.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Constants/raised_buttons.dart';
import 'package:housing_project/Core/Models/user_model.dart';
import 'package:housing_project/Core/Services/Apis/authenticate_api.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/Utilities/loading.dart';
import 'package:provider/provider.dart';

class SignInViewModel extends StatefulWidget {
  @override
  _SignInViewModelState createState() => _SignInViewModelState();
}

class _SignInViewModelState extends State<SignInViewModel> {
  // AuthStatus authStatus = AuthStatus.Login;
  ToastMessages toastMessages = ToastMessages();
  UserModel userModel = new UserModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _rememberMeSwitch = false;
  Button button = Button();
  bool loading = false;
  bool obscureText = false;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    var deviceHieght = MediaQuery.of(context).size.height;

    return authNotifier.status == Status.Authenticating
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: deviceHieght * 0.15,
                      ),
                      CustomTextFormField(
                        hintText: "Please Enter Your Email Address",
                        onSaved: (String val) =>
                            setState(() => userModel.userEmail = val),
                        validator: (String val) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          return val.isEmpty || !regex.hasMatch(val)
                              ? "PLEASE ENTER A VALID EMAIL ADDRESS"
                              : null;
                        },
                      ),
                      CustomTextFormField(
                        obscureText: true,
                        hintText: "Please enter your Password!!",
                        onSaved: (String val) =>
                            setState(() => userModel.userPassword = val),
                        validator: (String val) => val.length > 10 ||
                                val.length < 6
                            ? "Please Enter a UserName 10 Chars max and 6+ less"
                            : null,
                      ),
                      Container(
                        height: 20,
                        child: SwitchListTile(
                            title: Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: _rememberMeSwitch,
                            onChanged: (bool value) {
                              setState(() {
                                value = _rememberMeSwitch;
                              });
                            }),
                      ),
                      SizedBox(height: 13),
                      raisedButton(() async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (!await authNotifier.signInWithEmailAddress(
                              userModel, context))
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Color(0xffff414d0b),
                              content: Text(
                                  "An Error Occured While Signing In.Please Check your Internet and Make Sure Your Credentials Are Valid!!!"),
                            ));
                        }
                      }, "Sign In", Colors.red),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            print("forgot password");
                          },
                          child: Text(
                            "Forgot Password?        ",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/signUp");
                            },
                            child: Text(
                              "       Dont Have an Account? Sign Up.",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
