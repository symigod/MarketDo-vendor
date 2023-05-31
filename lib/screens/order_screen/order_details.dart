import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Information'),
                  const Text('Miraluna Lariosa'),
                  const Text('09454336652'),
                  const Text('Apagan 1, Nasipit, Agusan del Norte'),
                   const Text('Near seawall, black gate'),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3, // Replace with the desired number of dummy items
                    itemBuilder: (context, index) {
                      // Dummy data
                      var productImage = 'https://dummyimage.com/200x200/000000/ffffff';
                      var productName = 'Dummy Product $index';
                      var regularPrice = '9.99';

                      return ListTile(
                        leading: Image.network(productImage),
                        title: Text('PRODUCT NAME: $productName'),
                        subtitle: Text('PRODUCT PRICE: $regularPrice'),
                      );
                    },
                  ),

                const Text('PAYMENT METHOD:'),
                const Text('SHIPPING METHOD: '),
                const Text('TOTAL PRICE: '),
                const Text('SHIPPING FEE:'),
                const Text('TOTAL AMOUNT:'),

                ],
              ),
            )
            ],
          ),
        ),
      )
      );
      
  }
}
      