import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/screens/add_product_screen.dart';
import 'package:marketdo_app_vendor/widget/products/un_published.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../widget/products/published_product.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 0,
                bottom: TabBar(
                    indicator: DotIndicator(
                        color: Colors.green.shade900,
                        distanceFromCenter: 16,
                        radius: 3,
                        paintingStyle: PaintingStyle.fill),
                    tabs: [
                      Tab(
                          child: Text('Published',
                              style: TextStyle(color: Colors.green.shade900))),
                      Tab(
                          child: Text('Unpublished',
                              style: TextStyle(color: Colors.green.shade900))),
                      Tab(
                          child: Text('Add New',
                              style: TextStyle(color: Colors.green.shade900)))
                    ])),
            body: const TabBarView(children: [
              PublishedProduct(),
              UnPublishedProduct(),
              AddProductScreen()
            ])));
  }
}
