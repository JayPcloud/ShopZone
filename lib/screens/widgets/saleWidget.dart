import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesWidget extends StatelessWidget {
  const SalesWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
            colors: [
              Color(0xFF7A60A5),
              Color(0xFF82C3DF),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Row(
        children: [
          Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(14),

                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFF9689CE),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Get the special discount",
                          style: context.theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10,),
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.fill,
                                child: Text("50%\nOFF", style: context.theme.textTheme.bodyLarge)),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 3,
            child: Image.asset(
              "assets/vn2da5mr.png",
              fit: BoxFit.contain,
            )
          )
        ],
      ),
    );
  }
}
