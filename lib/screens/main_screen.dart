import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketdo_app_vendor/screens/add_product_screen.dart';
import 'package:marketdo_app_vendor/screens/login_screen.dart';
import 'package:marketdo_app_vendor/screens/order%20screen/order_screen.dart';
import 'package:marketdo_app_vendor/screens/product_screen.dart';
import 'package:marketdo_app_vendor/widget/custom_drawer.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [const ProductScreen(), const OrderScreen()];
  int currentScreen = 0;
  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.green.shade900,
              centerTitle: true,
              title: const Text('MarketDo Vendor',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                    onPressed: () => logout(),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white))
              ]),
          drawer: const CustomDrawer(),
          body: screens[currentScreen],
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen())),
              backgroundColor: Colors.green.shade900,
              child: const Icon(Icons.add_business)),
          bottomNavigationBar: BottomAppBar(
              color: Colors.green.shade900,
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.boxOpen,
                                color: currentScreen == 0
                                    ? Colors.yellow
                                    : Colors.white,
                                size: currentScreen == 0 ? 20 : 15),
                            onPressed: () {
                              setState(() => currentScreen = 0);
                            }),
                        IconButton(
                            icon: Icon(Icons.shopping_cart,
                                color: currentScreen == 1
                                    ? Colors.yellow
                                    : Colors.white,
                                size: currentScreen == 1 ? 25 : 20),
                            onPressed: () {
                              setState(() => currentScreen = 1);
                            }),
                        const SizedBox(width: 50)
                      ])))));
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
