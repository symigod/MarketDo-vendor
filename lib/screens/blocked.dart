import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/models/block.model.dart';
import 'package:marketdo_app_vendor/screens/main.screen.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({super.key});

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  bool blocksEmpty = true;
  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: blocksCollection.where('blocker', isEqualTo: authID).snapshots(),
      builder: (context, bs) {
        if (bs.hasError) {
          return errorWidget(bs.error.toString());
        }
        if (bs.connectionState == ConnectionState.waiting) {
          return loadingWidget();
        }
        if (bs.data!.docs.isNotEmpty) {
          final blocks = bs.data!.docs;
          return ListView.builder(
              shrinkWrap: blocksEmpty,
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                final blockedCustomers = block['blocked'] as List<dynamic>;
                if (blockedCustomers.isEmpty) {
                  blocksEmpty = true;
                  return emptyWidget('NO BLOCKED CUSTOMERS');
                }
                blocksEmpty = false;
                return StreamBuilder(
                    stream: customersCollection
                        .where('customerID', whereIn: blockedCustomers)
                        .snapshots(),
                    builder: (context, cs) {
                      if (cs.hasError) {
                        return errorWidget(cs.error.toString());
                      }
                      if (cs.connectionState == ConnectionState.waiting) {
                        return loadingWidget();
                      }
                      if (cs.data!.docs.isNotEmpty) {
                        final customer = cs.data!.docs[0];
                        var tileColor = index % 2 == 0
                            ? Colors.grey.shade100
                            : Colors.white;
                        return ListTile(
                            tileColor: tileColor,
                            onTap: () => viewCustomerDetails(
                                context, customer['customerID']),
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
                                            color: Colors.white, width: 2)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                          imageUrl: customer['logo'],
                                          fit: BoxFit.cover),
                                    ))),
                            title: Text(customer['name']),
                            trailing: FittedBox(
                                child: FutureBuilder(
                                    future: ordersCollection
                                        .where('customerID',
                                            isEqualTo: customer['customerID'])
                                        .get(),
                                    builder: (context, os) {
                                      if (os.hasError) {
                                        return errorWidget(os.error.toString());
                                      }
                                      if (os.connectionState ==
                                          ConnectionState.waiting) {
                                        return loadingWidget();
                                      }
                                      if (os.hasData) {
                                        return Text(
                                            '${os.data!.docs.length} ${os.data!.docs.length > 1 ? ' orders' : 'order'}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold));
                                      }
                                      return Text(
                                          '${os.data!.docs.length} none');
                                    })));
                      }
                      return emptyWidget('CUSTOMER NOT FOUND');
                    });
              });
        } else {
          return emptyWidget('NO BLOCKED CUSTOMERS');
        }
      });

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
                                                    : Colors.red,
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
