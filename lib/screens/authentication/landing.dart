import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/screens/authentication/login.dart';
import 'package:marketdo_app_vendor/screens/main.screen.dart';
import 'package:marketdo_app_vendor/screens/authentication/registration.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  nextScreen() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FutureBuilder(
          future: vendorsCollection
              .where('vendorID', isEqualTo: currentUser.uid)
              .get(),
          builder: (context, vs) {
            if (vs.hasError) {
              return errorWidget(vs.error.toString());
            }
            if (vs.connectionState == ConnectionState.waiting) {
              return loadingWidget();
            }
            if (vs.data!.docs.isNotEmpty) {
              final vendors = vs.data!.docs;
              for (var vendor in vendors) {
                var vendorID = vendor.get('vendorID');
                if (vendorID != null) {
                  Timer(
                      const Duration(seconds: 1),
                      () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MainScreen())));
                } else {
                  Timer(
                      const Duration(seconds: 1),
                      () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const RegistrationScreen())));
                }
              }
            } else {
              return const RegistrationScreen();
            }
            return loadingWidget();
          });
    } else {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen())));
    }
  }

  @override
  void initState() {
    nextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => nextScreen();
}

class LandingWidget extends StatefulWidget {
  const LandingWidget({super.key});

  @override
  State<LandingWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder(
          stream: vendorsCollection
              .where('vendorID', isEqualTo: authID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return errorWidget(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingWidget();
            }
            if (snapshot.hasData) {
              final List<DocumentSnapshot> vendor = snapshot.data!.docs;
              return Center(
                  child: SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vendor.length,
                          itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(children: [
                                SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                            imageUrl: vendor[index]['logo'],
                                            placeholder: (context, url) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors
                                                        .grey.shade300)))),
                                const SizedBox(height: 10),
                                Text(vendor[index]['businessName'],
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                const Text(
                                    'Your application sent to Marketdo App Admin\nAdmin will contact you soon',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey)),
                                OutlinedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)))),
                                    onPressed: () => FirebaseAuth.instance
                                        .signOut()
                                        .then((value) => Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const LoginScreen()))),
                                    child: const Text('Sign out'))
                              ])))));
            }
            return emptyWidget('VENDOR NOT FOUND');
          }));
}
