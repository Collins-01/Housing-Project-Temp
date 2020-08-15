class UserModel {
  String uid;
  String userEmail;
  String userName;
  String userProfilePicture;
  String userPassword;
  String timeCreated;

  UserModel({
    this.uid,
    this.userProfilePicture,
    this.userEmail,
    this.userName,
    this.userPassword,
    this.timeCreated,
  });
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      userEmail: jsonData["userEmail"],
      userPassword: jsonData["userPassword"],
      userName: jsonData["userName"],
      userProfilePicture: jsonData["userProfilePicture"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "userName": userName,
      "userPassword": userPassword,
      "userEmail": userEmail,
      "timeCreated": timeCreated,
    };
  }
}
