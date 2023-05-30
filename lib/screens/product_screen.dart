import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/widget/products/un_published.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../widget/products/published_product.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: FittedBox(
                    child: Text('PRODUCTS',
                        style: TextStyle(color: Colors.green.shade900))),
                bottom: TabBar(
                    indicator: DotIndicator(
                        color: Colors.green.shade900,
                        distanceFromCenter: 16,
                        radius: 3,
                        paintingStyle: PaintingStyle.fill),
                    tabs: [
                      Tab(
                          child: Text('PUBLISHED',
                              style: TextStyle(color: Colors.green.shade900))),
                      Tab(
                          child: Text('UNPUBLISHED',
                              style: TextStyle(color: Colors.green.shade900)))
                    ])),
            body: const TabBarView(
                children: [PublishedProduct(), UnPublishedProduct()])));
  }
}
