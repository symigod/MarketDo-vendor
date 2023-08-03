import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/main.dart';
import 'package:marketdo_app_vendor/screens/blocked.dart';
import 'package:marketdo_app_vendor/screens/products/add.product.dart';
import 'package:marketdo_app_vendor/screens/orders/main.orders.dart';
import 'package:marketdo_app_vendor/screens/products/main.products.dart';
import 'package:marketdo_app_vendor/widget/drawer.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      updateVendorOnlineStatus(authID, true);
    }
  }

  List<Widget> screens = const [
    ProductsScreen(),
    // CategoryScreen(),
    OrderScreen(),
    BlockedScreen()
  ];

  @override
  Widget build(BuildContext context) => FirebaseAuth.instance.currentUser ==
          null
      ? loadingWidget()
      : SafeArea(
          child: StreamBuilder(
              stream: vendorsCollection
                  .where('vendorID', isEqualTo: authID)
                  .snapshots(),
              builder: (context, vs) {
                if (vs.hasData) {
                  return Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.green.shade900,
                          title: ListTile(
                              title: const Text('Welcome to MarketDo',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${vs.data!.docs[0]['businessName']}!',
                                  style: const TextStyle(color: Colors.white))),
                          actions: [
                            GestureDetector(
                                onTap: () =>
                                    _scaffoldKey.currentState?.openEndDrawer(),
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                vs.data!.docs[0]['logo']),
                                            fit: BoxFit.cover))))
                          ]),
                      endDrawer: const CustomDrawer(),
                      body: Center(child: screens.elementAt(currentScreen)),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.miniEndFloat,
                      floatingActionButton: FloatingActionButton(
                          mini: true,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen())),
                          backgroundColor: Colors.green.shade900,
                          child: const Icon(Icons.add_business)),
                      bottomNavigationBar: BottomNavigationBar(
                          elevation: 0,
                          backgroundColor: Colors.green.shade900,
                          currentIndex: currentScreen,
                          onTap: (int index) =>
                              setState(() => currentScreen = index),
                          type: BottomNavigationBarType.fixed,
                          showUnselectedLabels: true,
                          selectedItemColor: Colors.yellow,
                          unselectedItemColor: Colors.white,
                          items: [
                            const BottomNavigationBarItem(
                                icon: Icon(Icons.store), label: 'My Products'),
                            // const BottomNavigationBarItem(
                            //     icon: Icon(Icons.category),
                            //     label: 'Categories'),
                            BottomNavigationBarItem(
                                icon: Stack(children: [
                                  const Icon(Icons.shopping_bag),
                                  StreamBuilder(
                                      stream: ordersCollection
                                          .where('vendorID', isEqualTo: authID)
                                          .where('isDelivered',
                                              isEqualTo: false)
                                          .snapshots(),
                                      builder: (context, os) {
                                        if (os.hasError) {
                                          return errorWidget(
                                              os.error.toString());
                                        }
                                        if (os.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox.shrink();
                                        }
                                        if (os.data!.docs.isNotEmpty) {
                                          return StreamBuilder(
                                              stream: blocksCollection
                                                  .where('blocker',
                                                      isEqualTo: authID)
                                                  .where('blocked',
                                                      arrayContains:
                                                          os.data!.docs[0]
                                                              ['customerID'])
                                                  .snapshots(),
                                              builder: (context, bs) {
                                                if (bs.hasError) {
                                                  return errorWidget(
                                                      bs.error.toString());
                                                }
                                                if (bs.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                if (bs.hasData) {
                                                  return Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: os.data!.docs.isEmpty
                                                          ? Container()
                                                          : Container(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                      2),
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      minWidth:
                                                                          12,
                                                                      minHeight:
                                                                          12),
                                                              child: Text(
                                                                  os.data!.docs
                                                                      .length
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.bold),
                                                                  textAlign: TextAlign.center)));
                                                }
                                                return const SizedBox.shrink();
                                              });
                                        }
                                        return const SizedBox.shrink();
                                      })
                                ]),
                                label: 'Orders'),
                            const BottomNavigationBarItem(
                                icon: Icon(Icons.block), label: 'Blocked')
                          ]));
                }
                return loadingWidget();
              }));
}
