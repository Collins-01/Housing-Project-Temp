import 'package:flutter/material.dart';

class Button {
  button(Function pressed, String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(17),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        onPressed: pressed,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget raisedButton(void function(), String title, Color splashColor) {
  return Container(
    width: 300,
    margin: EdgeInsets.all(17),
    child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        splashColor: splashColor,
        color: Colors.purple,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: function),
  );
}
