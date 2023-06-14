import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

Widget confirmDialog(
        context, String title, String message, void Function() onPressed) =>
    AlertDialog(title: Text(title), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('NO', style: TextStyle(color: Colors.red))),
      TextButton(
          onPressed: onPressed,
          child: Text('YES', style: TextStyle(color: Colors.green.shade900)))
    ]);

Widget errorDialog(BuildContext context, String message) =>
    AlertDialog(title: const Text('ERROR'), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text('OK'))
    ]);

Widget successDialog(BuildContext context, String message) =>
    AlertDialog(title: const Text('SUCCESS'), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text('OK'))
    ]);

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
                          child: Stack(alignment: Alignment.center, children: [
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: FittedBox(
                          child:
                              Text('Customer ID:\n${customer['customerID']}'))),
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
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'))
                ]);
          }
          return emptyWidget('VENDOR NOT FOUND');
        }));

String dateTimeToString(Timestamp timestamp) =>
    DateFormat('MMM dd, yyyy').format(timestamp.toDate()).toString();

String numberToString(double number) => NumberFormat('#, ###').format(number);

String unitAbbreviation(String? selectedValue) {
  RegExp regex = RegExp(r'\((.*?)\)');
  Match? match = regex.firstMatch(selectedValue!);
  String abbreviation = match?.group(1) ?? '';
  return abbreviation;
}

String extractUnitText(String? selectedUnit) {
  if (selectedUnit != null) {
    int startIndex = selectedUnit.indexOf('(');
    int endIndex = selectedUnit.indexOf(')');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return selectedUnit.substring(startIndex + 1, endIndex);
    }
  }
  return '';
}
