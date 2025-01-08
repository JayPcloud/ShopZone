import 'package:api_practice/auth_validator.dart';
import 'package:api_practice/screens/all_products.dart';
import 'package:api_practice/screens/authPage.dart';
import 'package:api_practice/screens/authUser_tab.dart';
import 'package:api_practice/screens/cartPage.dart';
import 'package:api_practice/screens/home.dart';
import 'package:api_practice/screens/Auth0_page.dart';
import 'package:api_practice/screens/order_addressPage.dart';
import 'package:api_practice/screens/payment_checkoutPage.dart';
import 'package:api_practice/screens/pick_addressPage.dart';
import 'package:get/get.dart';

import '../screens/ProfilePage.dart';
import '../screens/categories.dart';
import '../screens/category_products.dart';
import '../screens/product_details.dart';
import '../screens/users.dart';
class Routes {

  static String get auth => "/auth";
  static String get home => "/home";
  static String get feeds => "/feeds";
  static String get productDetails => "/productDetails";
  static String get categories => "/categories";
  static String get allUsers => "/allUsers";
  static String get categoryProducts => "/categoryProducts";
  static String get bottomNav => "/bottomNav";
  static String get userValidator => "/userValidator";
  static String get trial => "/trial";
  static String get profile => "/profile";
  static String get cart => "/cart";
  static String get addAddress => "/address";
  static String get pickLocation => "/pickLocation";
  static String get payment => "/payment";

  static List<GetPage> routes = [
    GetPage(name: auth, page:()=> const AuthPage(), transition: Transition.fade),
    GetPage(name: home, page:()=> const Home(), transition: Transition.fade),
    GetPage(name: feeds, page:()=> const FeedsPage(), transition: Transition.fade),
    GetPage(name: productDetails, page:()=> const ProductDetails(), transition: Transition.fade),
    GetPage(name: categories, page:()=> const Categories(), transition: Transition.fade),
    GetPage(name: allUsers, page:()=> const AllUsers(), transition: Transition.fade),
    GetPage(name: categoryProducts, page:()=> const CategoryProducts(), transition: Transition.fade),
    GetPage(name: bottomNav, page:()=> const BottomNav(), transition: Transition.fade),
    GetPage(name: userValidator, page:()=> const AuthValidator(), transition: Transition.fade),
    GetPage(name: trial, page:()=> const Auth0Page(), transition: Transition.fade),
    GetPage(name: profile, page:()=> const ProfilePage(), transition: Transition.fade),
    GetPage(name: cart, page:()=> const CartPage(), transition: Transition.fade),
    GetPage(name: addAddress, page:()=> const AddressPage(), transition: Transition.fade),
    GetPage(name: pickLocation, page:()=> const PickLocationPage(), transition: Transition.fade),
    GetPage(name: payment, page:()=> const CheckoutPage(), transition: Transition.fade),
  ];
}