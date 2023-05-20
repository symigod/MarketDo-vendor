import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/widget/custom_drawer.dart';
import 'package:marketdo_app_vendor/widget/products/un_published.dart';

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
          title: const Text('Product List'),
          elevation: 0,
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 6,
                color: Colors.purpleAccent
              )
            ),
            tabs: [
              Tab(
                child: Text('Un-published'),
              ),
               Tab(
                child: Text('Published'),
              ),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body: const TabBarView(
          children: [
            UnPublishedProduct(),
            PublishedProduct(),
          ]),
      ),
    );
  }
  }





 // body: const TabBarView(
        //   children: [
        //     UnPublishedProduct(),
        //     PublishedTab(),
        //   ],
        //   ),