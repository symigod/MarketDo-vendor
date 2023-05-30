import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/model/order_model.dart';

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
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title:
              Text('ORDERS', style: TextStyle(color: Colors.green.shade900))),
      body: const OrderCard());
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('NO ORDERS YET'));
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // var address = snapshot.data![index].address;
                var customerName = snapshot.data![index].customerName;
                // var email = snapshot.data![index].email;
                // var landMark = snapshot.data![index].landMark;
                // var mobile = snapshot.data![index].mobile;
                var orderStatus = snapshot.data![index].orderStatus;
                // var paymentMethod = snapshot.data![index].paymentMethod;
                var products = snapshot.data![index].products;
                var shippingFee = snapshot.data![index].shippingFee;
                // var shippingMethod = snapshot.data![index].shippingMethod;
                var timeStamp = snapshot.data![index].time;
                var totalAmount = snapshot.data![index].totalAmount;
                // var totalPrice = snapshot.data![index].totalPrice;
                var uid = snapshot.data![index].uid;
                // var vendorName = snapshot.data![index].vendorName;
                String month = timeStamp.toDate().month.toString();
                String day = timeStamp.toDate().day.toString();
                String year = timeStamp.toDate().year.toString();
                String time = '$month-$day-$year';
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                    child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Customer: $customerName',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(time,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                  ]),
                              const SizedBox(height: 10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    var productImage = products[index]
                                            ['imageUrls']
                                        .toString()
                                        .replaceAll('[', '')
                                        .replaceAll(']', '');
                                    var productName = products[index]['name'];
                                    var productPrice = products[index]
                                            ['regularPrice']
                                        .toString();
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Row(children: [
                                          SizedBox(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  Image.network(productImage)),
                                          const SizedBox(width: 10),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(productName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                    width: 200,
                                                    child: Text(productPrice,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        maxLines: 2)),
                                                const SizedBox(height: 10)
                                              ])
                                        ]));
                                  }),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(children: [
                                      const Text('Shipping Fee',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text(shippingFee.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Column(children: [
                                      const Text('Total Payment',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text(totalAmount.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))
                                    ])
                                  ]),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(
                                              () => orderStatus = 'Accepted');
                                          updateStatus(uid, 'Accepted');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                orderStatus == 'Accepted'
                                                    ? Colors.green.shade900
                                                    : Colors.grey,
                                            minimumSize: const Size(150, 40)),
                                        child: const Text('Accept',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(
                                              () => orderStatus = 'Preparing');
                                          updateStatus(uid, 'Preparing');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                orderStatus == 'Preparing'
                                                    ? Colors.green.shade900
                                                    : Colors.grey,
                                            minimumSize: const Size(150, 40)),
                                        child: const Text('Preparing',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)))
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() =>
                                              orderStatus = 'On Delivery');
                                          updateStatus(uid, 'On Delivery');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                orderStatus == 'On Delivery'
                                                    ? Colors.green.shade900
                                                    : Colors.grey,
                                            minimumSize: const Size(150, 40)),
                                        child: const Text('On Delivery',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(
                                              () => orderStatus = 'Delivered');
                                          updateStatus(uid, 'Delivered');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                orderStatus == 'Delivered'
                                                    ? Colors.green.shade900
                                                    : Colors.grey,
                                            minimumSize: const Size(150, 40)),
                                        child: const Text('Delivered',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)))
                                  ])
                            ]))));
              });
        });
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
}
