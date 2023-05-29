import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/provider/vendor_provider.dart';
import 'package:provider/provider.dart';

import '../widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorData = Provider.of<VendorProvider>(context);
    if (vendorData.doc == null) {
      vendorData.getVendorData();
    }
    return Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Dashboard')),
        drawer: const CustomDrawer(),
        body: const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Card(
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        width: 200,
                                        child: Text('Published Products',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    SizedBox(height: 8.0),
                                    Text('4',
                                        // '${_vendorData.publishedProducts.length}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold))
                                  ]))),
                      SizedBox(height: 16.0),
                      Card(
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        width: 200,
                                        child: Text('Orders',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    SizedBox(height: 8.0),
                                    Text('3',
                                        // '${_vendorData.unpublishedProducts.length}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold))
                                  ])))
                    ]))));
  }
}


// return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     title: const Text('Dashboard'),
    //   ),
    //   drawer: const CustomDrawer(),
    //   body: const Center(
    //     child: Text(
    //       'Dashboard', 
    //       style: TextStyle(
    //         fontSize: 22
    //         ),
    //   ),
    //   ),
    // );