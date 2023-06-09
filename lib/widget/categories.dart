import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesDropdown extends StatefulWidget {
  const CategoriesDropdown({super.key});

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
    for (var doc in snapshot.docs) {
      fetchedCategories.add(doc['category']);
    }
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
