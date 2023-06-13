import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:marketdo_app_vendor/screens/authentication/landing.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

const List<String> list = <String>['Yes', 'No'];

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _address = TextEditingController();
  final _landMark = TextEditingController();
  XFile? _shopImage;
  String? _shopImageUrl;
  XFile? _logo;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? _logoUrl;

  final ImagePicker _picker = ImagePicker();

  Widget _formField(
          {TextEditingController? controller,
          String? label,
          TextInputType? type,
          String? Function(String?)? validator}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
              controller: controller,
              keyboardType: type,
              maxLength: controller == _contactNumber ? 10 : null,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: label,
                  prefixText: controller == _contactNumber ? '+63' : null),
              validator: validator));

  Future<XFile?> _pickImage() async =>
      await _picker.pickImage(source: ImageSource.gallery);

  _scaffold(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            })));
  }

  _saveToDB() {
    if (_shopImage == null) {
      _scaffold('Shop Image not selected');
      return;
    }
    if (_logo == null) {
      _scaffold('Logo not selected');
      return;
    }

    if (_formKey.currentState!.validate()) {
      {
        EasyLoading.show(status: 'Please wait...');
        _services.uploadImage(_shopImage, 'vendors/$authID/shopImage.jpg').then(
            (String? url) {
          if (url != null) {
            setState(() => _shopImageUrl = url);
          }
        }).then((value) => _services
                .uploadImage(_logo, 'vendors/$authID/logo.jpg')
                .then((url) => setState(() => _logoUrl = url))
                .then((value) {
              _services.addVendor(data: {
                'address': _address.text,
                'businessName': _businessName.text,
                'email': FirebaseAuth.instance.currentUser!.email,
                'isActive': true,
                'isApproved': false,
                'landMark': _landMark.text,
                'logo': _logoUrl,
                'mobile': '+63${_contactNumber.text}',
                'shopImage': _shopImageUrl,
                'registeredOn': DateTime.now(),
                'vendorID': authID,
              }).then((value) {
                EasyLoading.dismiss();
                return Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LandingScreen(),
                ));
              });
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Column(children: [
            SizedBox(
                height: 240,
                child: Stack(alignment: Alignment.center, children: [
                  _shopImage == null
                      ? Container(color: Colors.greenAccent, height: 240)
                      : InkWell(
                          onTap: () => _pickImage().then(
                              (value) => setState(() => _shopImage = value)),
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              height: 240,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(_shopImage!.path)),
                                      fit: BoxFit.cover)))),
                  Row(children: [
                    const SizedBox(width: 20),
                    Stack(children: [
                      _logo == null
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                  child: Text('YOUR PICTURE/BUSINESS LOGO',
                                      textAlign: TextAlign.center)))
                          : Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  image: DecorationImage(
                                      image: FileImage(File(_logo!.path)),
                                      fit: BoxFit.cover))),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                              onTap: () => _pickImage().then(
                                  (value) => setState(() => _logo = value)),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.white))))
                    ])
                  ]),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8)),
                          onPressed: () => _pickImage().then(
                              (value) => setState(() => _shopImage = value)),
                          child: const Text('Edit shop image',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold))))
                ])),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                child: Column(children: [
                  _formField(
                      controller: _businessName,
                      label: 'Business Name',
                      type: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Business Name' : null),
                  _formField(
                      controller: _contactNumber,
                      label: 'Contact Number',
                      type: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Contact Number' : null),
                  _formField(
                      controller: _address,
                      label: 'Address',
                      type: TextInputType.text,
                      validator: (value) => value!.isEmpty
                          ? 'Enter your complete address'
                          : null),
                  _formField(
                      controller: _landMark,
                      label: 'Landmark',
                      type: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a Landmark' : null),
                  // _formField(
                  //     controller: _pinCode,
                  //     label: 'PIN Code',
                  //     type: TextInputType.number,
                  //     validator: (value) =>
                  //         value!.isEmpty ? 'Enter PIN Code' : null),
                  const SizedBox(height: 10),
                ]))
          ])),
          persistentFooterButtons: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade900),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text('Cancel'))),
              Container(
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: _saveToDB, child: const Text('Register')))
            ])
          ]));
}
