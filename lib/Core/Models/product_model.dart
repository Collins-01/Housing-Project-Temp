class Product {
  String id;
  bool isFavourite;

  String description;
  String price;
  String imageUrl1;
  String imageUrl2;
  String imageUrl3;
  String imageUrl4;
  String location;
  String phoneNo;
  String email;
  String timeStamp;
  String state;
  String town;

  Product({
    this.id,
    this.description,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.imageUrl4,
    this.price,
    this.location,
    this.phoneNo,
    this.email,
    this.timeStamp,
    this.state,
    this.town,
    this.isFavourite = false,
  });
// converting data from JsonData type
  Product.fromJson(Map snapshot, String id)
      : id = id ?? "",
        description = snapshot["description"] ?? "",
        price = snapshot["price"] ?? "",
        imageUrl1 = snapshot["imageUrl1"] ?? "",
        imageUrl2 = snapshot["imageUrl2"] ?? "",
        imageUrl3 = snapshot["imageUrl3"] ?? "",
        imageUrl4 = snapshot["imageUrl4"] ?? "",
        location = snapshot["location"] ?? "",
        phoneNo = snapshot["phoneNo"] ?? "",
        email = snapshot["email"] ?? "",
        state = snapshot["state"] ?? "",
        town = snapshot["town"] ?? "",
        timeStamp = snapshot["timeStamp"] ?? "";

// Converting Data to JsonData

  toJson() {
    return {
      "description": description,
      "price": price,
      "imageUrl1": imageUrl1,
      "imageUrl2": imageUrl2,
      "imageUrl3": imageUrl3,
      "imageUrl4": imageUrl1,
      "location": location,
      "phoneNo": phoneNo,
      "email": email,
      "timeStamp": timeStamp,
      "state": state,
      "town": town,
    };
  }
}
