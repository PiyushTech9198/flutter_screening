import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<User> execute(int id) {
    return repository.getUser(id);
  }
}
