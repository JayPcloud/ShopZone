import '../utils/constants/strings.dart';

class AuthUserModel {
  String? client_id, email, password, connection, username;

  AuthUserModel({
    this.client_id,
    required this.email,
    required this.password,
    this.connection = Strings.authDBConnection,
    this.username,
  });

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    client_id = json['client_id'];
    email = json['email'];
    password = json['password'];
    connection = json['connection'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String,dynamic>{};
    data['client_id'] = client_id;
    data['email'] = email;
    data['password'] = password;
    data['connection'] = connection;
    data['username'] = username;
    return data;
  }
}
