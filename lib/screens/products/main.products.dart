import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/models/product.model.dart';
import 'package:marketdo_app_vendor/screens/products/details.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0),
      body: StreamBuilder(
          stream: productsCollection
              .where('vendorID', isEqualTo: authID)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return errorWidget(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingWidget();
            }
            if (snapshot.data!.docs.isNotEmpty) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 1 / 1.4),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    List<ProductModel> productModel = snapshot.data!.docs
                        .map((doc) => ProductModel.fromFirestore(doc))
                        .toList();
                    var product = productModel[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                        productID: product.productID))),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                height: 80,
                                width: 80,
                                child: Column(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: CachedNetworkImage(
                                              imageUrl: product.imageURL,
                                              fit: BoxFit.cover))),
                                  const SizedBox(height: 10),
                                  Text(product.productName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10),
                                      maxLines: 2)
                                ]))));
                  });
            }
            return emptyWidget('NO PUBLISHED PRODUCTS');
          })));
}
