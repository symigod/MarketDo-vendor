import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

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
  final List<String> _categories = [];
  String? selectedCategory;
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
  final List<String> _units = [];
  bool? _manageInventory = false;
  bool? _chargeShipping = false;
  final ImagePicker _picker = ImagePicker();
  Future<List<XFile>?> _pickImage() async => await _picker.pickMultiImage();

  @override
  void initState() {
    getCategories();
    _units.addAll(_length);
    _units.addAll(_weight);
    _units.addAll(_volume);
    _units.addAll(_box);
    _units.addAll(_bundles);
    _units.addAll(_container);
    _units.sort();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      for (var element in value.docs) {
        setState(() => _categories.add(element['catName']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<ProductProvider>(context);
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
                  toolbarHeight: 0,
                  // bottom: const TabBar(
                  //     isScrollable: true,
                  //     indicator: UnderlineTabIndicator(
                  //         borderSide:
                  //             BorderSide(width: 4, color: Colors.yellow)),
                  //     tabs: [
                  //       Tab(child: Text('General')),
                  //       Tab(child: Text('Inventory')),
                  //       Tab(child: Text('Shipping')),
                  //       Tab(child: Text('Attributes')),
                  //       Tab(child: Text('Images'))
                  //     ])
                ),
                body: ListView(padding: const EdgeInsets.all(10), children: [
                  cardWidget(context, 'GENERAL', [
                    _services.formField(
                        label: 'Product Name',
                        inputType: TextInputType.name,
                        onChanged: (value) => provider.getFormData(
                            productName: value.toUpperCase())),
                    _services.formField(
                        label: 'Description',
                        inputType: TextInputType.multiline,
                        maxLine: null,
                        onChanged: (value) =>
                            provider.getFormData(description: value)),
                    // _formField(
                    //     label: 'Brand',
                    //     inputType: TextInputType.text,
                    //     onChanged: (value) => provider.getFormData(brand: value)),
                    _unitDropDown(provider),
                    _services.formField(
                        label: 'Regular price',
                        unit: selectedUnit,
                        inputType: TextInputType.number,
                        onChanged: (value) => provider.getFormData(
                            regularPrice: int.parse(value)))
                  ]),
                  // Row(children: [
                  //   Expanded(
                  //       child: TextFormField(
                  //           controller: _sizeText,
                  //           decoration: const InputDecoration(label: Text('Size')),
                  //           onChanged: (value) {
                  //             if (value.isNotEmpty) {
                  //               setState(() => _entered = true);
                  //             }
                  //           })),
                  //   if (_entered)
                  //     ElevatedButton(
                  //         onPressed: () => setState(() {
                  //               _sizeList.add(_sizeText.text);
                  //               _sizeText.clear();
                  //               _entered = false;
                  //               _saved = false;
                  //             }),
                  //         child: const Text('Add'))
                  // ]),
                  // if (_sizeList.isNotEmpty)
                  //   SizedBox(
                  //       height: 50,
                  //       child: ListView.builder(
                  //           shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: _sizeList.length,
                  //           itemBuilder: (context, index) {
                  //             return Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: InkWell(
                  //                     onLongPress: () => setState(() {
                  //                           _sizeList.removeAt(index);
                  //                           provider.getFormData(
                  //                               sizeList: _sizeList);
                  //                         }),
                  //                     child: Container(
                  //                         height: 50,
                  //                         width: 50,
                  //                         decoration: BoxDecoration(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(4),
                  //                             color: Colors.purpleAccent),
                  //                         child: Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: Center(
                  //                                 child: Text(_sizeList[index],
                  //                                     style: const TextStyle(
                  //                                         fontWeight: FontWeight
                  //                                             .bold)))))));
                  //           })),
                  // if (_sizeList.isNotEmpty)
                  //   Column(children: [
                  //     const Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text('* long press to delete',
                  //             style: TextStyle(color: Colors.grey, fontSize: 12))),
                  //     Row(children: [
                  //       Expanded(
                  //           child: ElevatedButton(
                  //               onPressed: () => setState(() {
                  //                     provider.getFormData(sizeList: _sizeList);
                  //                     _saved = true;
                  //                   }),
                  //               child: Text(
                  //                   _saved == true ? 'Saved' : 'Press to Save')))
                  //     ])
                  //   ]),
                  cardWidget(context, 'CATEGORY', [
                    _categoryDropDown(provider),
                    _mainCategoryDropDown(provider)
                    // Padding(
                    //     padding: const EdgeInsets.only(top: 20, bottom: 10),
                    //     child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //               provider.productData!['mainCategory'] ??
                    //                   'Select Main Category',
                    //               style: TextStyle(
                    //                   fontSize: 16, color: Colors.grey.shade700)),
                    //           if (selectedCategory != null)
                    //             InkWell(
                    //                 onTap: () => showDialog(
                    //                         context: context,
                    //                         builder: (_) => MainCategoryList(
                    //                             selectedCategory: selectedCategory,
                    //                             provider: provider))
                    //                     .whenComplete(() => setState(() {})),
                    //                 child: const Icon(Icons.arrow_drop_down))
                    //         ]))
                  ]),
                  // _formField(
                  //     label: 'Add other details',
                  //     maxLine: 2,
                  //     onChanged: (value) =>
                  //         provider.getFormData(otherDetails: value)),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 20, bottom: 10),
                  //     child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //               provider.productData!['mainCategory'] ??
                  //                   'Select Main Category',
                  //               style: TextStyle(
                  //                   fontSize: 16, color: Colors.grey.shade700)),
                  //           if (selectedCategory != null)
                  //             InkWell(
                  //                 onTap: () => showDialog(
                  //                         context: context,
                  //                         builder: (context) => MainCategoryList(
                  //                             selectedCategory: selectedCategory,
                  //                             provider: provider))
                  //                     .whenComplete(() => setState(() {})),
                  //                 child: const Icon(Icons.arrow_drop_down))
                  //         ])),
                  cardWidget(context, 'INVENTORY', [
                    CheckboxListTile(
                        title: const Text('Manage Inventory? '),
                        value: _manageInventory,
                        onChanged: (value) {
                          setState(() {
                            _manageInventory = value;
                            provider.getFormData(manageInventory: value);
                          });
                        }),
                    if (_manageInventory == true)
                      Column(children: [
                        _services.formField(
                            label: 'Stock on hand',
                            inputType: TextInputType.number,
                            onChanged: (value) =>
                                provider.getFormData(soh: int.parse(value)))
                      ])
                  ]),
                  cardWidget(context, 'SHIPPING', [
                    CheckboxListTile(
                        title: const Text('Charge Transport fee?'),
                        value: _chargeShipping,
                        onChanged: (value) => setState(() {
                              _chargeShipping = value;
                              provider.getFormData(chargeShipping: value);
                            })),
                    if (_chargeShipping == true)
                      _services.formField(
                          label: 'Transport Charge',
                          inputType: TextInputType.number,
                          onChanged: (value) {
                            provider.getFormData(
                                shippingCharge: int.parse(value));
                          })
                  ]),
                  cardWidget(context, 'PRODUCT IMAGE', [
                    ElevatedButton(
                        child: const Text('Add'),
                        onPressed: () => _pickImage().then((value) => value!
                            .forEach((image) =>
                                setState(() => provider.getImageFile(image))))),
                    Center(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: provider.imageFiles!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        provider.imageFiles!.length >= 4
                                            ? 4
                                            : provider.imageFiles!.isEmpty
                                                ? 1
                                                : provider.imageFiles!.length),
                            itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(children: [
                                  Image.file(
                                      File(provider.imageFiles![index].path),
                                      fit: BoxFit.cover),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                          onTap: () => setState(() => provider
                                              .imageFiles!
                                              .removeAt(index)),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              child: const Icon(Icons.close,
                                                  color: Colors.white))))
                                ]))))
                  ])
                ]),
                // body: const TabBarView(children: [
                //   GeneralTab(),
                //   InventoryTab(),
                //   ShippingTab(),
                //   AttributeTab(),
                //   ImagesTab()
                // ]),
                persistentFooterButtons: [
                  Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade900),
                          onPressed: () {
                            if (provider.imageFiles!.isEmpty) {
                              _services.scaffold(context, 'Image not selected');
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'Please wait..');

                              // provider.getFormData(seller: {
                              //   'name': vendor.vendor!.businessName,
                              //   'uid': services.user!.uid,
                              //   'logo': vendor.vendor!.logo
                              // });
                              // services
                              //     .uploadFiles(
                              //         images: provider.imageFiles,
                              //         ref:
                              //             'products/${vendor.vendor!.businessName}/${provider.productData!['productName']}',
                              //         provider: provider)
                              //     .then((value) {
                              //   if (value.isNotEmpty) {
                              //     services
                              //         .saveToDb(
                              //             data: provider.productData, context: context)
                              //         .then((value) {
                              //       EasyLoading.dismiss();
                              //       setState() {
                              //         provider.clearProductData();
                              //       }
                              //     });
                              //   }
                              // });
                            }
                          },
                          child: const Text('Save Product')))
                ])));
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

  Widget _unitDropDown(ProductProvider provider) => Padding(
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
            // setState(() {
            selectedUnit = newValue!;
            provider.getFormData(unit: newValue);
            // });
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

  Widget _categoryDropDown(ProductProvider provider) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: selectedCategory,
          hint: const Text('Category'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? newValue) => setState(() {
                selectedCategory = newValue!;
                provider.getFormData(category: newValue);
              }),
          items: _categories
              .map<DropdownMenuItem<String>>((String value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          validator: (value) => value!.isEmpty ? 'Select Category' : null));

  Widget _mainCategoryDropDown(ProductProvider provider) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: selectedCategory,
          hint: const Text('Main Category'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? newValue) => setState(() {
                selectedCategory = newValue!;
                provider.getFormData(category: newValue);
              }),
          items: _categories
              .map<DropdownMenuItem<String>>((String value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          validator: (value) => value!.isEmpty ? 'Select Category' : null));

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
