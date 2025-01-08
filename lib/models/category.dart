import 'package:api_practice/screens/categories.dart';

class CategoryModel {

  int? id;
  String? name, image;

  CategoryModel({
     this.id,
     this.name,
     this.image,

});

   CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  static List<CategoryModel> categoriesFromSnapshot(List categoriesSnapshot) {
     return categoriesSnapshot.map((e) => CategoryModel.fromJson(e)).toList();
  }
}