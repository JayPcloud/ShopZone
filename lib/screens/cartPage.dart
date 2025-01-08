import 'package:api_practice/models/product.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../utils/constants/colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/constants/strings.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final _database = DBServices.instance;
  final helper = HelperFunc.instance;
  final logicCtrl = Get.put(BusLogic());

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 500),
          () => helper.materialBanner(
          context, const Text('Slide to remove product from cart'), this),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvoked: (didPop) =>ScaffoldMessenger.of(Get.context!).clearMaterialBanners(),
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: MaterialButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                barrierColor: Colors.transparent,
                builder: (context) =>
                    bottomSheet(screenHeight * 0.4, 800, 10, 10, 780),
              ),
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              color: TColors.tertiaryColor,
              padding: const EdgeInsets.all(1),
              child: const Text('Calculate price'),
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => Get.back()),
                  PopupMenuButton(
                      icon: customButton(icon: Icons.more_horiz,),
                      itemBuilder: (BuildContext context) {
                    return [
                       PopupMenuItem(child: const Text('remove all'),onTap: () async {
                        final db =await _database.getDatabase();
                        db.delete(Strings.dbCartTable['table']!);
                        setState(() {});
                      },)
                    ];
                  },
              ),])
            ),
          ),
          body: FutureBuilder(
            future: _database.getCartList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  logicCtrl.addToSubtotal(0, ProductModel(price: 0, qty: 0));
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(IconlyLight.bag2),
                        Text(
                          'Your cart is empty',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                return SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {

                      final product = snapshot.data![index];
                      logicCtrl.addToSubtotal(index, product);
                      return InkWell(
                        onTap: () => Get.toNamed(Routes.productDetails,
                            arguments: product),
                        child: productTile(
                            context: context,
                            height: screenHeight,
                            product: product,
                            index: index),
                      );
                    },
                  ),
                );
              }
              print(snapshot.error);
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  Widget productTile(
      {required BuildContext context,
      required ProductModel product,
      required int index,
      required double height}) {
    RxInt qty = product.qty!.obs;
    print(HelperFunc.formatUrlString(product.images![0]));
    return Slidable(
      key: Key('${product.id}'),
      startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          closeThreshold: 0.5,
          children: [
            SlidableAction(
              onPressed: (context) =>
                  _database.deleteRecord(tableName: Strings.dbCartTable['table']!,id: product.id!).then((value) {
                setState(() {});
              }),
              icon: Icons.delete_forever_rounded,
              foregroundColor: TColors.tertiaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ]),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
            height: height > 620 ? height * 0.1 : 70,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Material(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      color: TColors.secondaryColor.withOpacity(0.03),
                      child: ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(15),
                        child: FancyShimmerImage(
                          imageUrl:
                              HelperFunc.formatUrlString(product.images![0]),
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title!,
                          style: context.textTheme.displayMedium,
                        ),
                        Text(
                          product.category?.name ?? 'Item',
                          style: context.textTheme.titleSmall,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${product.price}.00',
                                style: context.textTheme.displayMedium),
                            Container(
                              margin: const EdgeInsetsDirectional.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: TColors.secondaryColor.withOpacity(0.03),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (qty.value > 1) {
                                          _database
                                              .updateCart(
                                                  id: product.id!,
                                                  qty: qty.value -= 1)
                                              .then((value) {
                                            if (value == 'success') {
                                              logicCtrl
                                                  .addOrSubtractFromSubTotal(
                                                      '-', product.price!);
                                            }
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline_sharp,
                                      )),
                                  Obx(() => Text(qty.value.toString())),
                                  InkWell(
                                    onTap: () => _database
                                        .updateCart(
                                            id: product.id!,
                                            qty: qty.value += 1)
                                        .then((value) {
                                      if (value == 'success') {
                                        logicCtrl.addOrSubtractFromSubTotal(
                                            '+', product.price!);
                                      }
                                    }),
                                    child: const Icon(
                                      Icons.add_circle_outlined,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
          const Divider(
            thickness: 0.1,
          )
        ],
      ),
    );
  }

  Widget bottomSheet(double height, double subtotal, double deliveryFee,
      double discount, double total) {
    // final animCtrl = AnimationController(vsync: this);
    Widget row(String string, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            string,
            style: context.textTheme.titleSmall,
          ),
          Text(
            value,
            style: string == 'Discount :'
                ? const TextStyle(
                    color: TColors.tertiaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)
                : context.textTheme.displayMedium,
          )
        ],
      );
    }

    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      // animationController: animCtrl,
      builder: (context) {
        return Container(
          height: height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: TColors.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                row('subtotal :', '\$${logicCtrl.subtotal}'),
                row('Delivery Fee :', '\$$deliveryFee'),
                row('Discount :', '$discount%'),
                const Divider(
                  thickness: 0.05,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: row('Total :', '\$${logicCtrl.subtotal>0?logicCtrl.total():'0.00'}')),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: MaterialButton(
                      onPressed: () async {
                        if(logicCtrl.subtotal < 20){
                          HelperFunc.instance.materialBanner(context,const Text('Your subtotal must be up to \$20 before checking out'), this);
                        }else{
                          HelperFunc.showLoadingCircle(context);
                          await Future.delayed(const Duration(seconds: 2));
                          final addressList = await _database.getAllAddress();
                          Navigator.of(context).pop();
                          addressList.isEmpty?Get.toNamed(Routes.addAddress):Get.toNamed(Routes.pickLocation);
                        }
                      },
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(20)),
                      color: TColors.tertiaryColor,
                      padding: const EdgeInsets.all(15),
                      child: const Text('Check out'),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
Widget customButton({required IconData icon, void Function()? onTap}) {
  return MaterialButton(
    onPressed: onTap,
    color: TColors.secondaryColor.withOpacity(0.03),
    shape: const CircleBorder(),
    elevation: 0,
    padding: EdgeInsets.zero,
    minWidth: 60,
    height: 40,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    child: Icon(
      icon,
      size: 18,
    ),
  );
}
