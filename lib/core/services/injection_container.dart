import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../presentation/blocs/user_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => UserBloc(
        getUsers: sl(),
        getUser: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  

  // External
  sl.registerLazySingleton(() => http.Client());
}
