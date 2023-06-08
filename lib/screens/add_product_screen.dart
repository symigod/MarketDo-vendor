import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:marketdo_app_vendor/widget/api_widgets.dart';
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
  // final List<String> _sizeList = [];
  // bool? _saved = false;

  // final _sizeText = TextEditingController();
  // bool _entered = false;

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
    'Cup (c)' 'Pint (pt)',
    'Quart (qt)',
    'Gallon (gal)',
    'Milliliter (ml)',
    'Liter (L)'
  ];
  final List<String> _box = [
    'Unit (u)',
    'Piece (pc)',
    'Box (box)',
    'Carton (ctn)'
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
  bool? _manageInventory = false;
  bool? _chargeShipping = false;

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
          .child('category_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

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
  List<String> categories = [];

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('category')
          .get();
      List<String> fetchedCategories = [];
      snapshot.docs.forEach((doc) {
        fetchedCategories.add(doc['category']);
      });

      setState(() {
        categories = fetchedCategories;
        selectedCategory = (categories.isNotEmpty ? categories[0] : null)!;
      });
    } catch (error) {
      print('Error fetching categories: $error');
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
    Widget buildCategoryDropdown() {
      if (categories.isEmpty) {
        return loadingWidget();
      } else {
        return Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField<String>(
                dropdownColor: Colors.yellow,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: selectedCategory,
                hint: const Text('Select category'),
                onChanged: (newValue) =>
                    setState(() => selectedCategory = newValue!),
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                validator: (value) =>
                    value!.isEmpty ? 'Select category' : null));
      }
    }

    super.build(context);
    final formKey = GlobalKey<FormState>();
    return Form(
        key: formKey,
        child: DefaultTabController(
            length: 5,
            initialIndex: 0,
            child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.green.shade900,
                    elevation: 0,
                    toolbarHeight: 0),
                body: ListView(padding: const EdgeInsets.all(10), children: [
                  cardWidget(context, 'GENERAL', [
                    _services.formField(productName,
                        label: 'Product Name',
                        inputType: TextInputType.name,
                        onChanged: (value) => value = productName.text),
                    _services.formField(description,
                        label: 'Description',
                        inputType: TextInputType.multiline,
                        maxLine: null,
                        onChanged: (value) => value = description.text),
                    _unitDropDown(_units),
                    _services.formField(regularPrice,
                        label: 'Regular price',
                        unit: selectedUnit,
                        inputType: TextInputType.number,
                        onChanged: (value) => value = regularPrice.text)
                  ]),
                  cardWidget(context, 'CATEGORY', [buildCategoryDropdown()]),
                  cardWidget(context, 'INVENTORY', [
                    CheckboxListTile(
                        title: const Text('Manage Inventory? '),
                        value: _manageInventory,
                        onChanged: (value) {
                          setState(() => _manageInventory = value);
                        }),
                    if (_manageInventory == true)
                      Column(children: [
                        _services.formField(stockOnHand,
                            label: 'Stock on hand',
                            inputType: TextInputType.number,
                            onChanged: (value) => value = stockOnHand.text)
                      ])
                  ]),
                  cardWidget(context, 'SHIPPING', [
                    CheckboxListTile(
                        title: const Text('Charge Transport fee?'),
                        value: _chargeShipping,
                        onChanged: (value) =>
                            setState(() => _chargeShipping = value)),
                    if (_chargeShipping == true)
                      _services.formField(shippingCharge,
                          label: 'Transport Charge',
                          inputType: TextInputType.number,
                          onChanged: (value) => value = shippingCharge.text)
                  ]),
                  cardWidget(context, 'PRODUCT IMAGE', [
                    ElevatedButton(
                        child: const Text('Add image'),
                        onPressed: () => _pickAndUploadImage()),
                    const SizedBox(height: 10),
                    _downloadURL == null
                        ? Container()
                        : SizedBox(
                            height: 200,
                            width: 200,
                            child: Stack(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(File(_pickedImage!.path),
                                      fit: BoxFit.cover)),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                      onTap: _cancelImageSelection,
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 24)))
                            ]))
                  ])
                ]),
                persistentFooterButtons: [
                  Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade900),
                          onPressed: () {
                            if (_downloadURL == '') {
                              _services.scaffold(context, 'Image not selected');
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              final productsCollection = FirebaseFirestore
                                  .instance
                                  .collection('products');
                              final docID = productsCollection.doc().id;
                              productsCollection
                                  .doc(docID)
                                  .set({
                                    'category': selectedCategory,
                                    'description': description.text,
                                    'imageURL': _downloadURL,
                                    'isInventoryManaged': _manageInventory,
                                    'isShipCharged': _chargeShipping,
                                    'productID': docID,
                                    'productName': productName.text,
                                    'regularPrice':
                                        double.parse(regularPrice.text),
                                    'shippingCharge':
                                        double.parse(shippingCharge.text),
                                    'stockOnHand': int.parse(stockOnHand.text),
                                    'unit': extractUnitText(selectedUnit!),
                                    'vendorID':
                                        FirebaseAuth.instance.currentUser!.uid
                                  })
                                  .then((value) => showDialog(
                                      context: context,
                                      builder: (_) => successDialog(context,
                                          'Product successfully added!')))
                                  .then((value) => clearAll());
                            }
                          },
                          child: const Text('Save Product')))
                ])));
  }

  clearAll() {
    setState(() {
      selectedCategory = '';
      description.text = '';
      _downloadURL = null;
      _manageInventory = false;
      _chargeShipping = false;
      productName.text = '';
      regularPrice.text = '';
      shippingCharge.text = '';
      stockOnHand.text = '';
      selectedUnit = '';
    });
  }

  Widget _formField(
          {String? label,
          TextInputType? inputType,
          void Function(String)? onChanged,
          int? minLine}) =>
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
              keyboardType: inputType,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), label: Text(label!)),
              onChanged: onChanged,
              minLines: minLine,
              maxLines: null));

  Widget _unitDropDown(units) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          dropdownColor: Colors.yellow,
          menuMaxHeight: 300,
          value: selectedUnit,
          hint: const Text('Select Unit'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? newValue) {
            selectedUnit = newValue!;
          },
          items: _units
              .map<DropdownMenuItem<String>>((String value) =>
                  DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                              fontFamily: 'Lato', fontSize: 12))))
              .toList(),
          validator: (value) => value!.isEmpty ? 'Select unit' : null));

  Widget cardWidget(context, String title, List<Widget> contents) => Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(5)),
      child: Column(children: [
        Card(
            color: Colors.green,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)))),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: contents))
      ]));
}
