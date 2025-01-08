import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/colors.dart';

class HelperFunc extends GetxController{

  HelperFunc._();

  static final instance = HelperFunc._();



  static String formatUrlString (String imageUrl){
    String string = imageUrl.replaceAll('[','');
    String oldString = string.replaceAll('"','');
    String nString = oldString.replaceAll(']','');
    String newString = nString.replaceAll('\\','');
    print(newString);
    return newString;
}


  static String? validatePassword(String password) {
    if(password.isEmpty) {
      return 'Password cannot be empty';
    }
    if(password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if(!hasLowerCase(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if(!hasUpperCase(password)){
      return 'Password must contain at least one uppercase letter';
    }
    if(!hasNumber(password)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
  static bool hasLowerCase(String string) {
    return string.contains(RegExp(r'[a-z]'));
  }
  static bool hasUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }
  static bool hasNumber(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }
  // static bool hasLowerCase(String password) {
  //   return password.contains(RegExp(r'[a-z]'));
  // }


  static Map<String, dynamic> parseJWToken(String token) {
    final parts = token.split(r'.');

    final Map<String, dynamic> json = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
    );
    return json;
  }

  static void showLoadingCircle(BuildContext context) {
  showDialog(context: context,
    barrierDismissible: false,

    builder: (context) => const Center(child: CircularProgressIndicator(strokeWidth: 3,)),);
}

  static void scaffoldMessenger(BuildContext context, Widget content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:content,backgroundColor: Colors.black38,)
    );
  }


   void materialBanner(BuildContext context, Widget content, TickerProvider vsync ) {
    ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          animation: AnimationController(vsync: vsync,animationBehavior: AnimationBehavior.preserve,duration:const Duration(milliseconds: 500)),
            dividerColor: Colors.transparent,
            onVisible: () => Future.delayed(const Duration(seconds: 5),() =>ScaffoldMessenger.of(context).removeCurrentMaterialBanner()),
            content: Container(
              decoration: BoxDecoration(
                color: TColors.tertiaryColor.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsetsDirectional.all(10),
              child: content,
            ), actions: [
          InkWell(child: const Icon(Icons.close),onTap: ()=>ScaffoldMessenger.of(context).clearMaterialBanners(),)
        ])
    );
  }

  @override
  void dispose() {
    ScaffoldMessenger.of(Get.context!).removeCurrentMaterialBanner( reason: MaterialBannerClosedReason.swipe);
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
    super.dispose();
  }
}