import 'package:api_practice/models/product.dart';
import 'package:api_practice/models/users.dart';
import 'package:api_practice/screens/blanc_screen.dart';
import 'package:api_practice/services/auth_Handler.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../utils/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.isAuthenticated = false});

  final bool isAuthenticated;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

   Rx<UserModel> user = UserModel().obs;
   final _auth0 = Get.put(Auth0());
   final _dbServices = DBServices.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _auth0.fetchIdToken().then((value){
          user.value = UserModel.fromJson(value);
          return _dbServices.getCartList();
        }),
        builder:(context, snapshot) {
          if(snapshot.hasData) {
            final cartList = snapshot.data;
            return body(totalInCart: cartList!.length.toString());
          }
         return body();
        },

      ),
    );
  }

  Widget body({String totalInCart = '00'}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: TColors.tertiaryColor,
                child: Obx(
                      ()=>user.value.name==null?const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage:
                      AssetImage('assets/noProfile_picture.jpg')):CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage:NetworkImage(user.value.picture!)),

                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Obx(
                    ()=> Text(
                  user.value.name==null?'Username':user.value.name!,
                  style:
                  TextStyle(fontSize: context.width <= 260.0 ? 12 : null),
                ),
              ),
              const Spacer(),
              if(!widget.isAuthenticated)MaterialButton(
                onPressed:()=>_auth0.authenticate(context),
                minWidth: context.width <= 240.0 ? 60 : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    side: const BorderSide(color: TColors.tertiaryColor)),
                child: Text(
                  'Login',
                  style:
                  TextStyle(fontSize: context.width <= 287.0 ? 12 : null),
                ),
              )
              else(IconButton(icon:const Icon(IconlyLight.logout, color: TColors.tertiaryColor,),
                onPressed: (){
                HelperFunc.scaffoldMessenger(context,const Text('Logging out...'));
                  _auth0.endAuthSession(context);
                },))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              profileTile(context, 'Cart', value: widget.isAuthenticated?totalInCart:'00'),
              profileTile(context, 'Orders',),
              profileTile(context, 'Received')
            ],
          ),
        ),
        listTile(
            context: context,
            title: 'Credit balance',
            icon: IconlyLight.wallet,
            opacity: 0.03,
            onTap: ()=> HelperFunc.scaffoldMessenger(context, const Text('Fund your wallet to continue')),
            width: 20),
        const SizedBox(
          height: 20,
        ),
        listTile(
          context: context,
          title: 'Messages',
          icon: IconlyLight.chat,
          onTap: ()=>Get.to(const BlancScreen(body: Center(child: Text('No messages yet', style: TextStyle(fontStyle: FontStyle.italic),),)))
        ),
        listTile(
          context: context,
          title: 'Your Reviews',
          icon: Icons.reviews_outlined,
            onTap: ()=>Get.to(const BlancScreen(body: Center(child: Text('Your recent reviews will appear here', style: TextStyle(fontStyle: FontStyle.italic),),)))
        ),
        listTile(
          context: context,
          title: 'Coupons and offers',
          icon: Icons.wallet_giftcard,
            onTap: ()=>Get.to(const BlancScreen(body: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No offers', style: TextStyle(fontStyle: FontStyle.italic),),
                SizedBox(width: 20,),
                Icon(Icons.local_offer_outlined)
              ],
            ),)))

        ),
      ],
    );
  }

  Widget profileTile(BuildContext context, String tag, {String value = '00'}) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: TColors.secondaryColor.withOpacity(0.09),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: '$value\n',
              style: context.textTheme.displayMedium,
              children: [
                TextSpan(text: tag, style: context.textTheme.bodyMedium)
              ]),
        ),
      ),
    ));
  }

  Widget listTile(
      {required BuildContext context,
      required String title,
      required IconData icon,
      double width = 0.4,
      double opacity = 0.2,
        void Function()? onTap
      }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      onTap: onTap,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: Text(
        title,
        style: context.textTheme.titleMedium,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
        size: 18,
      ),
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black38.withOpacity(opacity), width: width)),
    );
  }
}
