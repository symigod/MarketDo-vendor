import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => const Center(
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  fontSize: 24, fontWeight: FontWeight.bold))
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
                                  fontSize: 24, fontWeight: FontWeight.bold))
                        ])))
          ])));
}
