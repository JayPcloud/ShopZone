import 'package:flutter/material.dart';

import '../services/auth_Handler.dart';

class Auth0Page extends StatelessWidget {
  const Auth0Page({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
          child:
        MaterialButton(onPressed:
            ()=>Auth0().authenticate(context),
        child: const Text("authorize"),
        ),
      )
    );
  }
}
