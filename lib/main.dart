import 'package:api_practice/routes/routes.dart';
import 'package:api_practice/screens/order_addressPage.dart';
import 'package:api_practice/screens/payment_checkoutPage.dart';
import 'package:api_practice/screens/pick_addressPage.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBServices.instance;
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TTheme.theme,
      getPages: Routes.routes,
      //home: const CheckoutPage(),
      initialRoute: Routes.userValidator,
    );
  }
}
