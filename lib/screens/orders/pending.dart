import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/models/block.model.dart';
import 'package:marketdo_app_vendor/models/product.model.dart';
import 'package:marketdo_app_vendor/screens/main.screen.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  bool isDelivered = false;
  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: ordersCollection
          .where('vendorID', isEqualTo: authID)
          .where('isDelivered', isEqualTo: isDelivered)
          .orderBy('orderedOn')
          .snapshots(),
      builder: (context, os) {
        if (os.hasError) {
          return errorWidget(os.error.toString());
        }
        if (os.connectionState == ConnectionState.waiting) {
          return loadingWidget();
        }
        if (os.data!.docs.isNotEmpty) {
          var orders = os.data!.docs;
          return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var tileColor =
                    index % 2 == 0 ? Colors.grey.shade100 : Colors.white;
                var order = orders[index];
                int quantity = order['productIDs'].length;
                return FutureBuilder(
                    future: customersCollection
                        .where('customerID', isEqualTo: order['customerID'])
                        .get(),
                    builder: (context, cs) {
                      if (cs.hasError) {
                        return errorWidget(cs.error.toString());
                      }
                      if (cs.connectionState == ConnectionState.waiting) {
                        return loadingWidget();
                      }
                      if (cs.data!.docs.isNotEmpty) {
                        var customer = cs.data!.docs[0];
                        return StreamBuilder(
                            stream: blocksCollection
                                .where('blocker', isEqualTo: authID)
                                .where('blocked',
                                    arrayContains: order['customerID'])
                                .snapshots(),
                            builder: (context, bs) {
                              if (bs.hasError) {
                                return errorWidget(bs.error.toString());
                              }
                              if (bs.connectionState ==
                                  ConnectionState.waiting) {
                                return loadingWidget();
                              }
                              if (bs.data!.docs.isEmpty) {
                                return ListTile(
                                    onTap: () => viewOrderDetails(
                                        order['orderID'], order['customerID']),
                                    dense: true,
                                    tileColor: tileColor,
                                    leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: customer['isOnline']
                                                    ? Colors.green
                                                    : Colors.grey,
                                                width: 2)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                  imageUrl: customer['logo'],
                                                  fit: BoxFit.cover),
                                            ))),
                                    title: Text(customer['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Lato'),
                                            children: [
                                          TextSpan(
                                              text: quantity > 1
                                                  ? '$quantity items'
                                                  : '$quantity item',
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          TextSpan(
                                            text:
                                                '\n${dateTimeToString(order['orderedOn'])}',
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          )
                                        ])),
                                    trailing: Text(
                                        'P ${numberToString(order['totalPayment'].toDouble())}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)));
                              } else {
                                return const SizedBox.shrink();
                              }
                            });
                      }
                      return emptyWidget('CUSTOMER NOT FOUND');
                    });
              });
        }
        return emptyWidget('NO ORDERS YET');
      });

  viewOrderDetails(String orderID, String customerID) => showDialog(
      context: context,
      builder: (_) => StreamBuilder(
          stream: ordersCollection
              .where('customerID', isEqualTo: customerID)
              .where('orderID', isEqualTo: orderID)
              .snapshots(),
          builder: (context, os) {
            if (os.hasError) {
              return errorWidget(os.error.toString());
            }
            if (os.connectionState == ConnectionState.waiting) {
              return loadingWidget();
            }
            if (os.hasData) {
              var order = os.data!.docs[0];
              List<dynamic> products = order['productIDs'];
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    scrollable: true,
                    titlePadding: EdgeInsets.zero,
                    title: FutureBuilder(
                        future: customersCollection
                            .where('customerID', isEqualTo: order['customerID'])
                            .get(),
                        builder: (context, cs) {
                          if (cs.hasError) {
                            return errorWidget(cs.error.toString());
                          }
                          if (cs.connectionState == ConnectionState.waiting) {
                            return loadingWidget();
                          }
                          if (cs.data!.docs.isNotEmpty) {
                            var customer = cs.data!.docs[0];
                            return Card(
                                color: Colors.green,
                                margin: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3))),
                                child: ListTile(
                                    onTap: () => viewCustomerDetails(
                                        context, customerID),
                                    leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: customer['isOnline']
                                                    ? Colors.green.shade900
                                                    : Colors.grey,
                                                width: 2)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child:
                                                    CachedNetworkImage(imageUrl: customer['logo'], fit: BoxFit.cover)))),
                                    title: Text(customer['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    trailing: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white))));
                          }
                          return emptyWidget('CUSTOMER NOT FOUND');
                        }),
                    contentPadding: EdgeInsets.zero,
                    content: Column(children: [
                      ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text('Ordered on:'),
                          trailing: Text(dateTimeToString(order['orderedOn']),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold))),
                      FutureBuilder(
                          future: Future.wait(products.map((productId) =>
                              productsCollection.doc(productId).get())),
                          builder: (context, ps) {
                            if (ps.connectionState == ConnectionState.waiting) {
                              return loadingWidget();
                            }
                            if (ps.hasError) {
                              return errorWidget(ps.error.toString());
                            }
                            if (!ps.hasData || ps.data!.isEmpty) {
                              return emptyWidget('PRODUCT NOT FOUND');
                            }
                            List<DocumentSnapshot> productSnapshots = ps.data!;
                            List<ProductModel> productList = productSnapshots
                                .map((doc) => ProductModel.fromFirestore(doc))
                                .toList();

                            return ExpansionTile(
                                leading: const Icon(Icons.shopping_bag),
                                title: const Text('Products:'),
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: productList.length,
                                      itemBuilder: (context, index) {
                                        ProductModel product =
                                            productList[index];
                                        int pIndex = productList
                                            .indexOf(productList[index]);
                                        double payments =
                                            order['payments'][pIndex];
                                        double unitsBought =
                                            order['unitsBought'][pIndex];
                                        return ListTile(
                                            dense: true,
                                            leading: CachedNetworkImage(
                                                imageUrl: product.imageURL,
                                                fit: BoxFit.cover),
                                            title: RichText(
                                                text: TextSpan(
                                                    style: const TextStyle(
                                                        fontFamily: 'Lato'),
                                                    children: [
                                                  TextSpan(
                                                      text: product.productName,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          ' [$unitsBought ${product.unit}/s]',
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ])),
                                            subtitle: Text(product.description),
                                            trailing: Text(
                                                'P ${numberToString(payments)}',
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)));
                                      })
                                ]);
                          }),
                      ListTile(
                          leading: const Icon(Icons.payments),
                          title: const Text('Total Payment:'),
                          trailing: Text(
                              'P ${order['totalPayment'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))),
                    ]),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      SwitchListTile(
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: Colors.red.shade300,
                          title: Text(
                              order['isDelivered'] ? 'Pending' : 'Delivered'),
                          value: !order['isDelivered'],
                          onChanged: (newValue) {
                            setState(() => isDelivered = !newValue);
                            updateOrderStatus(order['orderID'], !newValue);
                          })
                    ]);
              });
            }
            return emptyWidget('ORDER NOT FOUND');
          }));

  viewCustomerDetails(context, String customerID) => showDialog(
      context: context,
      builder: (_) => FutureBuilder(
          future: customersCollection
              .where('customerID', isEqualTo: customerID)
              .get(),
          builder: (context, cs) {
            if (cs.hasError) {
              return errorWidget(cs.error.toString());
            }
            if (cs.connectionState == ConnectionState.waiting) {
              return loadingWidget();
            }
            if (cs.data!.docs.isNotEmpty) {
              var customer = cs.data!.docs[0];
              return AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  content: Column(children: [
                    SizedBox(
                        height: 150,
                        child: DrawerHeader(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              customer['coverPhoto']),
                                          fit: BoxFit.cover))),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: customer['isOnline']
                                                    ? Colors.green
                                                    : Colors.grey,
                                                width: 3)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(130),
                                                child: CachedNetworkImage(
                                                    imageUrl: customer['logo'],
                                                    fit: BoxFit.cover))))
                                  ])
                            ]))),
                    ListTile(
                        dense: true,
                        isThreeLine: true,
                        leading: const Icon(Icons.person),
                        title: Text(customer['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: FittedBox(
                            child: Text(
                                'Customer ID:\n${customer['customerID']}'))),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.perm_phone_msg),
                        title: Text(customer['mobile']),
                        subtitle: Text(customer['email'])),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.location_on),
                        title: Text(customer['address']),
                        subtitle: Text(customer['landMark'])),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.date_range),
                        title: const Text('REGISTERED ON:'),
                        subtitle:
                            Text(dateTimeToString(customer['registeredOn'])))
                  ]),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    StreamBuilder(
                        stream: blocksCollection
                            .where('blocked', arrayContains: customerID)
                            .where('blocker', isEqualTo: authID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                onPressed: () =>
                                    unblockCustomer(context, customerID),
                                child: const Text('Unblock'));
                          }
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () =>
                                  blockCustomer(context, customerID),
                              child: const Text('Block'));
                        }),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'))
                  ]);
            }
            return emptyWidget('VENDOR NOT FOUND');
          }));
  updateOrderStatus(String orderID, bool isDelivered) => showDialog(
      context: context,
      builder: (_) => confirmDialog(
          context,
          'Order Delivered',
          'This order will be set as delivered. Once delivered, you cannot undo this. Do you want to continue?',
          () => ordersCollection
              .doc(orderID)
              .update({'isDelivered': isDelivered})
              .then((value) => Navigator.pop(context))
              .catchError(
                  (error) => print('Failed to update order status: $error'))));

  blockCustomer(context, String customerID) => showDialog(
      context: context,
      builder: (_) => confirmDialog(
              context, 'BLOCK CUSTOMER', 'Do you want to continue?', () async {
            final querySnapshot = await blocksCollection
                .where('blocker', isEqualTo: authID)
                .get();
            if (querySnapshot.docs.isNotEmpty) {
              final batch = FirebaseFirestore.instance.batch();
              for (var doc in querySnapshot.docs) {
                batch.update(doc.reference, {
                  'blocked': FieldValue.arrayUnion([customerID])
                });
              }
              showDialog(
                  context: context,
                  builder: (_) =>
                      successDialog(context, 'Customer blocked!')).then(
                  (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false));
              await batch.commit();
            } else {
              final blockedCustomerData =
                  BlockModel(blocker: authID, blocked: [customerID]);
              await blocksCollection
                  .doc(authID)
                  .set(blockedCustomerData.toFirestore())
                  .then((value) => showDialog(
                      context: context,
                      builder: (_) =>
                          successDialog(context, 'Customer blocked!')).then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                          (route) => false)))
                  .catchError((error) => showDialog(
                      context: context,
                      builder: (_) => errorDialog(context, error.toString())));
            }
          }));

  unblockCustomer(context, String customerID) => showDialog(
      context: context,
      builder: (_) =>
          confirmDialog(context, 'UNBLOCK CUSTOMER', 'Do you want to continue?',
              () async {
            Navigator.pop(context);
            final querySnapshot = await blocksCollection
                .where('blocker', isEqualTo: authID)
                .where('blocked', arrayContains: customerID)
                .get();
            if (querySnapshot.docs.isNotEmpty) {
              final batch = FirebaseFirestore.instance.batch();
              for (var doc in querySnapshot.docs) {
                batch.update(doc.reference, {
                  'blocked': FieldValue.arrayRemove([customerID])
                });
              }
              await batch.commit();
              showDialog(
                  context: context,
                  builder: (_) =>
                      successDialog(context, 'Customer unblocked!')).then(
                  (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false));
            } else {
              showDialog(
                  context: context,
                  builder: (_) =>
                      errorDialog(context, 'Customer is not blocked.'));
            }
          }));
}
