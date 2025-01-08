import 'package:api_practice/models/address_model.dart';
import 'package:api_practice/screens/order_addressPage.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:api_practice/utils/textInput_formatter.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../utils/constants/colors.dart';
import 'cartPage.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with TickerProviderStateMixin{
  final TextEditingController cardNo = TextEditingController();
  final TextEditingController cardName = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();
  final TextEditingController cvv = TextEditingController();
  final _dbServices = DBServices.instance;
  RxDouble totalPrice = 0.0.obs;
  double price = 0;
  RxInt bodyIndex = 0.obs;


 final arguments = Get.arguments;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> uniqueBody = [
      cardPaymentBody(context,cardName,cardNo, expiryDate, cvv, arguments),
      otherPaymentBody(),
      otherPaymentBody()
    ];
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1))
            .then((value) => _dbServices.getCartList()),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          price = 0.0;
          for(var product in snapshot.data!) {
            price += product.price! * product.qty!;
          }
          Future.delayed(const Duration(seconds: 1), (){totalPrice.value = (9/10)*(price+10);} );

          return PopScope(
            onPopInvoked:(_)=> ScaffoldMessenger.of(context).clearMaterialBanners(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                  child: Row(
                    children: [
                      customButton(
                          icon: Icons.arrow_back_ios_rounded, onTap: () => Get.back()),
                      const SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Checkout',
                        style: context.textTheme.displayLarge,
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Obx(
                    ()=> bodyIndex.value == 0 ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: MaterialButton(
                    onPressed: () async {
                      if(_cardDetailsFormKey.currentState!.validate()){
                        HelperFunc.showLoadingCircle(context);
                        await Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context),);
                        HelperFunc.instance.materialBanner(context, const Text('Services not available at the moment'),this);
                      }
                    },
                    color: TColors.tertiaryColor,
                    minWidth: 250,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    elevation: 20,
                    child: Obx(
                          ()=>  totalPrice.value>0.0?Text(
                           'Pay \$${totalPrice.value.toStringAsFixed(2)}',
                        style: context.textTheme.displayLarge,
                      ):const Text('loading...'),
                    ),
                  ),
                ):const SizedBox(),
              ),
              body: SingleChildScrollView(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Payment method',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: double.infinity,
                          child: Row(
                            children: [
                              payTypeTile('assets/card_icon.jpg', 0),
                              const SizedBox(
                                width: 10,
                              ),
                              payTypeTile('assets/paypal_logo.jpeg', 1),
                              const SizedBox(
                                width: 10,
                              ),
                              payTypeTile('assets/6d55041c3b97a4a23d2976d1f8439b03_2.jpg', 2),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Order Summary',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.7,
                              margin: const EdgeInsetsDirectional.only(start: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color: Colors.black)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadiusDirectional.circular(20),
                                          child: FancyShimmerImage(
                                            imageUrl: product.images![0],
                                            errorWidget: Image.asset('assets/vn2da5mr.png'),
                                          ))),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title!,
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'qty: ${product.qty}',
                                          style: const TextStyle(
                                              color: Colors.black54, fontSize: 13),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'price: \$${product.price}',
                                          style: const TextStyle(
                                              color: Colors.black54, fontSize: 13),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Obx(
                                () => totalPrice.value>0.0?Text(
                                  'Order Total: \$${totalPrice.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ):const Text('...'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Obx(()=> uniqueBody[bodyIndex.value]),
                    ],
                  )
              ),
            ),
          );
        }else{
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }

  Widget payTypeTile(String img, int index) {
    return Obx(
        ()=> Expanded(
        child: InkWell(
          onTap: () async {
            if(index > 0) {
              HelperFunc.showLoadingCircle(context);
              await Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pop(),);
              HelperFunc.scaffoldMessenger(context, const Row(children: [
                Text('Service Unavailable!'),
                Spacer(),
                Icon(Icons.error_outline,)
              ],));
            }
            bodyIndex.value = index;
          },
          child: Material(
            elevation: bodyIndex.value == index ? 20 : 0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: bodyIndex.value == index
                      ? Border.all(color: Colors.blue, width: 2)
                      : Border.all(color: Colors.blue.withOpacity(0.1), width: 0.7)
                  ),
              child: Image.asset(
                img,
                height: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
final _cardDetailsFormKey = GlobalKey<FormState>();

FocusNode cvvFocusNode = FocusNode();

Widget cardPaymentBody (BuildContext context, cardName, cardNo, expiryDate, cvv, Address argument) {
  return Form(
    key: _cardDetailsFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Card-Details',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: textForm(
            context: context,
            hintText: 'Card Number',
            controller: cardNo,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            prefixIcon: const Icon(Icons.credit_card_outlined, color: Colors.black45,),
            inputType: TextInputType.number,
            validator: (p0) {
              if(p0 == null || p0.trim().isEmpty){
                return 'required';
              }
              return p0.length < 15 ? 'invalid card no.':null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
              CardNumberInputFormatter()
            ],
            widget: const SizedBox(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: textForm(
            context: context,
            hintText: 'Card Name',
            controller: cardName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            prefixIcon: const Icon(IconlyLight.profile, color: Colors.black45,),
            widget: const SizedBox(
              height: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: textForm(
                    context: context,
                    hintText: 'MM/YY',
                    controller: expiryDate,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter()
                    ],
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(IconlyLight.calendar, color: Colors.black45,),
                    onChanged: (p0) {
                      if(p0.length >= 5) {
                        cvvFocusNode.requestFocus();
                      }
                    },
                    validator: (p0) {
                      if(p0 == null || p0.trim().isEmpty){
                        return 'required';
                      }
                      return p0.length < 5 ? 'invalid date':null;
                    },
                    widget: const SizedBox(
                      height: 10,
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: textForm(
                    context: context,
                    hintText: 'CVV',
                    controller: cvv,
                    obscureText: true,
                    inputType: TextInputType.number,
                    focusNode: cvvFocusNode,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    prefixIcon:const Icon(IconlyLight.password, color: Colors.black45,),
                    validator: (p0) {
                      if(p0 == null || p0.trim().isEmpty){
                        return 'required';
                      }
                      return p0.length < 3 ? 'invalid cvv':null;
                    },
                    widget: const SizedBox(
                      height: 10,
                    ),
                  )),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Column(
              children: [
                const Icon(Icons.location_on, color: TColors.tertiaryColor,),
                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                              children: [
                                const Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address :',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      'City',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      'State',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      'Country',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      'Phone',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.1,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(''),
                                    Text(argument.city),
                                    Text(argument.state),
                                    Text(argument.country),
                                    Text(argument.phone),
                                  ],
                                ),
                              ],
                            ),
                      );


                    },);
                  },
                  child: const Text('View/Edit Shipping Location',
                      style: TextStyle(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                      )),
                ),
              ],
            ),
          ),
        )
      ],),
  );
}

Widget otherPaymentBody() {
  return const Center(child: Text('Payment method not available at the moment. Please make use of the Card method', style: TextStyle(fontStyle: FontStyle.italic)
    ,textAlign: TextAlign.center,
    ));
}