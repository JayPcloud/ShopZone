import "package:api_practice/models/auth_user.dart";
import "package:api_practice/utils/helper_functions.dart";
import "package:flutter/material.dart";
import "package:flutter_login/flutter_login.dart";
import "package:get/get.dart";
import "../routes/routes.dart";
import "../services/auth_Handler.dart";
import "../utils/constants/strings.dart";

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth0 = Get.put(Auth0());
    return FlutterLogin(
      validateUserImmediately: true,
      onSignup: (signup) async {
        final user = await auth0.signUp(AuthUserModel(
            email: signup.name,
            password: signup.password,
            connection: Strings.authDBConnection,
            username: signup.additionalSignupData!['username'],

        ));
        return null;
      },
      additionalSignupFields: const [
        UserFormField(
          keyName: "username",
          userType: LoginUserType.name,
        ),
      ],
      //passwordValidator: (password)=> HelperFunc.validatePassword(password??''),
      onLogin: (loginData) {
        Auth0().authWithPassword(username:loginData.name, password: loginData.password);
        print(loginData.name);
        print(loginData.password);
        return null;
      },
      onRecoverPassword: (string) {
        return null;
      },
      // confirmSignupRequired: (loginData){
      //   Future<bool> onconfirm() async {
      //     return await Future.delayed(Duration(seconds: 2)).then((value) => true);
      //   }
      //   return onconfirm();
      // },
      // onConfirmSignup: (string, loginData){
      //   print('onconfirm signup');
      //   Get.toNamed(Routes.auth);
      //   return null;
      // },
      messages: LoginMessages(
        confirmSignupSuccess: 'success\n login to your new account'
      ),
      //onSubmitAnimationCompleted: ()=>Get.toNamed(Routes.bottomNav),
      navigateBackAfterRecovery: true,
      title: "Authentication",
      theme: LoginTheme(
          inputTheme: const InputDecorationTheme(
            fillColor: Colors.black38,
            filled: true,
          ),
          titleStyle: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          footerTextStyle: context.textTheme.bodyMedium,
          textFieldStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          switchAuthTextColor: Colors.black,
          primaryColorAsInputLabel: true,
          buttonStyle: const TextStyle(
            color: Color(0xFFC03BEC),
          )),
    );
  }
}
