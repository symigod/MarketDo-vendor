import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';

String? authID = FirebaseAuth.instance.currentUser!.uid;
final blocksCollection = FirebaseFirestore.instance.collection('blocks');
final cartsCollection = FirebaseFirestore.instance.collection('carts');
final categoriesCollection =
    FirebaseFirestore.instance.collection('categories');
final customersCollection = FirebaseFirestore.instance.collection('customers');
final favoritesCollection = FirebaseFirestore.instance.collection('favorites');
final homeBannerCollection =
    FirebaseFirestore.instance.collection('homeBanner');
final ordersCollection = FirebaseFirestore.instance.collection('orders');
final productsCollection = FirebaseFirestore.instance.collection('products');
final vendorsCollection = FirebaseFirestore.instance.collection('vendors');

class FirebaseServices {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File file0 = File(file!.path);

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);
    await ref.putFile(file0);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future uploadFile({
    File? image,
    String? reference,
  }) async {
    firebase_storage.Reference storageReference = storage
        .ref()
        .child('$reference/${DateTime.now().microsecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addVendor({Map<String, dynamic>? data}) => vendorsCollection
      .doc(authID)
      .set(data!)
      .then((value) => print("User Added"));

  Future<void> saveToDb(
          {Map<String, dynamic>? data, BuildContext? context}) async =>
      productsCollection
          .add(data!)
          .then((value) => scaffold(context, 'Product Saved'));

  String formattedDate(date) => DateFormat('dd/MM/yyyy hh:mm aa').format(date);

  String formattedNumber(number) => NumberFormat("#,##,###").format(number);

  Widget formField(TextEditingController controller,
          {String? label,
          TextInputType? inputType,
          void Function(String)? onChanged,
          int? minLine,
          int? maxLine,
          String? unit}) =>
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
              controller: controller,
              keyboardType: inputType,
              inputFormatters:
                  label == 'Product Name' ? [UpperCaseTextFormatter()] : null,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(label!),
                  prefixText:
                      label == 'Regular price' || label == 'Delivery Fee'
                          ? 'PHP '
                          : null,
                  suffixText: label == 'Regular price' && unit != null
                      ? ' per ${unitAbbreviation(unit)}'
                      : label == 'Stock on hand' && unit != null
                          ? ' $unit'
                          : null),
              validator: (value) =>
                  value == null ? 'This field is required' : null,
              onChanged: onChanged,
              minLines: minLine,
              maxLines: null));

  scaffold(context, message) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(fontFamily: 'Lato')),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () =>
                  ScaffoldMessenger.of(context).clearSnackBars())));
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
