import 'package:api_practice/screens/widgets/feeds_widget.dart';
import 'package:api_practice/services/business_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final logicCtrl = Get.put(BusLogic());

  @override
  void initState() {
    logicCtrl.fetchMoreProducts(10);
    logicCtrl.productLimit.value = 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Products"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              print(logicCtrl.errString);
              return logicCtrl.fetchedProducts.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: () => logicCtrl.refreshAllProducts(),
                child: SingleChildScrollView(
                  controller: logicCtrl.scrollController,
                  child: Column(
                    children: [
                      GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 20),
                        itemCount: logicCtrl.fetchedProducts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: logicCtrl.fetchedProducts[index],
                          );
                        },
                      ),
                      logicCtrl.reachedMax.value
                          ? Text(
                        "You have reached the last product, refresh",
                        style: context.textTheme.bodyMedium,
                      )
                          : const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              )
                  : logicCtrl.errString.value.isNotEmpty
                  ? errorWidget(logicCtrl.errString.value)
                  : const Center(
                child: CircularProgressIndicator(),
              );
            })),);
  }

  Widget errorWidget(String err) {
    if (err == 'network error') {
      return Column(
        children: [
          Icon(
            Icons.wifi_off,
            size: 30,
            color: Colors.red[200],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
              "No internet connection. Please ensure a stable connection and retry"),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => logicCtrl.refreshAllProducts(),
            child: Text(
              "refresh",
              style: context.textTheme.bodyMedium,
            ),
          )
        ],
      );
    } else {
      return Padding(
        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.error,
                size: 30,
                color: Colors.red[200],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("An error occured. Please retry or refresh the page"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => logicCtrl.refreshAllProducts(),
                child: Text(
                  "retry",
                  style: context.textTheme.bodyMedium,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
