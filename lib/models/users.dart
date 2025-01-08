class UserModel {


  String? id,email,password,name,role,picture;

  UserModel({
    this.id, this.email,this.password, this.name, this.role, this.picture
});

  UserModel.fromJson(Map<String, dynamic> json) {
   id = json['sid'];
   email = json['email'];
  // password = json['password'];
   name = json['given_name'];
   role = json['role'];
   picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['given_name'] = name;
    data['role'] = role;
    data['avatar'] = picture;
    return data;
  }

  static List<UserModel> usersFromSnapshot(List usersSnapshot) {
    return usersSnapshot.map((e) => UserModel.fromJson(e)).toList();
  }

}

