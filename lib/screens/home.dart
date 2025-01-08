import 'dart:math';
import 'package:api_practice/models/product.dart';
import 'package:api_practice/screens/widgets/feeds_widget.dart';
import 'package:api_practice/screens/widgets/saleWidget.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/fakeStoreAPI_handler.dart';
import 'package:api_practice/utils/constants/colors.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/auth_Handler.dart';

class Home extends StatelessWidget {
  const Home({super.key, this.isAuthenticated = false});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final logicCtrl = Get.put(BusLogic());
    final auth = Get.put(Auth0());
    return Scaffold(
      appBar: !isAuthenticated
          ? AppBar(
              title: const Text("Home"),
              leading: InkWell(
                  onTap: () => Get.toNamed(Routes.categories),
                  child: const Icon(IconlyBold.category,
                      color: TColors.tertiaryColor)),
              actions: [
                IconButton(
                    onPressed: () => Get.toNamed(Routes.profile),
                    icon: const Icon(
                      Icons.person,
                      color: TColors.tertiaryColor,
                    ))
              ],
            ):null,
      bottomNavigationBar: !isAuthenticated?Padding(
        padding: const EdgeInsets.all(8.0),
        child:MaterialButton(
            onPressed:()=>auth.authenticate(context),
            minWidth:double.infinity,
            color: const Color(0xFF7A60A5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10),
               // side: const BorderSide(color:Color(0xFF7A60A5))
            ),
            child: Text(
              'Login/Register',
              style:
              TextStyle(fontSize: context.width <= 287.0 ? 12 : null),
            ),),
      ):null,
      body: RefreshIndicator(
        onRefresh: () => logicCtrl.toggleValueNotifier(logicCtrl.latestProductsNotifier),
        child: ValueListenableBuilder(
          valueListenable: logicCtrl.latestProductsNotifier,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              children: [
               if(isAuthenticated)
                    const SizedBox(
                        height: 40,
                      ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: context.theme.textTheme.bodyMedium,
                      cursorColor: context.theme.colorScheme.outline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color(0xCFF7F4F8),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xCFF7F4F8)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: Icon(
                          IconlyLight.search,
                          color: context.theme.iconTheme.color,
                        ),
                        hintText: "Search",
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if(!isAuthenticated)Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    HelperFunc.scaffoldMessenger(context, const Text('Please log in to access your cart and place orders'));
                                  },
                                  child: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Color(0xFFEC3B64),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          child: Swiper(
                            allowImplicitScrolling: true,
                            itemCount: 3,
                            autoplay: true,
                            control: const SwiperControl(size: 10),
                            controller: SwiperController(),
                            pagination: const SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                  activeColor: Colors.red,
                                  size: 5,
                                )),
                            itemBuilder: (context, index) =>
                                const SalesWidget(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Latest Products",
                            style: context.textTheme.displayLarge,
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () => Get.toNamed(Routes.feeds),
                              icon: const Icon(IconlyBold.arrowRight2))
                        ],
                      ),
                      FutureBuilder<List<ProductModel>>(
                        future: StoreAPI.getAllProducts(queryParameter: {
                          'offset': ['0'],
                          'limit': ['10']
                        }),
                        builder: (context, snapshot) {
                          return logicCtrl.snapshotHandler(snapshot,
                              () {
                            final random = Random();
                            final shuffledList = snapshot.data!
                              ..shuffle(random)
                              ..toList();
                            final latestProducts =
                                shuffledList.take(5).toList();
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: latestProducts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: latestProducts[index],
                                );
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
