import 'package:api_practice/screens/authUser_tab.dart';
import 'package:api_practice/screens/home.dart';
import 'package:api_practice/screens/Auth0_page.dart';
import 'package:api_practice/services/auth_Handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthValidator extends StatefulWidget {
  const AuthValidator({super.key});

  @override
  State<AuthValidator> createState() => _AuthValidatorState();
}

class _AuthValidatorState extends State<AuthValidator> {
  final auth = Get.put(Auth0());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.isAuth0TokenValid().onError((error, stackTrace) =>false),
      builder: (context, snapshot) {

        if(snapshot.hasError){
          return const Auth0Page();
        }

        if (snapshot.hasData) {
          final isAuthenticated = snapshot.data;
          print(isAuthenticated);

         return isAuthenticated == true ? const BottomNav() : const Home();
        }else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

      },
    );
  }
}
