import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/screens/order_screen/history.dart';
import 'package:marketdo_app_vendor/screens/order_screen/pending.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order-screen';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0),
      body: const OrderCard());
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
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
                        child: Text('Pending',
                            style: TextStyle(color: Colors.green.shade900))),
                    Tab(
                        child: Text('History',
                            style: TextStyle(color: Colors.green.shade900)))
                  ])),
          body: const TabBarView(
              children: [PendingOrdersScreen(), OrdersHistoryScreen()])));

  Widget contents(order) {
    // var order = orders[index];
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
        child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Customer: ${order['customerID']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('${order['orderedOn']}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold))
                      ]),
                  const SizedBox(height: 10),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: products.length,
                  //     itemBuilder: (context, index) {
                  //       var productImage = products[index]
                  //               ['imageUrls']
                  //           .toString()
                  //           .replaceAll('[', '')
                  //           .replaceAll(']', '');
                  //       var productName = products[index]['name'];
                  //       var productPrice = products[index]
                  //               ['regularPrice']
                  //           .toString();
                  //       return Padding(
                  //           padding: const EdgeInsets.only(
                  //               bottom: 10.0),
                  //           child: Row(children: [
                  //             SizedBox(
                  //                 height: 50,
                  //                 width: 50,
                  //                 child: Image.network(
                  //                     productImage)),
                  //             const SizedBox(width: 10),
                  //             Column(
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(productName,
                  //                       style: const TextStyle(
                  //                           fontSize: 14,
                  //                           fontWeight:
                  //                               FontWeight.bold)),
                  //                   const SizedBox(height: 10),
                  //                   SizedBox(
                  //                       width: 200,
                  //                       child: Text(productPrice,
                  //                           style: const TextStyle(
                  //                               fontSize: 12,
                  //                               fontWeight:
                  //                                   FontWeight
                  //                                       .bold),
                  //                           overflow:
                  //                               TextOverflow.clip,
                  //                           maxLines: 2)),
                  //                   const SizedBox(height: 10)
                  //                 ])
                  //           ]));
                  //     }),
                  const SizedBox(height: 10),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Text('Shipping Fee',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          // Text(shippingFee.toString(),
                          //     style: const TextStyle(
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.bold))
                        ]),
                        Column(children: [
                          Text('Total Payment',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          // Text(totalAmount.toString(),
                          //     style: const TextStyle(
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.bold))
                        ])
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // setState(
                              //     () => orderStatus = 'Accepted');
                              // updateStatus(uid, 'Accepted');
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor:
                                //     orderStatus == 'Accepted'
                                //         ? Colors.green.shade900
                                //         : Colors.grey,
                                minimumSize: const Size(150, 40)),
                            child: const Text('Accept',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        ElevatedButton(
                            onPressed: () {
                              // setState(() =>
                              //     orderStatus = 'Preparing');
                              // updateStatus(uid, 'Preparing');
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor:
                                //     orderStatus == 'Preparing'
                                //         ? Colors.green.shade900
                                //         : Colors.grey,
                                minimumSize: const Size(150, 40)),
                            child: const Text('Preparing',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)))
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // setState(() =>
                              //     orderStatus = 'On Delivery');
                              // updateStatus(uid, 'On Delivery');
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor:
                                //     orderStatus == 'On Delivery'
                                //         ? Colors.green.shade900
                                //         : Colors.grey,
                                minimumSize: const Size(150, 40)),
                            child: const Text('On Delivery',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        ElevatedButton(
                            onPressed: () {
                              // setState(() =>
                              //     orderStatus = 'Delivered');
                              // updateStatus(uid, 'Delivered');
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor:
                                //     orderStatus == 'Delivered'
                                //         ? Colors.green.shade900
                                //         : Colors.grey,
                                minimumSize: const Size(150, 40)),
                            child: const Text('Delivered',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)))
                      ])
                ]))));
  }

  void updateStatus(String uid, String updateStatus) =>
      FirebaseFirestore.instance
          .collection('orders')
          .where('uid', isEqualTo: uid)
          .get()
          .then((value) {
        for (var order in value.docs) {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(order.id)
              .update({'orderStatus': updateStatus});
        }
      });

  Widget cardWidget(context, String title, List<Widget> contents) => Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(5)),
      child: Column(children: [
        Card(
            color: Colors.green,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)))),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: contents)
      ]));
}
