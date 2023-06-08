import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesDropdown extends StatefulWidget {
  @override
  _CategoriesDropdownState createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  String selectedCategory = '';
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    List<String> fetchedCategories = [];
    snapshot.docs.forEach((doc) {
      fetchedCategories.add(doc['category']);
    });
    setState(() => categories = fetchedCategories);
  }

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
      value: selectedCategory,
      hint: const Text('Select category'),
      onChanged: (newValue) => setState(() => selectedCategory = newValue!),
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList());
}
