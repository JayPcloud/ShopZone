import 'package:api_practice/utils/helper_functions.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../routes/routes.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    //print(product);
    return InkWell(
      onTap: ()=>Get.toNamed(Routes.productDetails, arguments: product),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadiusDirectional.circular(10),
          child: GridTile(
            header: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}.00", style: context.textTheme.headlineSmall,),
                  const Icon(IconlyBold.heart, size: 12,)
                ],
              ),
            ),
            footer:  Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(product.title!, style: context.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,),
            ),
            child: FancyShimmerImage(
              imageUrl: HelperFunc.formatUrlString(product.images![0]) ,
              width: double.infinity,
              height: 20,
              boxFit: BoxFit.fill,
               errorWidget: Image.asset("assets/vn2da5mr.png"),
            ),

          ),
        ),
      ),
    );
  }
}
