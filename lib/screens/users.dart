import 'package:api_practice/models/users.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/fakeStoreAPI_handler.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final logicCtrl = Get.put(BusLogic());
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(IconlyLight.arrowLeft),
          ),
          title: const Text(
            "All Users",
          ),
        ),
        body: FutureBuilder<List<UserModel>>(
          future: StoreAPI.getAllUsers(),
          builder: (context, snapshot) {
            return logicCtrl.snapshotHandler(snapshot, () {
              final user = snapshot.data!;
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: FancyShimmerImage(
                      imageUrl: user[index].picture!,
                      height: 40,
                      width: 40,
                    ),
                    title: Text(user[index].name!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                    subtitle: Text(user[index].email!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        )),
                    trailing: Text(
                      user[index].role!,
                      style: const TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            });
          },
        ));
  }
}
