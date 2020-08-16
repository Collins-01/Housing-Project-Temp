import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/enum.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Core/Models/user_model.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/UIs/Views/authenticate_view.dart';
import 'package:image_picker/image_picker.dart';

Firestore database = Firestore.instance;
// var test=database.collectionGroup(path).
AuthStatus authStatus = AuthStatus.Login;
// SIgnUp with Email and password
signUpWithEmailandPassword(UserModel userModel, AuthNotifier authNotifier,
    BuildContext context) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: userModel.userEmail, password: userModel.userPassword)
      .catchError((error) => print(error.code));
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  if (authResult != null) {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = userModel.userName;
    userUpdateInfo.photoUrl = userModel.userProfilePicture;
    FirebaseUser firebaseUser = authResult.user;
    String userId = firebaseUser.uid;
    await firebaseUser.updateProfile(userUpdateInfo);
    await database
        .collection("USERS")
        .document("User-Data")
        .collection(userId)
        .add({
      "User-Name": userModel.userName,
      "User-ProfilePicture": userModel.userProfilePicture,
      "User-Email": userModel.userEmail,
      "User-Password": userModel.userPassword
    });
    await firebaseUser.reload();
    print("Sign Up: $firebaseUser");
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    // getting the current user from our firebase user
    authNotifier.setUser(currentUser);
    Navigator.pushNamed(context, "/homeView");
  }
  return;
}

// signUp with google
// Sign In with Email and password
signInWithEmailandPassword(
    UserModel userModel, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: userModel.userEmail, password: userModel.userPassword)
      .catchError(
        (error) => print(error.code),
      );

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser != null) {
      authNotifier.setUser(firebaseUser);
    }
  } else {
    ToastMessages().showToast(
        "INVALID CREDENTIALS,PLEASE MAKE SURE YOUR CREDENTIALS ARE VALIDATED!!!!!!");
  }
}

// Sign Out with Email
signOutWithEmail(AuthNotifier authNotifier, BuildContext context) async {
  await FirebaseAuth.instance
      .signOut()
      .then(
        (nav) => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => AuthenticateView(),
          ),
        ),
      )
      .catchError((error) => print(error.code));
  return authStatus;
}

// getting the current User  state of the app
initializecurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
  }
}
