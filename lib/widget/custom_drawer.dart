import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/provider/vendor_provider.dart';
import 'package:marketdo_app_vendor/screens/add_product_screen.dart';
import 'package:marketdo_app_vendor/screens/home_screen.dart';
import 'package:marketdo_app_vendor/screens/login_screen.dart';
import 'package:marketdo_app_vendor/screens/product_screen.dart';
import 'package:provider/provider.dart';

import '../screens/order screen/order_screen.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {

//     final _vendorData = Provider.of<VendorProvider>(context);
//     Widget _menu({String? menuTitle, IconData? icon, String? route}){
//       return ListTile(
//         leading: Icon(icon),
//           title: Text(menuTitle!),
//            onTap: (){
//             Navigator.pushReplacementNamed(context, route!);
//         },
//       );
//     }

//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             height: 86,
//             color: Theme.of(context).primaryColor,
//             child: Row(
//               children: [
//                 DrawerHeader(
//                   child: _vendorData.doc==null
//                   ? const Text (
//                     'Fetching...',
//                     style: TextStyle(
//                       color: Colors.white))
//                 : Row(
//                   children: [
//                     Row(
//                       children: [
//                         CachedNetworkImage(
//                           imageUrl: _vendorData.doc!['logo']),
//                           const SizedBox(width: 10,),
//                         Text( _vendorData.doc!['businessName'],
//                         style:const TextStyle(color: Colors.white),),
//                       ],
//                     ),
//                   ],
//                 )),
//               ],
//             )),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _menu(
//                   menuTitle: 'Home',
//                   icon: Icons.home_outlined,
//                   route: HomeScreen.id
//                 ),
//                 ExpansionTile(
//                   leading: const Icon(Icons.weekend_outlined),
//                   title: const Text('Products'),
//                   children: [
//                     _menu(
//                       menuTitle: 'All products',
//                       route: ProductScreen.id
//                     ),
//                     _menu(
//                       menuTitle: 'Add products',
//                       route: AddProductScreen.id
//                     ),

//                   ],

//                 ),
//                 _menu(
//                   menuTitle: 'Orders',
//                   icon: Icons.shopping_cart_checkout_outlined,
//                   route: OrderScreen.id
//                 ),
//               ],
//             ),
//           ),
//           const Divider(
//             color: Colors.grey,
//           ),
//             ListTile(
//               title: const Text('Signout'),
//               trailing: const Icon(Icons.exit_to_app),
//               onTap: (){
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacementNamed(context, LoginScreen.id);
//               },
//             ),

//         ],

//       ),

//     );
//   }
// }

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isActive = true;

  void _updateStatus(bool value) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final vendorDoc = FirebaseFirestore.instance
          .collection('vendor')
          .doc(firebaseUser.uid);
      final docSnapshot = await vendorDoc.get();

      if (docSnapshot.exists) {
        await vendorDoc.update({'isActive': value});
      } else {
        print('Document does not exist!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorData = Provider.of<VendorProvider>(context);

    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(menuTitle!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 86,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                DrawerHeader(
                  child: vendorData.doc == null
                      ? const Text('Fetching...',
                          style: TextStyle(color: Colors.white))
                      : Row(
                          children: [
                            CachedNetworkImage(
                                imageUrl: vendorData.doc!['logo']),
                            const SizedBox(width: 10),
                            Text(vendorData.doc!['businessName'],
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _menu(
                    menuTitle: 'Home',
                    icon: Icons.home_outlined,
                    route: HomeScreen.id),
                ExpansionTile(
                  leading: const Icon(Icons.weekend_outlined),
                  title: const Text('Products'),
                  children: [
                    _menu(menuTitle: 'All products', route: ProductScreen.id),
                    _menu(
                        menuTitle: 'Add products', route: AddProductScreen.id),
                  ],
                ),
                _menu(
                    menuTitle: 'Orders',
                    icon: Icons.shopping_cart_checkout_outlined,
                    route: OrderScreen.id),
                ListTile(
                  title: Text(
                    _isActive ? 'Active' : 'Not Active',
                    style: TextStyle(
                      color: _isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                      _updateStatus(value);
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text('Signout'),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
