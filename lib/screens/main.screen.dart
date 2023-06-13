import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/screens/products/add.product.dart';
import 'package:marketdo_app_vendor/screens/authentication/login.dart';
import 'package:marketdo_app_vendor/screens/orders/order_screen.dart';
import 'package:marketdo_app_vendor/screens/products/main.products.dart';
import 'package:marketdo_app_vendor/widget/drawer.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'My Products'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag), label: 'Orders'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.block), label: 'Blocked')
              ])));

  Widget bottomBar() {
    return BottomAppBar(
        color: Colors.green.shade900,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(Icons.store,
                          color: currentScreen == 0
                              ? Colors.yellow
                              : Colors.white),
                      onPressed: () {
                        setState(() => currentScreen = 0);
                      }),
                  IconButton(
                      icon: Icon(Icons.shopping_cart,
                          color: currentScreen == 1
                              ? Colors.yellow
                              : Colors.white),
                      onPressed: () {
                        setState(() => currentScreen = 1);
                      }),
                  const SizedBox(width: 50)
                ])));
  }

  logout() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('LOGOUT'),
                content: const Text('Do you want to continue?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('NO',
                          style: TextStyle(color: Colors.red))),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      child: Text('YES',
                          style: TextStyle(color: Colors.green.shade900)))
                ]));
  }
}
