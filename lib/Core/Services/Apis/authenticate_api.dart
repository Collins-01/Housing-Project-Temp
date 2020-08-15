import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_project/Constants/enum.dart';
import 'package:housing_project/Constants/flutter_toast_messages.dart';
import 'package:housing_project/Core/Models/user_model.dart';
import 'package:housing_project/Core/Services/Notifiers/auth_notifier.dart';
import 'package:housing_project/UIs/Views/sign_in_view.dart';
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
  if (authResult != null) {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = userModel.userName;
    userUpdateInfo.photoUrl = userModel.userProfilePicture;
    FirebaseUser firebaseUser = authResult.user;
    await firebaseUser.updateProfile(userUpdateInfo);
    await firebaseUser.reload();
    print("Sign Up: $firebaseUser");
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    // getting the current user from our firebase user
    authNotifier.setUser(currentUser);
    Navigator.pushNamed(context, "/");
  }
  return;
}

// signUp(UserModel userModel, AuthNotifier authNotifier,
//     BuildContext context) async {
//   AuthResult result = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(
//           email: userModel.userEmail, password: userModel.userPassword);
//   if (result != null) {
//     await result.user.reload().then((auth) async {
//       await database.collection("Auth Details").add({
//         "UserName": userModel.userName,
//         "UserEmail": userModel.userEmail,
//         "UserPassworsd": userModel.userPassword,
//         "UserProfilePicture": userModel.userProfilePicture
//       });
//       UserUpdateInfo userUpdateInfo = UserUpdateInfo();
//       userUpdateInfo.displayName = userModel.userName;
//       userUpdateInfo.photoUrl = userModel.userProfilePicture;
//       FirebaseUser firebaseUser = result.user;
//       await firebaseUser.updateProfile(userUpdateInfo);
//       await firebaseUser.reload();
//       print("Sign Up: $firebaseUser");
//       print("Sign Up: ${firebaseUser.email}");
//       print("Sign Up: ${firebaseUser.displayName}");
//       print("Sign Up: ${firebaseUser.photoUrl}");
//       print("Sign Up: ${firebaseUser.isEmailVerified}");
//       print("Sign Up: ${firebaseUser.uid}");
//       FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//       authNotifier.setUser(currentUser);
//     }).whenComplete(() {
//       Navigator.pushNamed(context, "/homeView");
//     });
//   } else {
//     ToastMessages().showToast(
//         "EMAIL ADDRESS IS NOT VERIFIED!!!,PLEASE MAKE SURE YOUR CREDENTIALS ARE CORRECT");
//     print("Invalid Email address");
//     return;
// //   }
// }

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
            builder: (BuildContext context) => SignInView(),
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

profilePicture(File imageFile) {
  // ignore: deprecated_member_use
  ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  if (imageFile == null) {
    return Center(
      child: Icon(Icons.add_a_photo),
    );
  } else {
    return Image.file(imageFile);
  }
}
