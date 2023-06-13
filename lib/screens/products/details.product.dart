import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/models/product.model.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productID;
  const ProductDetailScreen({super.key, required this.productID});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Product Details')),
      body: SafeArea(
          child: StreamBuilder(
              stream: productsCollection
                  .where('productID', isEqualTo: widget.productID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return errorWidget(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingWidget();
                }
                if (snapshot.data!.docs.isEmpty) {
                  return emptyWidget('NO PRODUCTS FOUND');
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      List<ProductModel> productModel = snapshot.data!.docs
                          .map((doc) => ProductModel.fromFirestore(doc))
                          .toList();
                      var product = productModel[index];
                      return SingleChildScrollView(
                          child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                            imageUrl: product.imageURL,
                                            fit: BoxFit.cover))))),
                        Column(children: [
                          ListTile(
                              dense: true,
                              leading: const Icon(Icons.info),
                              title: Text(product.productName),
                              subtitle: Text(product.description)),
                          const Divider(height: 0, thickness: 1),
                          ListTile(
                              dense: true,
                              leading: const Icon(Icons.category),
                              title: Text(product.category),
                              subtitle: Text(product.subcategory),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.favorite,
                                        color: Colors.red),
                                    const SizedBox(width: 5),
                                    StreamBuilder(
                                        stream: favoritesCollection
                                            .where('productID',
                                                isEqualTo: product.productID)
                                            .snapshots(),
                                        builder: (context, fs) {
                                          const count = Text('0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold));
                                          if (fs.hasError) {
                                            errorWidget(fs.error.toString());
                                          }
                                          if (fs.connectionState ==
                                              ConnectionState.waiting) {
                                            return count;
                                          }
                                          if (fs.hasData) {
                                            return Text(
                                                fs.data!.docs.length.toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold));
                                          }
                                          return count;
                                        })
                                  ])),
                          const Divider(height: 0, thickness: 1),
                          ListTile(
                              dense: true,
                              leading: const Icon(Icons.payments),
                              title:
                                  Text('Regular Price (per ${product.unit})'),
                              trailing: Text(
                                  'P ${product.regularPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))),
                          const Divider(height: 0, thickness: 1),
                          ListTile(
                              dense: true,
                              leading: const Icon(Icons.delivery_dining),
                              title: const Text('Delivery Fee'),
                              trailing: Text(
                                  'P ${product.shippingCharge.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 100)
                        ])
                      ]));
                    });
              })));
}
