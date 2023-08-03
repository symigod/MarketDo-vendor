import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/firebase.services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:marketdo_app_vendor/screens/main.screen.dart';
import 'package:marketdo_app_vendor/widget/snapshots.dart';
import 'package:marketdo_app_vendor/widget/dialogs.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = 'add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();

  String? selectedUnit;
  final List<String> _length = [
    'Inch (in)',
    'Feet (ft)',
    'Yard (yd)',
    'Mile (mi)',
    'Meter (m)',
    'Kilometer (km)'
  ];
  final List<String> _weight = [
    'Ounce (oz)',
    'Pound (lb)',
    'Gram (g)',
    'Kilogram (kg)',
    'Metric Ton (MT)',
    'Carat (ct)'
  ];
  final List<String> _volume = [
    'Fluid Ounce(fl oz)',
    'Cup (c)',
    'Pint (pt)',
    'Quart (qt)',
    'Gallon (gal)',
    'Milliliter (ml)',
    'Liter (L)'
  ];
  final List<String> _box = [
    'Unit (u)',
    'Piece (pc)',
    'Box (box)',
    'Carton (ctn)',
    'Pair (pr)'
  ];
  final List<String> _bundles = ['Bundle (bdl)', 'Pack (pk)', 'Batch (bch)'];
  final List<String> _container = [
    'Can (can)',
    'Bottle (btl)',
    'Case (case)',
    'Crate (crate)',
    'Bag (bag)',
    'Sack (sack)'
  ];

  // Future<List<XFile>?> _pickImage() async => await _picker.pickMultiImage();
  final List<String> _units = [];

  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController regularPrice = TextEditingController();
  TextEditingController stockOnHand = TextEditingController();
  TextEditingController shippingCharge = TextEditingController();
  XFile? _pickedImage;
  String? _downloadURL;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
        _isImageSelected = true;
      });

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('products')
          .child(_pickedImage!.name);

      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(_pickedImage!.path));

      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      setState(() async => _downloadURL = await snapshot.ref.getDownloadURL());
    }
  }

  bool _isImageSelected = false;

  void _cancelImageSelection() {
    setState(() {
      _pickedImage = null;
      _downloadURL = null;
      _isImageSelected = false;
    });
  }

  String? selectedCategory;
  String? selectedSubcategory;
  List<String> categories = [];
  List<String> subcategories = [];

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await categoriesCollection.orderBy('category').get();
      List<String> fetchedCategories = [];
      for (var doc in snapshot.docs) {
        fetchedCategories.add(doc['category']);
      }
      setState(() => categories.addAll(fetchedCategories));
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchSubcategories(String? category) async {
    selectedSubcategory = null;
    subcategories.clear();
    try {
      QuerySnapshot snapshot = await categoriesCollection
          .where('category', isEqualTo: category)
          .get();
      List<String> fetchedCategories = [];
      for (var doc in snapshot.docs) {
        List<String> subcategories = List<String>.from(doc['subcategories']);
        subcategories
            .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        fetchedCategories
            .addAll(subcategories.map((subcategory) => subcategory.toString()));
      }
      setState(() => subcategories.addAll(fetchedCategories));
    } catch (error) {
      print('Error fetching subcategories: $error');
    }
  }

  @override
  void initState() {
    _units.addAll(_length);
    _units.addAll(_weight);
    _units.addAll(_volume);
    _units.addAll(_box);
    _units.addAll(_bundles);
    _units.addAll(_container);
    _units.sort();
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final formKey = GlobalKey<FormState>();
    Widget categoryDropdown(List<String> categories) {
      if (categories.isEmpty) {
        return loadingWidget();
      } else {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: DropdownButtonFormField<String>(
                isDense: false,
                isExpanded: true,
                dropdownColor: Colors.yellow,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: selectedCategory,
                hint: const Text('Select category'),
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 10,
                onChanged: (String? newValue) async {
                  await fetchSubcategories(newValue);
                  selectedCategory = newValue!;
                  selectedSubcategory = null;
                },
                items: categories
                    .map<DropdownMenuItem<String>>((String value) =>
                        DropdownMenuItem<String>(
                            value: value,
                            child: ListTile(
                                leading: FutureBuilder(
                                    future: categoriesCollection
                                        .where('category', isEqualTo: value)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final categoryData =
                                            snapshot.data!.docs[0];
                                        final imageURL =
                                            categoryData['imageURL'];
                                        return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(imageURL,
                                                width: 45,
                                                height: 45,
                                                fit: BoxFit.cover));
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                                title: Text(value))))
                    .toList(),
                validator: (value) =>
                    value!.isEmpty ? 'Select category' : null));
      }
    }

    Widget subcategoriesDropdown(List<String> subcategories) =>
        selectedCategory == null
            ? const SizedBox.shrink()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.yellow,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    value: selectedSubcategory,
                    hint: const Text('Select subcategory'),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 10,
                    onChanged: (String? newValue) =>
                        selectedSubcategory = newValue!,
                    items: subcategories
                        .map<DropdownMenuItem<String>>((String value) =>
                            DropdownMenuItem<String>(
                                value: value, child: Text(value)))
                        .toList(),
                    validator: (value) =>
                        value!.isEmpty ? 'Select subcategory' : null));

    Widget unitDropDown(units) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonFormField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            dropdownColor: Colors.yellow,
            menuMaxHeight: 300,
            value: selectedUnit,
            hint: const Text('Select Unit'),
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            onChanged: (String? newValue) =>
                setState(() => selectedUnit = newValue),
            items: _units
                .map<DropdownMenuItem<String>>((String value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)))
                .toList(),
            validator: (value) => value!.isEmpty ? 'Select unit' : null));

    return Form(
        key: formKey,
        child: Scaffold(
            appBar: AppBar(title: const Text('Add new product')),
            body: ListView(padding: const EdgeInsets.all(10), children: [
              _downloadURL == null && _isImageSelected == false
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: Card(
                        child: Center(
                            child: ElevatedButton(
                                child: const Text('Add image'),
                                onPressed: () => _pickAndUploadImage())),
                      ))
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(alignment: Alignment.center, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(File(_pickedImage!.path),
                                fit: BoxFit.cover)),
                        Center(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.5),
                                ),
                                child: const Text('CHANGE'),
                                onPressed: () => _pickAndUploadImage()))
                      ])),
              const SizedBox(height: 20),
              _services.formField(productName,
                  label: 'Product Name',
                  inputType: TextInputType.name,
                  onChanged: (value) => value = productName.text),
              _services.formField(description,
                  label: 'Description',
                  inputType: TextInputType.multiline,
                  maxLine: null,
                  onChanged: (value) => value = description.text),
              categoryDropdown(categories),
              if (selectedCategory != null)
                subcategoriesDropdown(subcategories),
              unitDropDown(_units),
              _services.formField(regularPrice,
                  label: 'Regular price',
                  unit: selectedUnit,
                  inputType: TextInputType.number,
                  onChanged: (value) => value = regularPrice.text),
              // _services.formField(shippingCharge,
              //     label: 'Delivery Fee',
              //     inputType: TextInputType.number,
              //     onChanged: (value) => value = shippingCharge.text),
              // _services.formField(stockOnHand,
              //     label: 'Stock on hand',
              //     unit: selectedUnit,
              //     inputType: TextInputType.number,
              //     onChanged: (value) => value = stockOnHand.text)
            ]),
            persistentFooterButtons: [
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900),
                      onPressed: () {
                        if (_downloadURL == null || _pickedImage == null) {
                          _services.scaffold(context, 'Image not selected');
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          List<String> keywords = productName.text
                              .toUpperCase()
                              .split(RegExp(r'\W+'))
                              .toList();
                          final docID = productsCollection.doc().id;
                          productsCollection
                              .doc(docID)
                              .set({
                                'category': selectedCategory,
                                'description': description.text,
                                'imageURL': _downloadURL,
                                'productID': docID,
                                'productName': productName.text.toUpperCase(),
                                'regularPrice': double.parse(regularPrice.text),
                                'searchKeywords': keywords,
                                'subcategory': selectedSubcategory,
                                'unit': extractUnitText(selectedUnit!),
                                'vendorID': authID
                              })
                              .then((value) => showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => successDialog(context,
                                      'Product successfully added!')).then(
                                  (value) => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainScreen()))))
                              .then((value) => clearAll());
                        }
                      },
                      child: const Text('Save Product')))
            ]));
  }

  clearAll() {
    setState(() {
      selectedCategory = '';
      selectedSubcategory = '';
      description.text = '';
      _cancelImageSelection();
      productName.text = '';
      regularPrice.text = '';
      shippingCharge.text = '';
      stockOnHand.text = '';
      selectedUnit = '';
    });
  }
}
