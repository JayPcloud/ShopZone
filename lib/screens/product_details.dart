import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../utils/constants/colors.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final argument = Get.arguments;
  final logicCtrl = Get.put(BusLogic());
  final db = DBServices.instance;

  RxBool isInCart = false.obs;

  @override
  void initState() {
    assignIsInCart();
    super.initState();
  }

  void assignIsInCart() async {
    isInCart.value = await db.cartContainsProduct(argument.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 0,
        child: Obx(
          () => logicCtrl.addingToCart.value
              ? const CircularProgressIndicator()
              : PopupMenuButton(
                  color: Colors.white,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  itemBuilder: (BuildContext context) {
                    return [
                      isInCart.value?
                      PopupMenuItem(
                        onTap: () {
                          logicCtrl.removeFromCart(argument.id);
                          isInCart.value = false;
                        },
                        child: const Text('Remove From Cart'),
                      ):
                      PopupMenuItem(
                        onTap: () {
                          logicCtrl.addToCart(argument);
                          isInCart.value = true;
                        },
                        child: const Text('Add to cart'),
                      ),
                      PopupMenuItem(
                          child: const Text('View Cart'),
                          onTap: () => Get.toNamed(Routes.cart)),
                    ];
                  },
                  icon: const Icon(
                    Icons.add_shopping_cart_sharp,
                    color: TColors.tertiaryColor,
                    size: 30,
                  )),
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(), child: const Icon(IconlyLight.arrowLeft)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    argument.images.length < 3
                        ? 'Furniture'
                        : argument.category.name,
                    style: context.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      argument.title!,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  Flexible(flex: 1, child: Text("\$${argument.price}.00")),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Swiper(
                itemCount: 3,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.black45,
                        color: Colors.red,
                        size: 8)),
                curve: Curves.bounceIn,
                autoplay: true,
                itemBuilder: (context, index) => FancyShimmerImage(
                  imageUrl: argument.images.length < 3
                      ? argument.images![0]
                      : argument.images![index],
                  boxFit: BoxFit.fitWidth,
                  errorWidget: Image.asset("assets/vn2da5mr.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description", style: context.textTheme.titleLarge),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(argument.description!,
                      style: context.textTheme.displayMedium),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
