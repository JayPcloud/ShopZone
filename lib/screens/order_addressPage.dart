import 'package:api_practice/models/address_model.dart';
import 'package:api_practice/services/db_services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../routes/routes.dart';
import '../utils/constants/colors.dart';
import 'cartPage.dart';
import 'package:get/get.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DBServices.instance;
    RxBool recording = false.obs;
    final textTheme = context.textTheme;
    Rx<Country>? country = Country.worldWide.obs;
    Rx<TextEditingController> countryPicker = TextEditingController().obs;
    TextEditingController name = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();
    TextEditingController street = TextEditingController();
    TextEditingController state = TextEditingController();
    TextEditingController city = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an address'),
        leading: customButton(
          icon: Icons.arrow_back_ios_rounded,
          onTap: () => Get.back(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed:() async {
            if(_addressInputFormKey.currentState!.validate()) {
              recording.value = true;
              await db.addNewAddress(Address(
                  country: countryPicker.value.text.trim(),
                  name: name.text,
                  streetAddress: street.text,
                  state: state.text,
                  city: city.text,
                  phone: '+${country.value.phoneCode+phoneNumber.text}'
              )).then((value) {
                if(value == 'success') {
                  recording.value=false;
                  Future.delayed(const Duration(seconds: 1), () => Get.offAndToNamed(Routes.pickLocation),);
                }
              });
            }

          },
          color: TColors.tertiaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(15)),
          child: Obx(() =>recording.value?const CircularProgressIndicator():const Text('Save'),)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _addressInputFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                    ()=> textForm(
                      context: context,
                     onTap:  () => showCountryPicker(
                       showPhoneCode: true,
                       useRootNavigator: true,
                       useSafeArea: true,
                          context: context, onSelect: (Country value) {
                            countryPicker.value.text = '${value.flagEmoji} ${value.name}';
                            country.value = value;
                      }),
                    controller: countryPicker.value,
                      widget: Text(
                        'Country/Region',
                        style: textTheme.displayMedium,
                      ),
                      forCountry: true,
                      hintText: ''
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                textForm(context:context, onTap: () {}, controller: name, widget:requiredTxt(textTheme, 'First name'),forCountry: false, hintText: ''),
                const SizedBox(
                  height: 30,
                ),
                textForm(context:context, onTap: () { }, controller: phoneNumber, widget:requiredTxt(textTheme, 'Phone number'),forCountry: false,
                    hintText: 'Enter 10-11 digits number',
                    prefix:
                Obx(()=>Text('${country.value.countryCode=='WW'?'---':country.value.countryCode}  +${country.value.phoneCode}  ', style: textTheme.displayLarge,))
                ,inputType: TextInputType.number
                ),
                const SizedBox(
                  height: 30,
                ),
                textForm(context:context, onTap: () { }, controller: street, widget:requiredTxt(textTheme, 'Street address'),forCountry: false, hintText: 'Street address and number'),
                const SizedBox(
                  height: 30,
                ),
                textForm(context:context, onTap: () { }, controller: state, widget:requiredTxt(textTheme, 'State'),forCountry: false, hintText: 'State e.g New york'),
                const SizedBox(
                  height: 30,
                ),

                textForm(context:context, onTap: () { }, controller: city, widget:requiredTxt(textTheme, 'City'),forCountry: false, hintText: 'City or Town'),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget requiredTxt(textTheme, String text) {
    return  RichText(
      text:TextSpan(children: [
        TextSpan(text: text, style: textTheme.displayMedium),
        const TextSpan(text: '*', style: TextStyle(color: Colors.red,)),
      ]),
    );
  }
}
   final _addressInputFormKey = GlobalKey<FormState>();

Widget textForm(
    {required BuildContext context,
      void Function()? onTap,
    required TextEditingController controller,
    required Widget widget,
     bool forCountry = false,
      TextInputType? inputType = TextInputType.text,
      TextStyle style = const TextStyle(color:Colors.black, fontWeight: FontWeight.w400 ),
      String? hintText,
      String? Function(String?)? validator,
      Widget? prefixIcon,
      Widget? prefix,
      List<TextInputFormatter>? inputFormatters,
      bool obscureText = false,
      void Function(String)? onChanged,
      FocusNode? focusNode
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      widget,
      const SizedBox(height: 10,),
      TextFormField(
        inputFormatters: inputFormatters,
        cursorColor: TColors.secondaryColor,
        onTap: onTap,
        keyboardType: forCountry?TextInputType.none:inputType,
        obscureText: obscureText,
        onChanged: onChanged !=null ? (value) => onChanged(value) : null,
        focusNode: focusNode,
        validator:(value) {
          if(validator == null){
            return value==null?'required': value.trim().isEmpty?'required':null;
          }
          return validator(value);
        } ,
        decoration:  InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
            prefixIcon: prefixIcon,
            prefix: prefix,
            suffixIcon: forCountry?const Icon(Icons.keyboard_arrow_down_sharp): null,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            )),
        style: style,
        controller: controller,
      ),
    ],
  );
}
