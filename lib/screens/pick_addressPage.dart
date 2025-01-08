import 'package:api_practice/models/address_model.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/strings.dart';
import 'cartPage.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({
    super.key,
  });

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage>
    with TickerProviderStateMixin {

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 500),
          () => HelperFunc.instance.materialBanner(
          context, const Text('Tap to Select a location and continue'), this),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Rx<Address> address = Address(
            country: '',
            name: '',
            streetAddress: '',
            state: '',
            city: '',
            phone: '')
        .obs;

    final db = DBServices.instance;
    return PopScope(
      onPopInvoked: (didPop) =>
          ScaffoldMessenger.of(context).clearMaterialBanners(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: Row(
              children: [
                customButton(
                    icon: Icons.arrow_back_ios_rounded,
                    onTap: () => Get.back()),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  'Pick Shipping Location',
                  style: context.textTheme.displayLarge,
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              if (address.value.phone.isNotEmpty) {
                Get.toNamed(Routes.payment, arguments: address.value);
              } else {
                Get.offAndToNamed(Routes.addAddress);
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            color: TColors.tertiaryColor.withOpacity(0.1),
            child: Obx(() => Text(address.value.name.trim().isNotEmpty
                ? 'Continue'
                : 'Add new Address')),
          ),
        ),
        body: FutureBuilder(
          future: db.getAllAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final addressList = snapshot.data;
              if (addressList!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Address List is Empty'),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      final location = snapshot.data![index];
                      RxBool delete = false.obs;
                      return InkWell(
                        onLongPress: () => delete.value = !delete.value,
                        onTap: () {
                          if (address.value == location) {
                            address.value = Address(
                                country: '',
                                name: '',
                                streetAddress: '',
                                state: '',
                                city: '',
                                phone: '');
                          } else {
                            address.value = location;
                          }
                        },
                        child: Column(
                          children: [
                            Obx(
                              () => Material(
                                elevation: address.value == location?5:1,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: address.value == location
                                          ? Border.all(
                                              color: TColors.tertiaryColor)
                                          : null,
                                      color: TColors.tertiaryColor
                                          .withOpacity(0.01)),
                                  child: Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Address :',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            'City',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            'State',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            'Country',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            'Phone',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(''),
                                          Text(location.city),
                                          Text(location.state),
                                          Text(location.country),
                                          Text(location.phone),
                                        ],
                                      ),
                                      const Spacer(),
                                      TapRegion(
                                        onTapOutside: (_)=>delete.value=false,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: delete.value
                                              ? IconButton(
                                           splashColor: Colors.black38,
                                                  onPressed: (){
                                                    db.deleteRecord(tableName: Strings.dbAddressTableName, id: location.id!);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                              : address.value.name ==
                                                      location.name
                                                  ? const Icon(
                                                      Icons.fmd_good,
                                                      color:
                                                          TColors.tertiaryColor,
                                                    )
                                                  : const Icon(
                                                      Icons.fmd_good_outlined,
                                                      color: Colors.black38,
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    },
                  ));
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'An error occurred\nRestart App',
                textAlign: TextAlign.center,
              ));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
