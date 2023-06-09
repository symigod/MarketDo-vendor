import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/widget/products/published_product.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0),
      body: const PublishedProduct());
}
