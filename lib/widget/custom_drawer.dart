import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketdo_app_vendor/model/vendor_model.dart';
import 'package:marketdo_app_vendor/screens/login_screen.dart';
import 'package:marketdo_app_vendor/widget/api_widgets.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isActive = true;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  _updateStatus(bool value) async {
    if (firebaseUser != null) {
      final vendorDoc = FirebaseFirestore.instance
          .collection('vendor')
          .doc(firebaseUser!.uid);
      final docSnapshot = await vendorDoc.get();
      if (docSnapshot.exists && context.mounted) {
        setState(() => _isActive = value);
        await vendorDoc.update({'isActive': value});
      } else {
        showDialog(
            context: context,
            builder: (_) => errorDialog(context, 'Vendor not found!'));
      }
    }
  }

  Future<VendorModel> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vendor')
        .doc(firebaseUser!.uid)
        .get();
    return VendorModel.fromFirestore(snapshot);
  }

  @override
  Widget build(BuildContext context) {
    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
          leading: Icon(icon),
          title: Text(menuTitle!),
          onTap: () => Navigator.pushReplacementNamed(context, route!));
    }

    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return errorWidget(snapshot.error.toString());
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return streamLoadingWidget();
          // }
          if (snapshot.hasData) {
            var vendor = snapshot.data!;
            Timestamp timestamp = vendor.registeredOn;
            DateTime dateTime = timestamp.toDate();
            String registeredOn =
                DateFormat('MMM dd, yyyy').format(dateTime).toString();
            return Drawer(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
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
                                      image: DecorationImage(
                                          image: NetworkImage(vendor.shopImage),
                                          fit: BoxFit.cover))),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: 125,
                                        width: 125,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(vendor.logo),
                                                fit: BoxFit.cover)))
                                  ])
                            ]))),
                    ListTile(
                        dense: true,
                        isThreeLine: true,
                        leading: const Icon(Icons.store),
                        title: Text(vendor.businessName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Vendor ID: ${vendor.vendorID}')),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.perm_phone_msg),
                        title: Text(vendor.mobile),
                        subtitle: Text(vendor.email)),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.location_on),
                        title: Text(
                            '${vendor.city}, ${vendor.state}, ${vendor.country}'),
                        subtitle: Text(vendor.landMark)),
                    ListTile(
                        dense: true,
                        isThreeLine: true,
                        leading: const Icon(Icons.numbers),
                        title: Text('PIN CODE: ${vendor.pinCode}'),
                        subtitle: Text(
                            'TIN: ${vendor.tin}\nTAX REGISTERED: ${vendor.isTaxRegistered == true ? 'YES' : 'NO'}')),
                    ListTile(
                        dense: true,
                        leading: const Icon(Icons.date_range),
                        title: const Text('REGISTERED ON:'),
                        subtitle: Text(registeredOn))
                  ]))),
                  // _menu(menuTitle: 'Home', icon: Icons.home_outlined, route: HomeScreen.id),
                  // ExpansionTile(
                  //     leading: const Icon(Icons.weekend_outlined),
                  //     title: const Text('Products'),
                  //     children: [
                  //       _menu(menuTitle: 'All products', route: ProductScreen.id),
                  //       _menu(menuTitle: 'Add products', route: AddProductScreen.id),
                  //     ]),
                  // _menu(
                  //     menuTitle: 'Orders',
                  //     icon: Icons.shopping_cart_checkout_outlined,
                  //     route: OrderScreen.id),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ListTile(
                        dense: true,
                        title: Text(
                            _isActive
                                ? 'Active Status (ON)'
                                : 'Active Status (OFF)',
                            style: TextStyle(
                                color: _isActive
                                    ? Colors.green.shade900
                                    : Colors.red,
                                fontWeight: FontWeight.bold)),
                        trailing: Switch(
                            value: _isActive,
                            onChanged: (value) => _updateStatus(value),
                            activeColor: Colors.green.shade900,
                            inactiveThumbColor: Colors.red)),
                    ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (_) => confirmDialog(context, 'LOGOUT',
                                    'Do you want to continue?', () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.id);
                                })),
                        dense: true,
                        tileColor: Colors.red,
                        title: const Text('Logout MarketDo App',
                            style: TextStyle(color: Colors.white)),
                        trailing:
                            const Icon(Icons.exit_to_app, color: Colors.white))
                  ])
                ]));
          }
          return emptyWidget('VENDOR NOT FOUND');
        });
  }
}
