import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:api_practice/models/category.dart';
import 'package:api_practice/models/product.dart';
import 'package:api_practice/models/users.dart';
import 'package:api_practice/services/auth_Handler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/constants/strings.dart';

class StoreAPI extends GetxController {

  static final auth0 = Auth0();

  static Future<List> getData(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri.http(Strings.storeBaseURI, "/api/v1/$path", queryParameters);

    // final isAuthorized = await auth0.validateAccessToken().onError((error, stackTrace) =>
    //     throw Exception(error.toString())
    // );
    //
    // if(!isAuthorized) {
    //   //Get.offAndToNamed(Routes.userValidator);
    //   throw Exception('User not authorized/authenticated');
    // }

    var response = await http.get(uri).catchError((err) {
      err is SocketException
          ? throw Exception('socket error')
          : throw Exception(err);
    });
    log(response.statusCode.toString());
    List data = jsonDecode(response.body);
    print('statusCode:${response.statusCode}');
    return data;
  }

  static Future<List<ProductModel>> getAllProducts(
      {Map<String, dynamic>? queryParameter}) async {
    final data =
        await getData(path: 'products', queryParameters: queryParameter);
    return ProductModel.productsFromSnapshot(data);
  }

  static Future<List<CategoryModel>> getAllCategories() async {
    final data = await getData(path: "categories");
    return CategoryModel.categoriesFromSnapshot(data);
  }

  static Future<List<UserModel>> getAllUsers() async {
    final data = await getData(path: 'users');
    return UserModel.usersFromSnapshot(data);
  }
}
