import 'package:api_practice/models/product.dart';
import 'package:api_practice/screens/widgets/feeds_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../services/business_logic.dart';
import '../services/fakeStoreAPI_handler.dart';

class CategoryProducts extends StatelessWidget {
  const CategoryProducts({super.key,});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final logicCtrl = Get.put(BusLogic());
    print('id:${arguments['id']}');
    print(arguments['category']);
    return Scaffold(
        appBar: AppBar(
          title: Text(arguments['category']),
          leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(IconlyLight.arrowLeft)),
        ),
        body: FutureBuilder(
          future: StoreAPI.getAllProducts(
               queryParameter: {'categoryId': ['${arguments['id']}']}),
          builder: (context, snapshot) {
            return logicCtrl.snapshotHandler(
              snapshot,
              () {
                final products = snapshot.data!.cast<ProductModel>();
                print(snapshot.data!.length);
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index],
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
