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
  bool _rememberMeSwitch = false;
  Button button = Button();
  bool loading = false;
  bool obscureText = false;

  @override
  initState() {
    // getting the current user state before we load the page
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializecurrentUser(authNotifier);
    super.initState();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var deviceHieght = MediaQuery.of(context).size.height;

    return loading
        ? Loading()
        : Scaffold(
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
                        onSaved: (String val) => userModel.userEmail = val,
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
                        hintText: "Please enter your Password!!",
                        onSaved: (String val) => userModel.userEmail = val,
                        validator: (String val) => val.length > 10 ||
                                val.length < 8
                            ? "Please Enter a UserName 10 Chars max and 8+ less"
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
                      raisedButton(submitForm, "Sign In", Colors.red),
                      authStatus == AuthStatus.SignUp
                          ? Container()
                          : Align(
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

  submitForm() {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
    }
  }
}
