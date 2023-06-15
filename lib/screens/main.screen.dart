import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/main.dart';
import 'package:marketdo_app_vendor/screens/products/add.dart';
import 'package:marketdo_app_vendor/screens/orders/main.orders.dart';
import 'package:marketdo_app_vendor/screens/products/main.products.dart';
import 'package:marketdo_app_vendor/widget/drawer.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      updateVendorOnlineStatus(authID, true);
    }
  }

  List<Widget> screens = [
    const ProductScreen(),
    const OrderScreen(),
    const ProductScreen()
  ];
  int currentScreen = 0;
  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.green.shade900,
              centerTitle: true,
              title: const FittedBox(
                  child: Text('MarketDo App',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2))),
              actions: [
                IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => errorDialog(
                            context, 'This feature will be available soon!')),
                    icon: const Icon(Icons.notifications, color: Colors.white))
              ]),
          drawer: const CustomDrawer(),
          body: screens[currentScreen],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProductScreen())),
              backgroundColor: Colors.green.shade900,
              child: const Icon(Icons.add)),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.green.shade900,
              currentIndex: currentScreen,
              onTap: (int index) => setState(() => currentScreen = index),
              selectedItemColor: Colors.yellow,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.white,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.store), label: 'My Products'),
                BottomNavigationBarItem(
                    icon: Stack(children: [
                      const Icon(Icons.shopping_bag),
                      StreamBuilder(
                          stream: ordersCollection
                              .where('vendorID', isEqualTo: authID)
                              .where('isPending', isEqualTo: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return errorWidget(snapshot.error.toString());
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Positioned(
                                  right: 0, top: 0, child: Container());
                            }
                            return Positioned(
                                right: 0,
                                top: 0,
                                child: snapshot.data!.docs.isEmpty
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                        constraints: const BoxConstraints(
                                            minWidth: 12, minHeight: 12),
                                        child: Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center)));
                          })
                    ]),
                    label: 'Orders'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.block), label: 'Blocked')
              ])));
}
