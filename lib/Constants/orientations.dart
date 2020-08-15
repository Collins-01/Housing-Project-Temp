import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
void orientations(BuildContext context) => MediaQuery.of(context).orientation;
