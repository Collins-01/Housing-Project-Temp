import 'package:flutter/material.dart';
import 'package:housing_project/Core/ViewModel/create_products_view_model.dart';

class CreateDocumentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Create Document"),
        ),
        body: CreateDocumentsViewModel(),
      ),
    );
  }
}
