import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../firebase_services.dart';
import '../../model/product_model.dart';


class ProductDetailsScreen extends StatefulWidget {
  final Product? product ;
  final String? productId;
  const ProductDetailsScreen ({this.product, this.productId,super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool _editable = true;
  final _productName = TextEditingController();
  final _brand = TextEditingController();
  // final _salesPrice = TextEditingController();
  final _regularPrice = TextEditingController();
  final _description = TextEditingController();
  final _soh = TextEditingController();
  final _reorderLevel = TextEditingController();
  final _shippingCharge = TextEditingController();
  final _otherDetails = TextEditingController();
  final _sizeText = TextEditingController();

  DateTime? scheduleDate;
  bool? manageInventory;
  bool? chargeShipping;
  List _sizeList = [];
  bool _addList = false;
  

  // //TAX STATUS DROPDOWN
  // Widget _taxStatusDropDown(){
  //   return DropdownButtonFormField<String>(
  //             value: taxStatus,
  //             hint: const Text('Tax status', style: TextStyle(fontSize: 16),),
  //             icon: const Icon(Icons.arrow_drop_down),
  //             elevation: 16,
  //             onChanged: (String? newValue) {
  //               // This is called when the user selects an item.
  //               setState(() {
  //                 taxStatus = newValue!;
                  
  //               });
  //             },
  //             items: ['Taxable', 'Non Taxable']
  //             .map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //             validator: (value){
  //               if(value!.isEmpty){
  //                 return 'Select Tax Status';
  //               }
  //             }
  //   );
  // }
  // //TAX AMOUNT DROPDOWN
  // Widget _taxAmount(){
  //   return DropdownButtonFormField<String>(
  //             value: taxAmount,
  //             hint: const Text('Tax Amount', style: TextStyle(fontSize: 16),),
  //             icon: const Icon(Icons.arrow_drop_down),
  //             elevation: 16,
  //             onChanged: (String? newValue) {
  //               // This is called when the user selects an item.
  //               setState(() {
  //                 taxAmount = newValue!;
  //               });
  //             },
  //             items: ['GST -10%', 'GST -12%']
  //             .map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //             validator: (value){
  //               if(value!.isEmpty){
  //                 return 'Select Tax Amount';
  //               }
  //               return null;
  //             },
  //   );
  // }

  
  Widget _textFormField({
    TextEditingController? controller, 
    String? label, 
    TextInputType? inputType }){
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value){
        if(value!.isEmpty){
          return 'enter $label';
        }
        return null;
      },
    );
  }


  @override
  void initState() {
    setState(() {
      _productName.text = widget.product!.productName!;
      _brand.text = widget.product!.brand!;
      _regularPrice.text = widget.product!.regularPrice!.toString();
      _description.text = widget.product!.description!;
      _soh.text = widget.product!.soh!.toString();
      _shippingCharge.text = widget.product!.shippingCharge!.toString();
      _otherDetails.text = widget.product!.otherDetails!;
      manageInventory = widget.product!.manageInventory;
      chargeShipping = widget.product!.chargeShipping;
      if(widget.product!.size!.isNotEmpty){
        _sizeList = widget.product!.size!;
      }
      
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.product!.productName!),
          actions: [
            _editable ? 
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: (){
                setState(() {
                  _editable = false;
                });
              },
              ) : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 216, 120, 233)),
                  ),
                      child: const Text('Save', style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          setState(() {
                            _editable = true;
                            _addList = false;
                          },
                          );
                        },
                ),
              )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editable,
                child: Column(
                  children: [
                    SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.product!.imageUrls!.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CachedNetworkImage(imageUrl: e),
                    );
                  }).toList(),
                ),
                ),
                const SizedBox(height: 10,),
                Row(
                children: [
                  const Text('Brand: ', style: TextStyle(color: Colors.grey),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: _textFormField(
                      label: 'Brand',
                      inputType: TextInputType.text,
                      controller: _brand
                    )
                  ),
                ],
                ),
                _textFormField(
                      label: 'Product Name',
                      inputType: TextInputType.text,
                      controller: _productName
                    ),
                          
                _textFormField(
                      label: 'Description',
                      inputType: TextInputType.text,
                      controller: _description
                    ),
                _textFormField(
                      label: 'Other Details',
                      inputType: TextInputType.text,
                      controller: _otherDetails
                    ),
                        
                Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: [
                    const Text('Unit: '),
                    Text(widget.product!.unit!),
                  ],
                ),
                ),
                        
                Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                        children: [
                          
                          //REGULAR PRICE INFO
                          Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Regular Price: ', 
                                  style: TextStyle(color: Colors.grey),
                                  ),
                                const SizedBox(width: 8,),
                                Expanded(
                                  child: _textFormField(
                                    label: 'Regular Price',
                                    inputType: TextInputType.number,
                                    controller: _regularPrice
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                        ),
                        const SizedBox(height: 10,),
                        if(scheduleDate!=null)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sales price until: '),
                                Text(_services.formattedDate(scheduleDate))
                              ],
                            ),
                            const SizedBox(height: 10,),
                            if(_editable==false)
                            ElevatedButton(
                                  child: const Text('Change date'),
                                  onPressed: (){
                                    showDatePicker(
                                      context: context, 
                                      initialDate: scheduleDate!, 
                                      firstDate: DateTime.now(), 
                                      lastDate: DateTime(5000)).then((value) {
                                        setState(() {
                                          scheduleDate = value;
                                        });
                                      });
                                  },)
                              ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  color: Colors.grey.shade300,
                 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Size List', style: TextStyle(fontWeight: FontWeight.bold),),
                            if(_editable == false)
                            TextButton(
                              child: const Text('Add List'),
                              onPressed: (){
                                setState(() {
                                  _addList = true;
                                });
                              }, )
                          ],
                        ),
                      if(_addList)
                        Form(
                          key: _formKey1,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter a value';
                                    }
                                    return null;
                                  },
                                controller: _sizeText,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white
                                ),
                              ),),
                              const SizedBox(width: 10,),
                              ElevatedButton(
                                child: const Text('Add'),
                                onPressed: (){
                                  if(_formKey1.currentState!.validate()){
                                    _sizeList.add(_sizeText.text);
                                    setState(() {
                                    _sizeText.clear();
                                  });
                                  }
                                  
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        if(_sizeList.isNotEmpty)
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              itemCount: _sizeList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color.fromARGB(255, 219, 130, 235),
                                    ),
                                    
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(_sizeList[index]),
                                    ),
                                  ),),
                                );
                              },),
                          ),
                      ],
                    ),
                  ),
                ),        
                //CATEGORIES
                 Padding(
                 padding: const EdgeInsets.only(top: 20, bottom: 10),
                 child: Row(
                   children: [
                    const Text(
                      'Category: ', 
                        style: TextStyle(color: Colors.grey),
                           ),
                           const SizedBox(width: 10,),
                     Text(widget.product!.category!),
                   ],
                 ),
                 ),
                 if(widget.product!.mainCategory!=null)
                 Padding(
                 padding: const EdgeInsets.only(top: 10, bottom: 10),
                 child: Row(
                   children: [
                    const Text(
                      'Main Category: ', 
                        style: TextStyle(color: Colors.grey),
                           ),
                           const SizedBox(width: 10,),
                     Text(widget.product!.mainCategory!),
                   ],
                 ),
                 ),
                 if(widget.product!.subCategory!=null)
                 Padding(
                 padding: const EdgeInsets.only(top: 10, bottom: 10),
                 child: Row(
                   children: [
                    const Text(
                      'Sub Category: ', 
                        style: TextStyle(color: Colors.grey),
                           ),
                           const SizedBox(width: 10,),
                     Text(widget.product!.subCategory!),
                   ],
                 ),
                 ),
                 
                 const SizedBox(width: 10,),
                Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Manage Inventory? '),
                          value: manageInventory, 
                          onChanged: (value){
                          setState(() {
                            manageInventory = value;
                            if(value==false){
                              _soh.clear();
                              _reorderLevel.clear();
                            }
                          });
                        }),
                        if(manageInventory ==true)
                        Row(
                        children: [
                          //SOH INFO
                          Expanded(
                            child: Row(
                              children: [
                                const Text('SOH: ', 
                                style: TextStyle(color: Colors.grey),),
                                const SizedBox(
                                  width: 8,
                                  ),
                                  Expanded(
                                    child: _textFormField(
                                      label: 'SOH',
                                      inputType: TextInputType.number,
                                      controller: _soh
                                    )
                                  ),
                              ],
                            ),
                          ),
                         
                        ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Charge Shipping: '),
                          value: chargeShipping, onChanged: (value){
                          setState(() {
                            chargeShipping = value;
                            if(value==false){
                              _shippingCharge.clear();
                            }
                          });
                        }),
                       if(chargeShipping == true)
                        Row(
                        children: [
                          const Text('Shipping Charge: '),
                          Expanded(
                            child: _textFormField(
                              label: 'Shipping Charge',
                              inputType: TextInputType.number,
                              controller: _shippingCharge
                            ),
                          )
                        ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}






//ORIGINAL CODES



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:marketdo_app_vendor/provider/product_provider.dart';
// import '../../firebase_services.dart';
// import '../../model/product_model.dart';


// class ProductDetailsScreen extends StatefulWidget {
//   final Product? product ;
//   final String? productId;
//   const ProductDetailsScreen ({this.product, this.productId,super.key});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//     FirebaseServices _services = FirebaseServices();
//   final _formKey = GlobalKey<FormState>();
//   bool _editable = true;
//   final _productName = TextEditingController();
//   final _brand = TextEditingController();
//   final _salesPrice = TextEditingController();
//   final _regularPrice = TextEditingController();
//   final _description = TextEditingController();
//   final _soh = TextEditingController();
//   final _reorderLevel = TextEditingController();
//   final _shippingCharge = TextEditingController();

//   String? taxStatus;
//   DateTime? scheduleDate;
//   bool? manageInventory;
//   bool? chargeShipping;
//   String? taxAmount;


//   Widget _taxStatusDropDown(){
//     return DropdownButtonFormField<String>(
//               value: taxStatus,
//               hint: const Text('Tax status', style: TextStyle(fontSize: 16),),
//               icon: const Icon(Icons.arrow_drop_down),
//               elevation: 16,
//               onChanged: (String? newValue) {
//                 // This is called when the user selects an item.
//                 setState(() {
//                   taxStatus = newValue!;
                  
//                 });
//               },
//               items: ['Taxable', 'Non Taxable']
//               .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               validator: (value){
//                 if(value!.isEmpty){
//                   return 'Select Tax Status';
//                 }
//               }
//     );
//   }

//   Widget _taxAmount(){
//     return DropdownButtonFormField<String>(
//               value: taxAmount,
//               hint: const Text('Tax Amount', style: TextStyle(fontSize: 16),),
//               icon: const Icon(Icons.arrow_drop_down),
//               elevation: 16,
//               onChanged: (String? newValue) {
//                 // This is called when the user selects an item.
//                 setState(() {
//                   taxAmount = newValue!;
                  
//                 });
//               },
//               items: ['GST -10%', 'GST -12%']
//               .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               validator: (value){
//                 if(value!.isEmpty){
//                   return 'Select Tax Status';
//                 }
//               }
//     );
//   }



  // Widget _textFormField({TextEditingController? controller, String? label, TextInputType? inputType}){
  //   return TextFormField(
  //     controller: controller,
  //     keyboardType: inputType,
  //     validator: (value){
  //       if(value!.isEmpty){
  //         return 'enter $label';
  //       }
  //     },
  //   );
  // }

//   @override
//   void initState() {
//     setState(() {
//       _productName.text = widget.product!.productName!;
//       _brand.text = widget.product!.brand!;
//       _salesPrice.text = widget.product!.salesPrice!.toString();
//       _regularPrice.text = widget.product!.regularPrice!.toString();
//       taxStatus = widget.product!.taxStatus;
//       taxAmount = widget.product!.taxValue==10 ? ' GST-10%': 'GST-12%';
//       _description.text = widget.product!.description!;
//       _soh.text = widget.product!.soh!.toString();
//       _reorderLevel.text = widget.product!.reOrderLevel!.toString();
//       _shippingCharge.text = widget.product!.shippingCharge!.toString();
//       if(widget.product!.scheduleDate!=null){
//         scheduleDate = DateTime.fromMicrosecondsSinceEpoch(widget.product!.scheduleDate!.microsecondsSinceEpoch);
//       manageInventory = widget.product!.manageInventory;
//       chargeShipping = widget.product!.chargeShipping;
//       }
//     });
//     super.initState();
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(widget.product!.productName!),
//           actions: [
//             _editable ?
//             IconButton( 
//               icon: Icon(Icons.edit_outlined),
//               onPressed: (){
//                 setState(() {
//                   _editable:false;
//                 });

//               },
//               ) : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
//                   ),
//                   child: Text('Save'),
//                   onPressed: (){
//                     setState(() {
//                       _editable = true;
//                     });
//                   },
//                 ),
//               )
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: ListView(
//             children: [
//              AbsorbPointer(
//               absorbing: _editable,
//                child: Column(
//                  children: [
//                     SizedBox(
//                  height: 200,
//                  child: ListView(
//                    scrollDirection: Axis.horizontal,
//                    children: widget.product!.imageUrls!.map((e) {
//                      return Padding(
//                        padding: const EdgeInsets.all(4.0),
//                        child: CachedNetworkImage(imageUrl: e),
//                      );
//                    }).toList(),
//                  ),
//                ),
//                const SizedBox(height: 10,),
//                Row(
//                  children: [
//                    const Text(
//                      'Brand: ', 
//                    style: TextStyle(color: Colors.grey),),
//                    const SizedBox(width: 10,),
//                    Expanded(
//                      child: _textFormField(
//                        label: 'Brand',
//                        inputType: TextInputType.text,
//                        controller: _brand
//                      ),
//                    ),
//                  ],
//                ),
//                _textFormField(
//                        label: 'Product Name',
//                        inputType: TextInputType.text,
//                        controller: _productName
//                      ),
               
//                _textFormField(
//                        label: 'Description',
//                        inputType: TextInputType.text,
//                        controller: _description
//                      ),
                       
//                    Padding(
//                      padding: const EdgeInsets.only(top: 20, bottom: 10),
//                      child: Row(
//                        children: [
//                          const Text('Unit: '),
//                          Text(widget.product!.unit!),
//                        ],
//                      ),
//                    ),
               
                       
//                Container(
//                 color: Colors.grey.shade300,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      children: [
//                        Row(
//                          children: [
//                            if(widget.product!.salesPrice!=null)
//                            Expanded(
//                              child: Row(
//                                children: [
//                                  const Text('Sales price: ', style: TextStyle(color: Colors.grey),),
//                                  const SizedBox(width: 8,),
//                                  Expanded(
//                                    child: _textFormField(
//                                label: '  Sales price',
//                                inputType: TextInputType.number,
//                                controller: _salesPrice
//                              ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            Expanded(
//                              child: Row(
//                                children: [
//                                  const Text('Regular price: ', style: TextStyle(color: Colors.grey),),
//                                  const SizedBox(width: 8,),
//                                  Expanded(
//                                    child: _textFormField(
//                                label: 'regular price',
//                                inputType: TextInputType.number,
//                                controller: _regularPrice
//                              ),
//                                  ),
//                                ],
//                              ),
//                            ),           
//                          ],
//                        ),
//                      SizedBox(height: 10,),
//                      if(scheduleDate!=null)
//                       Column(
//                         children: [
//                           Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Sales price until: '),
//                           Text(_services.formattedDate(scheduleDate))
                          
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       if(_editable==false)
//                     ElevatedButton(
//                             child: Text('Change Date'),
//                             onPressed: (){
//                               showDatePicker(
//                                 context: context, 
//                                 initialDate: scheduleDate!, 
//                                 firstDate: DateTime.now(), 
//                                 lastDate: DateTime(5000)) . then((value) {
//                                   setState(() {
//                                     scheduleDate = value;
//                                   });
//                                 });
//                             }, )
//                         ],
//                       )
//                      ],
//                    ),
//                  ),
//                ),
//                Row(
//                  children: [
//                     Expanded(child: _taxStatusDropDown(),
//                ),
//                    const SizedBox(width: 10,),
//                   if(taxStatus ==  'Taxable')
//                   Expanded(child: _taxAmount(),
//                ),
//                  ],
//                ),
//                //CATEGORY
//                Padding(
//                  padding: const EdgeInsets.only(top: 20, bottom: 10),
//                  child: Row(
//                    children: [
//                      const Text(
//                        'Category: ',
//                        style: TextStyle(color: Colors.grey),
//                        ),
//                        const SizedBox(width: 10,),
//                        Text(widget.product!.category!),
//                    ],
//                  ),
//                ),
//                //MAIN CATEGORY
//                if(widget.product!.mainCategory!=null)
//                Padding(
//                  padding: const EdgeInsets.only(top: 10, bottom: 10),
//                  child: Row(
//                    children: [
//                      const Text(
//                        'Main Category: ',
//                        style: TextStyle(color: Colors.grey),
//                        ),
//                        const SizedBox(width: 10,),
//                        Text(widget.product!.mainCategory!),
//                    ],
//                  ),
//                ),
//                //SUB CATEGORY
//                if(widget.product!.subCategory!=null)
//                Padding(
//                  padding: const EdgeInsets.only(top: 10, bottom: 10),
//                  child: Row(
//                    children: [
//                      const Text(
//                        'Sub Category: ',
//                        style: TextStyle(color: Colors.grey),
//                        ),
//                        const SizedBox(width: 10,),
//                        Text(widget.product!.subCategory!),
//                    ],
//                  ),
//                ),
                       
//                const SizedBox(width: 10,),
               
//                  Container(
//                   color: Colors.grey.shade300,
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Column(
//                        children: [
//                         CheckboxListTile(
//                           contentPadding: EdgeInsets.zero,
//                           title: Text('Manage inventory? '),
//                           value: manageInventory, 
//                           onChanged: (value){
//                           setState(() {
//                             manageInventory = value;
//                             if(value==false){
//                               _soh.clear();
//                               _reorderLevel.clear();
//                             }
//                           });

//                         }),
//                         if(manageInventory==true)
//                          Row(
//                          children: [
//                            Expanded(
//                              child: Row(
//                                children: [
//                                  const Text(
//                                    'SOH', 
//                                    style: TextStyle(color: Colors.grey),),
//                                  const SizedBox(
//                                    width: 8,
//                                    ),
//                                  Expanded(
//                                    child: _textFormField(
//                                label: 'SOH',
//                                inputType: TextInputType.number,
//                                controller: _soh
//                              ),
//                                  ),
//                                ],
//                              ),
                             
//                            ),
//                            Expanded(
//                              child: Row(
//                                children: [
//                                  const Text('Reorder Level ', style: TextStyle(color: Colors.grey),),
//                                  const SizedBox(width: 8,),
//                                  Expanded(
//                                    child: _textFormField(
//                                label: 'Reorder Level',
//                                inputType: TextInputType.number,
//                                controller: _reorderLevel
//                              ),
//                                  ),
//                                ],
//                              ),
//                            ), 
//                          ],
//                                       ),
//                        ],
//                      ),
//                    ),
//                  ),
//                 const SizedBox(height: 10,),
               
//                Container(
//                 color: Colors.grey.shade300,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      children: [
//                       CheckboxListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: const Text('Charge Shipping? '),
//                         value: chargeShipping, onChanged: (value){
//                         setState(() {
//                           chargeShipping = value;
//                         });
//                       }),
//                       if(chargeShipping == true)
//                        Row(
//                          children: [
//                            const Text('Shipping Charge: '),
//                            Expanded(
//                              child: _textFormField(
//                                label: 'Shipping Charge',
//                                inputType: TextInputType.number,
//                                controller: _shippingCharge
//                              ),
//                            )
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(top: 10, bottom: 10),
//                  child: Row(
//                children: [
//                  Text('SKU: ',style: TextStyle(color: Colors.grey),),
//                  Text(widget.product!.sku!),
//                ],
//                  ),
//                ),
//                  ],
                 
//                ),
//              )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }