import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget confirmDialog(
        context, String title, String message, void Function() onPressed) =>
    AlertDialog(title: Text(title), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('NO', style: TextStyle(color: Colors.red))),
      TextButton(
          onPressed: onPressed,
          child: Text('YES', style: TextStyle(color: Colors.green.shade900)))
    ]);

Widget errorDialog(BuildContext context, String message) =>
    AlertDialog(title: const Text('ERROR'), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text('OK'))
    ]);

Widget successDialog(BuildContext context, String message) =>
    AlertDialog(title: const Text('SUCCESS'), content: Text(message), actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text('OK'))
    ]);

String dateTimeToString(Timestamp timestamp) =>
    DateFormat('MMM dd, yyyy').format(timestamp.toDate()).toString();

String numberToString(double number) => NumberFormat('#,###.00').format(number);

String unitAbbreviation(String? selectedValue) {
  RegExp regex = RegExp(r'\((.*?)\)');
  Match? match = regex.firstMatch(selectedValue!);
  String abbreviation = match?.group(1) ?? '';
  return abbreviation;
}

String extractUnitText(String? selectedUnit) {
  if (selectedUnit != null) {
    int startIndex = selectedUnit.indexOf('(');
    int endIndex = selectedUnit.indexOf(')');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return selectedUnit.substring(startIndex + 1, endIndex);
    }
  }
  return '';
}

Future<void> openURL(context, String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    showDialog(
        context: context,
        builder: (_) => errorDialog(context, 'Cannot open "$url"'));
  }
}
