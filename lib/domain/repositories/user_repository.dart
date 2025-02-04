import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers(int page);
  Future<User> getUser(int id);
}
