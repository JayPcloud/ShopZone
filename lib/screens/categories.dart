import 'package:api_practice/models/category.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/fakeStoreAPI_handler.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, this.isAuthenticated});

  final bool? isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final logicCtrl = Get.put(BusLogic());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Categories"),
          leading: isAuthenticated ?? false
              ? null
              : InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(IconlyLight.arrowLeft)),
        ),
        body: FutureBuilder<List<CategoryModel>>(
          future: StoreAPI.getAllCategories(),
          builder: (context, snapshot) {
            return logicCtrl.snapshotHandler(
              snapshot,
              () {
                final category = snapshot.data!.cast<CategoryModel>();
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: 5,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () =>
                          Get.toNamed(Routes.categoryProducts, arguments: {
                        'category': category[index].id == 3
                            ? "Furniture"
                            : category[index].name!,
                        'id': category[index].id!,
                      }),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FancyShimmerImage(
                            imageUrl: category[index].image!,
                            boxFit: BoxFit.fill,
                            width: double.infinity,
                          ),
                          Container(
                            color: Colors.white70,
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              category[index].id == 3
                                  ? "Furniture"
                                  : category[index].name!,
                              style: context.textTheme.titleMedium,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
