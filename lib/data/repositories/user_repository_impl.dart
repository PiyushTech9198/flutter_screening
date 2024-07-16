import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final http.Client client;

  UserRepositoryImpl(this.client);

  @override
  Future<List<User>> getUsers(int page) async {
    final response = await client.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<User> getUser(int id) async {
    final response = await client.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return UserModel.fromJson(body['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
