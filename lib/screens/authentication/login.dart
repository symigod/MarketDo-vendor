import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:marketdo_app_vendor/screens/authentication/landing.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) => Center(
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/images/marketdoLogo.png'))),
              subtitleBuilder: (context, action) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        action == AuthAction.signIn
                            ? 'Welcome Vendor!\nPlease sign in to continue.'
                            : 'Welcome Vendor!\nPlease create an account to continue',
                        style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold)));
              },
              footerBuilder: (context, _) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(children: [
                    const Text(
                        'By signing in, you agree to our terms and conditions.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text(
                        'If you have any problems signing in, reset the app in your settings (eg. Clear data, Clear cache).',
                        style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)
                  ])),
              providerConfigs: const [
                EmailProviderConfiguration(),
                // GoogleProviderConfiguration(
                //     clientId:
                //         '1:780102967000:android:af3d1b7fd390ef64e901ad'),
                // PhoneProviderConfiguration()
              ]);
        }
        return const LandingScreen();
      });
}
