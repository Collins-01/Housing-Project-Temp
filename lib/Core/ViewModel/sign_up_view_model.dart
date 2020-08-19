import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/custom_text_form_field.dart';
import 'package:housing_project/Constants/enum.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Constants/orientations.dart';
import 'package:housing_project/Constants/raised_buttons.dart';
import 'package:housing_project/Core/Models/user_model.dart';
import 'package:housing_project/Core/Services/Apis/authenticate_api.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/Utilities/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SignUpViewModel extends StatefulWidget {
  @override
  _SignUpViewModelState createState() => _SignUpViewModelState();
}

class _SignUpViewModelState extends State<SignUpViewModel> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthStatus authStatus = AuthStatus.Login;
  ToastMessages toastMessages = ToastMessages();
  UserModel userModel = new UserModel();
  Button _button = Button();
  File _imageFile;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    return authNotifier.status == Status.Authenticating
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Center(
                child: Container(
                  child: Form(
                    key: _key,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: deviceHeight(context) * 0.15,
                        ),
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: _displayImage(),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          hintText: "Please Eneter Your Display name",
                          validator: (String val) {
                            return val.isEmpty ||
                                    val.length > 13 ||
                                    !val.startsWith(RegExp(r'[A-Z]'))
                                ? "PLEASE ENTER A DISPLAY NAME,13 CHARS+ & START WITH A CAMEL CASE"
                                : null;
                          },
                          onSaved: (String val) => setState(
                            () => userModel.userName = val,
                          ),
                        ),
                        CustomTextFormField(
                          hintText: "Please enter Your verified email address",
                          validator: (String val) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            return val.isEmpty || !regex.hasMatch(val)
                                ? "PLEASE ENTER A VALID EMAIL ADDRESS"
                                : null;
                          },
                          onSaved: (String val) => setState(
                            () => userModel.userEmail = val,
                          ),
                        ),
                        CustomTextFormField(
                          obscureText: true,
                          hintText: "Please Enter Your Password",
                          onSaved: (String val) => setState(
                            () => userModel.userPassword = val,
                          ),
                          validator: (String val) {
                            return val.isEmpty || val.length > 9
                                ? "PLEASE ENTER A CORRECT PASSWORD"
                                : null;
                          },
                        ),
                        _button.button(() async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            if (!await authNotifier.signUpWithEmailAddress(
                                userModel, context))
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xffff414d0b),
                                  duration: Duration(seconds: 2),
                                  content: Text(
                                      "An error occured while signing Up.Please check your connection,and make sure your Credentials are valid"),
                                ),
                              );
                          }
                        }, "Sign Up", context),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/signIn");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " Login?",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> pickImage() async {
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((file) {
      setState(() {
        _imageFile = file;
      });
    });
  }

  Widget _displayImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _imageFile != null
            ? Image.file(
                _imageFile,
                fit: BoxFit.contain,
              )
            : Container(),
        _imageFile != null
            ? FlatButton(
                color: Colors.black.withOpacity(0.6),
                onPressed: () async {
                  await pickImage();
                },
                child: Text("Change"))
            : IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  await pickImage();
                }),
      ],
    );
  }

  Future<void> uploadProfilePicture() async {
    var localFile = path.extension(_imageFile.path);
    var uuid = Uuid().v4();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("Profile-Pictures/$uuid$localFile");
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.onComplete;
    print("Image Uploaded");
    await storageReference
        .getDownloadURL()
        .then((getDownloadUrl) => setState(() {
              userModel.userProfilePicture = getDownloadUrl;
            }));
  }

  // void submitForm() async {
  //   if (_key.currentState.validate()) {
  //     _key.currentState.save();
  //     if (!await authNotifier.signUpWithEmailAddress(userModel)) {
  //       setState(() => loading = false);
  //       _scaffoldKey.currentState.showSnackBar(SnackBar(
  //         backgroundColor: Color(0xffff414d0b),
  //         duration: Duration(seconds: 2),
  //         content: Text(
  //             "An error occured while signing Up.Please check your connection,and make sure your Credentials are valid"),
  //       ));
  //     }
  //   }
  // }
}
// https://github.com/Collins01-max/Housing-Project-Temp.git
// https://github.com/Collins01-max/Housing-Project.git
