import 'dart:async';
import 'dart:io';
import 'package:api_practice/screens/ProfilePage.dart';
import 'package:api_practice/screens/cartPage.dart';
import 'package:api_practice/screens/categories.dart';
import 'package:api_practice/screens/home.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:api_practice/services/fakeStoreAPI_handler.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../routes/routes.dart';
import '../utils/constants/strings.dart';
import 'db_services.dart';

class BusLogic extends GetxController {

  ///    -------------------------variables-----------------------------
  //bottomNav Page
  RxInt tabIndex = 0.obs;

  // All products Page
  RxInt productLimit = 10.obs;

  RxInt offset = 0.obs;

  RxBool reachedMax = false.obs;

  Rx<String> errString = ''.obs;

  ScrollController scrollController = ScrollController();

  // home Page
  final latestProductsNotifier = ValueNotifier(false);

  // product_details Page
  final database = DBServices.instance;
  RxBool addingToCart = false.obs;

  //Carts Page
  RxInt _subtotal = 0.obs;

  int get subtotal => _subtotal.value;


  /// -------------------------Lists-----------------------------
  // All Products Page
  RxList<ProductModel> fetchedProducts = RxList<ProductModel>([]);

  // Bottom_Nav Page
  RxList<Widget> screens = RxList<Widget>([
    const Home(isAuthenticated: true),
    const Categories(isAuthenticated: true),
    const CartPage(),
    const ProfilePage(isAuthenticated: true)
  ]);


  /// -------------------------Functions-----------------------------
  //  All Products Page
  Future<void> fetchMoreProducts(
    int limit,
  ) async {
    fetchedProducts.value = await StoreAPI.getAllProducts(queryParameter: {
      'limit': ['$limit'],
      'offset': ['0']
    }).catchError((err) {
      err is SocketException
          ? errString.value = 'network error'
          : errString.value = err.toString();
      throw Exception(err.toString());
    });
    print('fetchedProducts:${fetchedProducts.length}');
  }

  Future<void> refreshAllProducts() async {
    errString.value = '';
    productLimit = 10.obs;
    fetchMoreProducts(
      productLimit.value,
    );
  }

  //Home Page
  Future<void> toggleValueNotifier(ValueNotifier value) async {
    value.value = !value.value;
  }

  // Product_Details Page
  Future<void> addToCart(ProductModel product) async {
    addingToCart.value=true;
    await Future.delayed(const Duration(seconds: 1));
    final status = await database.addToCart(product: product);
    if(status == 'success'){
      HelperFunc.scaffoldMessenger(Get.context!, const Text('Added to cart'));
    }else{
      HelperFunc.scaffoldMessenger(Get.context!, const Text('An error occurred'));
    }
    addingToCart.value=false;
  }
 //Cart Page
  Future<void> removeFromCart(int id) async {
    final status = await database.deleteRecord(tableName: Strings.dbCartTable['table']!,id: id);
    if(status == 'success'){
      HelperFunc.scaffoldMessenger(Get.context!, const Text('Removed from cart'));
    }else{
      HelperFunc.scaffoldMessenger(Get.context!, const Text('An error occurred'));
    }
  }

  void addOrSubtractFromSubTotal(String operator, int price) {
    if(operator == '+'){
      _subtotal += price;
    }else{
      _subtotal -= price;
    }
    print(_subtotal);
  }

  void addToSubtotal(int index, ProductModel product) {
    if(index == 0){
      _subtotal.value = 0;
    }
    final price = product.price! * product.qty!;
    _subtotal.value += price;
    print(_subtotal.value);
  }

  String total() {
    final netPrice = _subtotal.value + 10;
    final total = (9/10) * netPrice;
    if(total < 1)return 0.toStringAsFixed(2);
    return total.toStringAsFixed(2);
  }




  /// ------------------General---------------------------
  // General
  Widget snapshotHandler( AsyncSnapshot snapshot,
      dynamic Function() hasData) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: CircularProgressIndicator(),
      ));
    } else if (snapshot.hasData) {
      print(snapshot.data.length);
      return hasData();
    } else if (snapshot.hasError) {
      bool specificError = snapshot.error.toString() ==
              'Exception: socket error' ||
          snapshot.error.toString() == 'Exception: User not authorized/authenticated' ||
          snapshot.error.toString() == 'Exception: Token request error';
      bool isSocketError =
          snapshot.error.toString() == 'Exception: socket error';
      return specificError
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isSocketError?Icons.wifi_off:Icons.no_accounts_outlined,
                    size: 30,
                    color: Colors.red[200],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(isSocketError
                      ? "No internet connection. Please ensure a stable connection and retry"
                      : "Session Timeout, please re-authenticate"),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => isSocketError
                        ? toggleValueNotifier(latestProductsNotifier)
                        : Get.offAllNamed(Routes.trial),
                    child: Text(
                      isSocketError ? "refresh" : "login",
                      style: Get.context!.textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
          )
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Error-${snapshot.error.toString()}',
                    style: Get.context!.textTheme.bodyMedium),
              ),
            );
    } else {
      return Center(
          child: Text("Something went wrong",
              style: Get.context!.textTheme.bodyMedium));
    }
  }

  @override
  void onInit() {
    errString.value = '';
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('total limit:${productLimit.value}');
        if (productLimit.value >= 133) {
          reachedMax.value = true;
          return;
        }
        reachedMax.value ? reachedMax.value = false : null;
        await fetchMoreProducts(
          productLimit.value+=10,
        );
        //productLimit.value += 10;
      }
    });
    super.onInit();
  }


  /// To create a singleton class i.e all instances of a particular class created
  /// anywhere returns just the same instance, use this below

  /// BusLogic._();
  /// static BusLogic? _instance;
  /// static BusLogic getInstance() {
  ///   _instance ??= BusLogic._();
  ///   return _instance!;
  /// }
}
