import 'dart:convert';

import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/user_model.dart';
import 'package:arcainternational/services/api/_base_api.dart';
import 'package:dio/dio.dart';

class UserService {

  final BaseApi _api = new BaseApi();
  final Dio _dio = Application.dio;

  Future<User?> authentication({required String email, required String password}) async {
    final Response response = await _api.jsonPost(dio: _dio, path: "/user/auth", data: {
      "email": email,
      "password": password
    });

    if(response.statusCode == 200) {
      final Map<String, dynamic> userMap = response.data['content'];
      final User user = new User.fromJson(userMap);
      Application.authToken = user.authToken;
      Application.isAdmin = user.role == "admin";
      await Application.session.setSession(key: User.sessionKey, value: user.toString());

      return user;
    }

    return null;
  }

  Future<bool> isAuth() async {
    final String? userSession = await Application.session.getSession(key: User.sessionKey);
    if(userSession == null)
      return false;

    final User user = new User.fromJson(json.decode(userSession));
    Application.authToken = user.authToken;

    final Response response = await _api.get(dio: _dio, path: '/user');

    if(response.statusCode == 200) {
      final User newUser = User.fromJson(response.data['content']);
      Application.authToken = newUser.authToken;
      Application.isAdmin = user.role == "admin";
      await Application.session.unsetSession(key: User.sessionKey);
      await Application.session.setSession(key: User.sessionKey, value: newUser.toString());
      return true;
    }

    Application.authToken = null;
    await Application.session.unsetSession(key: User.sessionKey);
    return false;
  }

  Future<bool> isAdmin() async {
    if(Application.authToken == null)
      await this.isAuth();

    final String? userSession = await Application.session.getSession(key: User.sessionKey);
    if(userSession == null)
      return false;

    final User user = new User.fromJson(json.decode(userSession));
    return user.role == 'admin';
  }

  Future<List<User>> getEmployee() async {
    final List<User> results = <User>[];

    final Response response = await _api.get(dio: _dio, path: '/user?role=user');
    if(response.statusCode == 200) {
      for(final user in response.data['content']) {
        results.add(new User.fromJson(user));
      }
    }

    return results;
  }

  Future<bool> isUniqueEmail(String email) async {
    email = Uri.parse(email).toString();
    final Response response = await _api.get(dio: _dio, path: '/user/email?val=$email');

    if(response.statusCode == 200)
      return true;

    return false;
  }

  Future<List<User>> submitNewUser({required List<User> users}) async {
    List<User> result = <User>[];

    List<Map<String, dynamic>> mapData = <Map<String, dynamic>>[];
    for(User user in users) {
      mapData.add(user.toJson());
    }

    final Response response = await _api.jsonPost(dio: _dio, path: '/user', data: {
      'users': mapData
    });

    if(response.statusCode == 200) {
      final content = response.data['content'];
      for(dynamic user in content) {
        User newUser = new User.fromJson(user);
        result.add(newUser);
      }
    }

    return result;
  }

}