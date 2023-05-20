import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:marketdo_app_vendor/model/product_model.dart';
import 'package:marketdo_app_vendor/widget/products/product_card.dart';

class PublishedProduct extends StatelessWidget {
  const PublishedProduct({super.key});

  @override
  Widget build(BuildContext context) {
     
    return FirestoreQueryBuilder<Product>(
      query: productQuery(true),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
        if(snapshot.docs.isEmpty){
          return const Center(child: Text('No Published Products'),);
        }
        return ProductCard(snapshot: snapshot,);
      },
    );
  }
}
