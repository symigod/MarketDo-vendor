import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive=> true;

  final FirebaseServices _services = FirebaseServices();
  bool? _manageInventory = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Manage Inventory? ', style: TextStyle(color: Colors.grey),),
            value: _manageInventory, 
            onChanged: (value){
              setState(() {
                _manageInventory = value;
                provider.getFormData(
                  manageInventory: value
                );
              });
            }),
            if(_manageInventory ==true)
            Column(
              children: [
                _services.formField(
              label: 'Stock on hand',
              inputType: TextInputType.number,
              onChanged: (value){
                provider.getFormData(
                  soh: int.parse(value),
                );

              }
            ),
            
              ],
            )
      
        ],
          ),
      );
    });
  }
}