import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/widget/api_widgets.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('vendorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorWidget(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget();
        }
        if (snapshot.data!.docs.isNotEmpty) {
          var orders = snapshot.data!.docs;
          return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var tileColor =
                    index % 2 == 0 ? Colors.grey.shade100 : Colors.white;
                var order = orders[index];
                int quantity = order['productIDs'].length;
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('customers')
                        .where('customerID', isEqualTo: order['customerID'])
                        .get(),
                    builder: (context, cSnapshot) {
                      if (cSnapshot.hasError) {
                        return errorWidget(cSnapshot.error.toString());
                      }
                      if (cSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return loadingWidget();
                      }
                      if (cSnapshot.data!.docs.isNotEmpty) {
                        var customer = cSnapshot.data!.docs[0];
                        return ListTile(
                            onTap: () {},
                            dense: true,
                            tileColor: tileColor,
                            leading: SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(customer['logo'],
                                        fit: BoxFit.cover))),
                            title: Text(customer['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(quantity > 1
                                ? '$quantity items'
                                : '$quantity item'),
                            trailing: Text(
                                'P ${order['totalPayment'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)));
                      }
                      return emptyWidget('CUSTOMER NOT FOUND');
                    });
              });
        }
        return emptyWidget('NO ORDERS YET');
      });
}
