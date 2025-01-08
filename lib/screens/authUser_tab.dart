import 'package:api_practice/services/business_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final logicCtrl = Get.put(BusLogic());
    return Obx(
        ()=> Scaffold(
        bottomNavigationBar: Obx(
          ()=> BottomNavigationBar(
            selectedItemColor: TColors.tertiaryColor,
              showUnselectedLabels: false,
              selectedIconTheme: const IconThemeData(
                color: TColors.tertiaryColor,
                size: 22
              ),
              unselectedIconTheme: const IconThemeData(
              color: Colors.black38,
              size: 20
          ),
              selectedLabelStyle: const TextStyle(
                color:TColors.tertiaryColor,
                fontSize: 11
              ),
              items: const [
                BottomNavigationBarItem(icon:Icon(Icons.home_outlined,),label: "Home"),
                BottomNavigationBarItem(icon:Icon(IconlyLight.category),label: "Category"),
                BottomNavigationBarItem(icon:Icon(Icons.shopping_cart_outlined),label: "Cart"),
                BottomNavigationBarItem(icon:Icon(Icons.person_2_outlined,),label: "Profile"),
              ],
            currentIndex: logicCtrl.tabIndex.value,
            onTap: (value){
              if(value<=1){
                logicCtrl.tabIndex.value=value;
              }else{
                Get.to(logicCtrl.screens[value]);
              }
            } ,
          ),
        ),
        body: logicCtrl.screens[logicCtrl.tabIndex.value],
      ),
    );
  }
}
