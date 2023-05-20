import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';

class Product {
  Product(
    {this.productName,
    this.regularPrice,
    this.category,
    this.mainCategory,
    this.subCategory,
    this.description,
    this.manageInventory,
    this.soh,
    this.chargeShipping,
    this.shippingCharge,
    this.brand,
    this.size,
    this.otherDetails,
    this.unit,
    this.imageUrls,
    this.seller,
     this.approved}
  );

  Product.fromJson(Map<String, Object?> json)
    : this(
        productName: json['productName'] as String,
        regularPrice: json['regularPrice'] as double,
        category: json['category']! as String,
        mainCategory: json['mainCategory']==null ? null : json['mainCategory']! as String,
        subCategory: json['subCategory']== null ? null : json['subCategory']! as String,
        description: json['description']==null ? null : json['description']! as String,
        manageInventory: json['manageInventory']==null ? null : json['manageInventory']! as bool,
        soh: json['soh']==null ? null : json['soh']! as double,
        chargeShipping: json['chargeShipping']==null ? null : json['chargeShipping']! as bool,
        shippingCharge: json['shippingCharge']==null ? null : json['shippingCharge']! as double,
        brand: json['brand']==null ? null : json['brand']! as String,
        size: json['size']==null ? null : json['size']! as List,
        otherDetails: json['otherDetails']==null? null : json['otherDetails']! as String,
        unit: json['unit'] == null ? null : json['unit']! as String,
        imageUrls: json['imageUrls']! as List,
        seller: json['seller']! as Map,
        approved: json['approved']! as bool,

      );

    final String? productName; 
    final double? regularPrice; 
    final String? category;
    final String? mainCategory;
    final String? subCategory;
    final String? description;
    final bool? manageInventory;
    final double? soh;
    final bool? chargeShipping;
    final double? shippingCharge;
    final String? brand;
    final List? size;
    final String? otherDetails;
    final String? unit;
    final List? imageUrls;
    final Map? seller;
    final bool? approved;

  Map<String, Object?> toJson() {
    return {
    'productName': productName, 
     'regularPrice': regularPrice, 
     'category': category,
     'mainCategory': mainCategory,
     'subCategory': subCategory,
     'description': description,
     'manageInventory': manageInventory,
     'soh': soh,
     'chargeShipping': chargeShipping,
     'shippingCharge': shippingCharge,
     'brand': brand,
     'size': size,
     'otherDetails': otherDetails,
     'unit': unit,
     'imageUrls': imageUrls,
     'seller': seller,
     'approved': approved,
    };
  }
}
FirebaseServices _services = FirebaseServices();
productQuery (approved){
  return FirebaseFirestore.instance.collection('product').where('approved', isEqualTo: approved).where('seller.uid', isEqualTo:_services.user!.uid)
  .orderBy('productName')
  .withConverter<Product>(
     fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
     toFirestore: (product, _) => product.toJson(),
   );
}