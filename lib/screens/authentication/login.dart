import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:marketdo_app_vendor/screens/authentication/landing.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) => const Padding(
                  padding: EdgeInsets.all(20),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                          child: Column(children: [
                        Text('Marketdo App',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        Text('Vendor', style: TextStyle(fontSize: 20))
                      ])))),
              subtitleBuilder: (context, action) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(action == AuthAction.signIn
                        ? 'Welcome to Marketdo App - Vendor! Please sign in to continue.'
                        : 'Welcome to App-Vendor! Please create an account to continue'));
              },
              footerBuilder: (context, _) {
                return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        'By signing in, you agree to our terms and conditions.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center));
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId: '1:780102967000:android:66214768ee06f6a5e901ad'),
                PhoneProviderConfiguration()
              ]);
        }
        return const LandingScreen();
      });
}
