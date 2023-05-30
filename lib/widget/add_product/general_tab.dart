import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../firebase_services.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseServices _services = FirebaseServices();
  final List<String> _categories = [];
  String? selectedCategory;

  // final bool _salesPrice = false;

  Widget _categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text(
        'Select Category',
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        // This is called when the user selects an item.
        setState(() {
          selectedCategory = newValue!;
          provider.getFormData(category: newValue);
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select Category';
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      for (var element in value.docs) {
        setState(() {
          _categories.add(element['catName']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            //Product Name

            _services.formField(
                label: 'Enter Product Name',
                inputType: TextInputType.name,
                onChanged: (value) {
                  // save in provider
                  provider.getFormData(
                    productName: value,
                  );
                }),

            _services.formField(
                label: 'Enter description',
                inputType: TextInputType.multiline,
                minLine: 2,
                maxLine: 10,
                onChanged: (value) {
                  provider.getFormData(description: value);
                }),

            const SizedBox(
              height: 30,
            ),

            //Main Category DropDown
            _categoryDropDown(provider),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.productData!['mainCategory'] ??
                        'Select Main Category',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  if (selectedCategory != null)
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MainCategoryList(
                                  selectedCategory: selectedCategory,
                                  provider: provider,
                                );
                              }).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: const Icon(Icons.arrow_drop_down))
                ],
              ),
            ),

            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 30,
            ),

            _services.formField(
                label: 'Regular Price (\$)',
                inputType: TextInputType.number,
                onChanged: (value) {
                  // save in provider
                  provider.getFormData(
                    regularPrice: int.parse(value),
                  );
                }),
          ],
        ),
      );
    });
  }
}

class MainCategoryList extends StatefulWidget {
  final String? selectedCategory;
  final ProductProvider? provider;

  const MainCategoryList({this.selectedCategory, this.provider, super.key});

  @override
  State<MainCategoryList> createState() => _MainCategoryListState();
}

class _MainCategoryListState extends State<MainCategoryList> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: service.mainCategories
            .where('category', isEqualTo: widget.selectedCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text('No Main Categories'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      widget.provider!.getFormData(
                          mainCategory: snapshot.data!.docs[index]
                              ['mainCategory']);
                      Navigator.pop(context);
                    },
                    title: Text(
                      snapshot.data!.docs[index]['mainCategory'],
                    ));
              });
        },
      ),
    );
  }
}
