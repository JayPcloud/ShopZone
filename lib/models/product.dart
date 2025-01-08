import 'package:api_practice/models/category.dart';

class ProductModel {

  int? id, price,qty;
  String? title, description;
  List<dynamic>? images;
  CategoryModel? category;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.images,
    this.category,
    this.qty
});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    images = json['images'].cast<String>();
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['images'] = images;
    if(category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }

  static List<ProductModel> productsFromSnapshot(List productsSnapshot) {
    return productsSnapshot.map((e) {return ProductModel.fromJson(e);}).toList();
  }
}