import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:marketdo_app_vendor/provider/vendor_provider.dart';
import 'package:marketdo_app_vendor/widget/add_product/attributes_tab.dart';
import 'package:marketdo_app_vendor/widget/add_product/images_tab.dart';
import 'package:marketdo_app_vendor/widget/add_product/inventory_tab.dart';
import 'package:marketdo_app_vendor/widget/add_product/shipping_tab.dart';
import 'package:marketdo_app_vendor/widget/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../widget/add_product/general_tab.dart';


class AddProductScreen extends StatelessWidget {
  static const String id = 'add-product-screen';
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProductProvider>(context);
    final vendor = Provider.of<VendorProvider>(context);
    final formKey = GlobalKey<FormState>();
    FirebaseServices services = FirebaseServices();
    
    return Form(
      key: formKey,
      child: DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add new products'),
            elevation: 0,
            bottom: const TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: Colors.purpleAccent
                )
              ),
              tabs: [
                Tab(
                  child: Text('General'),
                ),
                 Tab(
                  child: Text('Inventory'),
                ),
                 Tab(
                  child: Text('Shipping'),
                ),
                Tab(
                  child: Text('Attributes'),
                ),
                 
                 Tab(
                  child: Text('Images'),
                ),
              ],
            ),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              GeneralTab(),
              InventoryTab(),
              ShippingTab(),
              AttributeTab(),
              ImagesTab()
                
            ],
          ),
    
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){
                  if(provider.imageFiles!.isEmpty){
                    services.scaffold(context, 'Image not selected');
                    return;

                  }
                  if (formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Please wait..');

                    provider.getFormData(
                      seller: {
                        'name': vendor.vendor!.businessName,
                        'uid': services.user!.uid,
                        'logo' : vendor.vendor!.logo
                      }
                    );
                    services.uploadFiles(
                      images: provider.imageFiles, 
                      ref: 'products/${vendor.vendor!.businessName}/${provider.productData!['productName']}',
                      provider: provider
                      ).then((value) {
                        if(value.isNotEmpty){

                          services.saveToDb(
                            data: provider.productData,
                            context: context
                          ).then((value) {
                            EasyLoading.dismiss();
                            setState(){
                              provider.clearProductData();
                            }
                            
                          });

                        }
                      });

                  }
                
                }, 
                child: const Text('Save Product'),
                
                ),
            )
          ],
        ),
      ),
    );
  }
}