import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:housing_project/Core/Models/user_model.dart';

enum Status { Authenticated, Authenticating, UnAuthenticated, UnInitialized }

class AuthNotifier with ChangeNotifier {
  Status _status = Status.UnInitialized;
  Status get status => _status;
  FirebaseAuth _firebaseAuth;
  FirebaseUser _user;
  FirebaseUser get user => _user;
  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  AuthNotifier.initializeUser() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChange);
  }
// Creating a function to Sign Up with Email and Password
  Future<bool> signUpWithEmailAddress(UserModel userModel, context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: userModel.userEmail, password: userModel.userPassword)
          .then((result) async {
        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userModel.userName = userUpdateInfo.displayName;
        userModel.userProfilePicture = userUpdateInfo.photoUrl;
        await result.user
            .updateProfile(userUpdateInfo)
            .then((reload) async => await result.user.reload())
            .then((createUserDoc) async {
          Firestore firestore = Firestore.instance;
          await firestore.collection("Users").add({
            "uid": result.user.uid,
            "User-Profile-Picture-Url": userModel.userProfilePicture,
            "userName": userModel.userName,
            "userPassword": userModel.userPassword,
            "userEmail": userModel.userEmail,
            "User Verified Email": result.user.isEmailVerified,
            "timeCreated": Timestamp.now().toDate(),
          });
        });
      });
      return true;
    } catch (e) {
      _status = Status.UnAuthenticated;
      notifyListeners();
      print("Error Signing Up was==$e");
      return false;
    }
  }
  // Creating a signing in with email and password function

  Future<bool> signInWithEmailAddress(UserModel userModel, context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.userEmail, password: userModel.userPassword);
      print("Logging In was Succesfull");
      return true;
    } catch (e) {
      print("Error Signing In was ==$e");
      _status = Status.UnAuthenticated;
      notifyListeners();
      return false;
    }
  }

// creasting a signout function
  Future signOutFromDevice(context) async {
    _status = Status.UnAuthenticated;
    notifyListeners();
    await _firebaseAuth.signOut();
    return Future.delayed(Duration.zero);
  }

// listening to the authentication change
  void _onAuthStateChange(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.UnAuthenticated;
    } else {
      _status = Status.Authenticated;
      _user = firebaseUser;
    }
    notifyListeners();
  }
}
