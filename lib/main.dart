import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/screens/products/add.dart';
import 'package:marketdo_app_vendor/screens/home.dart';
import 'package:marketdo_app_vendor/screens/authentication/login.dart';
import 'package:marketdo_app_vendor/screens/products/main.products.dart';
import 'screens/orders/main.orders.dart';

int marketDoGreen = 0xFF1B5E20;
MaterialColor _marketDoGreen = MaterialColor(marketDoGreen, {
  50: const Color(0xFFE8F5E9),
  100: const Color(0xFFC8E6C9),
  200: const Color(0xFFA5D6A7),
  300: const Color(0xFF81C784),
  400: const Color(0xFF66BB6A),
  500: Color(marketDoGreen),
  600: const Color(0xFF43A047),
  700: const Color(0xFF388E3C),
  800: const Color(0xFF2E7D32),
  900: const Color(0xFF1B5E20)
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

void updateVendorOnlineStatus(String? authID, bool isOnline) =>
    vendorsCollection
        .doc(authID)
        .update({'isOnline': isOnline})
        .then((value) =>
            isOnline == true ? print('VENDOR ONLINE') : print('VENDOR OFFLINE'))
        .catchError(
            (error) => print('Failed to update vendor online status: $error'));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isResumed = false;
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      isResumed = true;
      updateVendorOnlineStatus(authID, true);
    } else {
      isResumed = false;
      updateVendorOnlineStatus(authID, false);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: _marketDoGreen, fontFamily: 'Lato'),
          home: const SplashScreen(),
          builder: EasyLoading.init(),
          routes: {
            LoginScreen.id: (context) => const LoginScreen(),
            HomeScreen.id: (context) => const HomeScreen(),
            ProductScreen.id: (context) => const ProductScreen(),
            AddProductScreen.id: (context) => const AddProductScreen(),
            OrderScreen.id: (context) => const OrderScreen()
          });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset('assets/images/marketdoLogo.png', height: 100, width: 100),
        const SizedBox(height: 10),
        const Text('MarketDo\nVendor',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2))
      ])));
}
