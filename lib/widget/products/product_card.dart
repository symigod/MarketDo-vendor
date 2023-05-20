import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:marketdo_app_vendor/model/product_model.dart';
import 'package:marketdo_app_vendor/widget/products/product_details.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({super.key, this.snapshot});

  final FirestoreQueryBuilderSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          Product product = snapshot!.docs[index].data();
          String id = snapshot!.docs[index].id;
          return Slidable(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetailsScreen(
                      product: product,
                      productId: id,
                    ),
                  ),
                );
              },
              child: Card(
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls![0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.productName!),
                          Text(
                            services.formattedNumber(product.regularPrice),
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    services.product.doc(id).update({
                      'approved': product.approved == false ? true : false
                    });
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.approval,
                  label: product.approved == false ? 'Approve' : 'Inactive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class ProductCard extends StatelessWidget {
//   const ProductCard ({super.key, this.snapshot});

//   final FirestoreQueryBuilderSnapshot? snapshot;

//   @override
//   Widget build(BuildContext context) {
//     FirebaseServices services = FirebaseServices();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView.builder(
//         itemCount: snapshot!.docs.length,
//         itemBuilder: (context, index){
//         Product product = snapshot!.docs[index].data();
//         String id = snapshot!.docs[index].id;
//         var discount = (product.regularPrice!-product.salesPrice!)/
//             product.regularPrice! *
//             100;
//         return Slidable(
//           // ignore: sort_child_properties_last
//           child: InkWell(
//             onTap: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => ProductDetailsScreen(
//                     product: product,
//                     productId: id,
//                   ),
//                   ),
//               );
//             },
//             child: Card(
//             child: Row(
//               children: [
//                 SizedBox(
//                   height: 80,
//                   width: 80,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CachedNetworkImage(
//                       imageUrl: product.imageUrls![0]
//                       ),
//                   ),
//                 ),
                
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(product.productName!),
//                       Row(
//                         children: [
//                           if(product.salesPrice!=null)
//                           Text (services.formattedNumber(product.salesPrice)),
//                           const SizedBox(
//                             width: 10,
//                             ),
//                           Text(
//                             services.formattedNumber(product.regularPrice),
//                             style: TextStyle(
//                               decoration: product.salesPrice!=null 
//                               ?  TextDecoration.lineThrough
//                               : null,
//                               color: Colors.red
//                              ),
//                            ),
//                            const SizedBox(width: 10,),
//                            Text('${discount.toInt()}%', style: const TextStyle(color: Colors.red),),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//                   ),
//           ),
//           endActionPane: ActionPane(
//             motion: const ScrollMotion(),
//             children: [
//               SlidableAction(
//                 flex: 1,
//                 onPressed: (context){

//                 },
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 icon: Icons.delete,
//                 label: 'Delete',
//               ),
//               SlidableAction(
//                 flex: 1,
//                 onPressed: (context){
//                   services.product.doc(id).update({
//                     'approved': product.approved==false ? true : false
//                   });
//                 },
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 icon: Icons.approval,
//                 label: product.approved==false ? 'Approve' : 'Inactive',
//                 ),
//               ],
//             ),            
//          );
//         },
//       ),
//     );
//   }
// }






// class ProductCard extends StatelessWidget {
//   const ProductCard({Key? key, this.snapshot}) : super(key: key);

  
//   final FirestoreQueryBuilderSnapshot? snapshot;

//   @override
//   Widget build(BuildContext context) {
//     FirebaseServices services = FirebaseServices();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView.builder(
//         itemCount: snapshot!.docs.length,
//         itemBuilder: (context, index){
//         Product product = snapshot!.docs[index].data();
//       String id = snapshot!.docs[index].id;
//         var discount = (product.regularPrice!-product.salesPrice!)/
//         product.regularPrice!*100;
//         return Slidable(
//           child: InkWell(
//             onTap: (){
//               Navigator.push(
//                 context, 
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => ProductDetailsScreen(
//                     product: product,
//                     productId: id,
//                   ),
//                 ),
//                   );
          
//             },
//             child: Card(
//              child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 80,
//                   width: 80,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CachedNetworkImage(imageUrl: product.imageUrls![0]),
//                   ),
//                   ),
                
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(product.productName!),
                      
//                       Row(
//                         children: [
//                           if(product.salesPrice!=null)
//                           Text(services.formattedNumber(product.salesPrice)),
//                           SizedBox(
//                             width: 10,
//                             ),
//                           Text(
//                             services.formattedNumber(product.regularPrice), 
//                             style: TextStyle(decoration: product.salesPrice != null 
//                           ? TextDecoration.lineThrough
//                           : null,
//                           color: Colors.red
//                           ),
//                           ),
//                           SizedBox(width: 10,),
//                           Text('${discount.toInt()}%', style: TextStyle(color: Colors.red),),
//                         ],
//                       ),
                      
//                     ],
//                   ),
//                 ),
          
//               ],
//             ),
//                   ),
//           ),
//         endActionPane: ActionPane(
//           motion: ScrollMotion(),
//           children: [
//             SlidableAction(
//     flex: 1,
//     onPressed: (context){

//     },
//     backgroundColor: Color(0xFF7BC043),
//     foregroundColor: Colors.white,
//     icon: Icons.delete,
//     label: 'Delete',
//       ),
//       SlidableAction(
//     flex: 1,
//     onPressed: (context){
//       services.product.doc(id).update({
//         'approved': product.approved==false ? true : false
//       });
//     },
//     backgroundColor: Color.fromARGB(255, 202, 163, 233),
//     foregroundColor: Colors.white,
//     icon: Icons.approval,
//     label: product.approved==false ? 'Approved' : 'Inactive',
//       ),
//           ],
//         ),


//         );
//       }),
//     );
//   }
// }
