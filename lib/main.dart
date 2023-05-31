import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:marketdo_app_vendor/screens/add_product_screen.dart';
import 'package:marketdo_app_vendor/screens/home_screen.dart';
import 'package:marketdo_app_vendor/screens/login_screen.dart';
import 'package:marketdo_app_vendor/screens/product_Screen.dart';
import 'package:provider/provider.dart';
import 'screens/order_screen/order_screen.dart';

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
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(providers: [
    // Provider<VendorProvider>(create: (_) => VendorProvider()),
    Provider<ProductProvider>(create: (_) => ProductProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  Widget build(BuildContext context) => const Scaffold(
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('MarketDo\nVendor',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2)),
        Text('Vendor', style: TextStyle(fontSize: 20))
      ])));
}
