import 'package:flutter/material.dart';

buttonRoundShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );
}
