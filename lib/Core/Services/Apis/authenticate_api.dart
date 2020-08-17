import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
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
    Navigator.pushReplacementNamed(context, "/homeView");
  }
  return;
}

// signUpWithEmail(AuthNotifier authNotifier, UserModel userModel,
//     BuildContext context) async {
//   FirebaseUser getCurrentUser = await FirebaseAuth.instance.currentUser();
//   if (getCurrentUser == null) {
//     print("No current User on the App");
//     await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: userModel.userEmail.trimLeft(),
//             password: userModel.userPassword.trimLeft())
//         .then((authResults) async {
//       if (authResults != null) {
//         Firestore database = Firestore.instance;
//         await FirebaseAuth.instance.currentUser().then((currentUser) async {
//           await currentUser.reload();
//           UserUpdateInfo userUpdateInfo = UserUpdateInfo();
//           userModel.userName = userUpdateInfo.displayName;
//           userModel.userProfilePicture = userUpdateInfo.photoUrl;
//           String uid = currentUser.uid;
//           authNotifier.setUser(currentUser);
//           await database.collection("USERS/$uid").add({
//             "User-Name": userModel.userName.trimLeft(),
//             "User-ProfilePicture": userModel.userProfilePicture.trimLeft(),
//             "User-Email": userModel.userEmail.trimLeft(),
//             "User-Password": userModel.userPassword.trimLeft(),
//             "User-Uid": uid,
//           }).catchError((error) => print("Error Here is==$error"));
//         }).whenComplete(() {
//           Navigator.pushReplacementNamed(context, "/homeView");
//         });

//         print("Creating A new User in the Database");
//         // Navigator.pushNamed(context, "/homeView");
//         return authResults;
//       } else {
//         print("Error Creating a new User In the Database");
//         return null;
//       }
//     });
//   } else {
//     print("A user Hasn't Logged Out Yet,Action Cant be Performed");
//     return;
//   }
// }

// signUp with google
// Sign In with Email and password
// signInWithEmail(UserModel userModel, AuthNotifier authNotifier,
//     BuildContext context) async {
//   // check if current user==null;
//   // if the user==null,signIn and catch errors
//   FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//   if (currentUser == null) {
//     await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//             email: userModel.userEmail, password: userModel.userPassword)
//         .then((result) async {
//       if (result != null) {
//         await FirebaseAuth.instance.currentUser().then((loggedInUser) async {
//           authNotifier.setUser(loggedInUser);
//         }).whenComplete(() {
//           Navigator.of(context).pushReplacementNamed("/homeView");
//         });
//       } else {
//         print("An error occured while signing In to this Device");
//         return;
//       }
//     });
//   } else {
//     print("A User Hasn't Logged Out From This Device");
//     return;
//   }
// }

signInWithEmailandPassword(UserModel userModel, AuthNotifier authNotifier,
    BuildContext context) async {
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
      Navigator.pushReplacementNamed(context, "/homeView");
    }
    return;
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
