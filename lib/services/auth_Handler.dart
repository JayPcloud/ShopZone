import 'dart:convert';
import 'package:api_practice/services/db_services.dart';
import 'package:api_practice/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';
import '../routes/routes.dart';
import '../utils/constants/strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth0 extends GetxController {

  final appAuth = const FlutterAppAuth();

  final secureStorage = const FlutterSecureStorage();

  static String? _accessToken;

  static String? _refreshToken;

  static String? _accessExpDate;

  get access => _accessToken;

  get refreshT => _refreshToken;

  get exp => _accessExpDate;

  static const headers = {'Content-Type': Strings.authContentType};

  static const scope = [
  'openid',
  'profile',
  'email',
  'offline_access',
  ];

  bool get tokensNotNull =>
      _refreshToken != null && _accessToken != null && _accessExpDate != null;

  void _storeTokenLocally({
    required String? access,
    required String? accessExp,
    required String? refresh,
  }) {
    if (refresh != null && access != null) {
      secureStorage.write(key: 'Access_Token', value: access);
      secureStorage.write(key: 'AccessToken_ExpDate', value: accessExp);
      secureStorage.write(key: 'Refresh_Token', value: refresh);
    }
  }

  Future<bool> isAuth0TokenValid() async {
    const secureStorage = FlutterSecureStorage();
    _refreshToken = await secureStorage.read(key: 'Refresh_Token');
    _accessToken = await secureStorage.read(key: 'Access_Token');
    _accessExpDate = await secureStorage.read(key: 'AccessToken_ExpDate');
    final isValidToken = await validateAccessToken();

    return tokensNotNull && isValidToken;
  }

  Future<void> signUp(AuthUserModel authUserModel) async {
    Uri url = Uri.https(Strings.authBaseURi, 'dbconnections/signup');
    var resp = await http
        .post(url, headers: headers, body: jsonEncode(authUserModel.toJson()))
        .catchError((err) {
      print(err.toString());
      throw Exception(err);
    });
    print(resp.statusCode.toString());
    print(resp.body);

    var data = jsonDecode(resp.body);
    final user = AuthUserModel.fromJson(data);
  }



  Future<void> authenticate(context) async {
    // HelperFunc.showLoadingCircle(context);
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
    try {
      print('object');
      final authorizationTokenRequest = AuthorizationTokenRequest(
        Strings.clientId,
        Strings.redirectUrl,
        scopes: scope,
        issuer: 'https://${Strings.authBaseURi}',
      );

      final result =
          await appAuth.authorizeAndExchangeCode(authorizationTokenRequest);

      HelperFunc.parseJWToken(result.idToken!);

      _storeTokenLocally(
          access: result.accessToken,
          refresh: result.refreshToken,
          accessExp: result.accessTokenExpirationDateTime.toString());
    } catch (e) {
      HelperFunc.scaffoldMessenger(context, const Text('An error occured. Please try again later'));
      print(e.toString());
    }
    Get.offAllNamed(Routes.userValidator);
  }


  Future<int> revokeRefreshToken() async {
   final url = Uri.https(Strings.authBaseURi, 'oauth/revoke',);
    final response = await http.post(url,
    headers: headers,
      body: json.encode({
        "client_id": Strings.clientId,
        "client_secret": Strings.clientSecret,
        "token": _refreshToken??await secureStorage.read(key: 'Refresh_Token')
      })
    );
    Get.offAllNamed(Routes.userValidator);
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }


  Future<void> endAuthSession(context) async {
    try{

      final response = await appAuth.token(
          TokenRequest(
            Strings.clientId, Strings.redirectUrl,
            issuer: 'https://${Strings.authBaseURi}',
            refreshToken: _refreshToken,
          )
      );
      print(response.idToken);
      final resp = await appAuth.endSession(EndSessionRequest(
        idTokenHint: response.idToken,
        postLogoutRedirectUrl: Strings.redirectUrl,
        issuer: 'https://${Strings.authBaseURi}',
      ));
      print(resp.state);
      await secureStorage.delete(key: 'Refresh_Token');
      await secureStorage.delete(key: 'Access_Token');
      await secureStorage.delete(key: 'AccessToken_ExpDate');
      final db = await DBServices.instance.getDatabase();
      db.delete(Strings.dbAddressTableName);
      db.delete(Strings.dbCartTable['table']!);
      print('session ended');
      Get.offAllNamed(Routes.userValidator);
    } catch(e) {

      HelperFunc.scaffoldMessenger(context, const Text('An error occurred'));
      throw Exception(e.toString());

    }
  }

  Future<Map<String, dynamic>> fetchIdToken() async {
    if( await validateAccessToken()) {
      final response = await appAuth.token(
        TokenRequest(
          Strings.clientId, Strings.redirectUrl,
          issuer: 'https://${Strings.authBaseURi}',
          refreshToken: _refreshToken,
          scopes: scope
        ),
      );
      print(HelperFunc.parseJWToken(response.idToken!));
      return HelperFunc.parseJWToken(response.idToken!);
    }else{
      print('An error occured');
      return <String, dynamic>{};
    }


  }

  Future<bool> validateAccessToken() async {
    if (tokensNotNull) {
      final now = DateTime.now();
      final expDate = DateTime.parse(_accessExpDate!);
      if (expDate.difference(now).inMinutes < 5) {
        try {
          final response = await appAuth.token(
              TokenRequest(
              Strings.clientId, Strings.redirectUrl,
              issuer: 'https://${Strings.authBaseURi}',
              refreshToken: _refreshToken)
          ).onError((error, stackTrace) {
            print('token request error: ${error.toString()}');
            throw Exception('Token request error');
          }
          );

          print(response.refreshToken);
          print(response.accessToken);
          _accessToken = response.accessToken;
          _accessExpDate = response.accessTokenExpirationDateTime.toString();
          _storeTokenLocally(
            access: response.accessToken,
            accessExp: response.accessTokenExpirationDateTime.toString(),
            refresh: response.refreshToken ?? _refreshToken,
          );
          print('refreshed:$_accessExpDate');
        } catch (e) {
          print(e.toString());
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }


  Future<void> authWithPassword({required String username, required String password}) async {
    Uri url = Uri.https(Strings.authBaseURi,'oauth/token',{
      'grant_type': 'password',
      'client_id' : Strings.clientId,
      'username' : username,
      'password' : 'Password12#',
      'client_secret' : Strings.clientSecret,
      'scope' : scope
    });
    final response = await http.post(url, headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if(response.statusCode == 200){
      print(response.body);
      final token = jsonDecode(response.body);
      secureStorage.write(key: 'Access_Token', value: token['access_token']);
      secureStorage.write(key: 'AccessToken_ExpDate', value:token['expires_in']);
      secureStorage.write(key: 'Password', value: token['token_type']);
    }else{
      HelperFunc.scaffoldMessenger(Get.context!, const Text('Unauthorized user'));
      print(response.body);
      print(response.statusCode);
      print(response.reasonPhrase);
    }

  }
//static final ioClient = http.Client();

// static Future<void> authorize() async {
//   print('object');
//   final codeVerifier = generateCodeVerifier();
//   final codeChallenge = generateCodeChallenge(codeVerifier);
//
//   Uri getUrl = Uri.https(Strings.authBaseURi, 'authorize', {
//     'response_type': 'code',
//     'client_id': Strings.clientId,
//     'code_challenge_method': 'S256',
//     'code_challenge': codeChallenge,
//     'connection': Strings.authDBConnection,
//     'redirect_uri': 'com.example.apipractice://oauth2redirect',
//     //'scope': 'openid profile email offline_access',
//   });
//   // Uri getUrl = Uri.parse('https://${Strings.authBaseURi}/authorize',).replace(
//   //     queryParameters: {
//   //     'response_type': 'code',
//   //     'client_id': Strings.clientId,
//   //     'code_challenge_method': 'S256',
//   //     'code_challenge': codeChallenge,
//   //     'connection': Strings.authDBConnection,
//   //     'redirect_uri': 'com.example.apipractice://oauth2redirect',
//   //   }
//   // );
//   var getResp = await http.get(
//     getUrl,
//   );
//   print(getResp.statusCode.toString());
//   //print(getResp.headers);
//    print(getResp.body);
//   print(getResp.statusCode.toString());
//   // if (getResp.statusCode != 302) {
//   //  // print(getResp.body);
//   //   throw Exception(getResp.body);
//   // }
//   print('exchanged handshakes');
//   final locationHeader =
//       getResp.headers['location'] ?? getResp.headers['Location'];
//   final uri = Uri.parse(locationHeader!);
//   final authorizationCode = uri.queryParameters['code'];
//
//   Uri postUrl = Uri.https(Strings.authBaseURi, 'oauth/token', {
//     'grant_type': 'authorization_code',
//     'client_id': Strings.clientId,
//     'code': authorizationCode,
//     'code_verifier': codeVerifier,
//     'redirect_uri': 'com.example.apipractice://oauth2redirect',
//   });
//   final tokenResp = await http.post(postUrl,
//       headers: {'Content-Type': 'application/x-www-form-urlencoded'});
//
//   if (tokenResp.statusCode != 200) {
//     print(tokenResp.body);
//     throw Exception(tokenResp.body);
//   }
//   var data = jsonDecode(tokenResp.body);
//   print(data);
// }
//
// static String generateCodeVerifier() {
//   final random = Random.secure();
//   final codeVerifier = List.generate(43, (_) => random.nextInt(256))
//       .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
//       .join();
//   return codeVerifier;
// }
//
// static String generateCodeChallenge(String codeVerifier) {
//   final codeChallenge =
//       base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes);
//   final cleanedCodeChallenge = codeChallenge.replaceAll('=', "");
//   print(cleanedCodeChallenge);
//   return cleanedCodeChallenge;
// }

}
