import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/injection_container.dart' as di;

import 'presentation/blocs/user_bloc.dart';
import 'presentation/pages/user_list_page.dart';
import 'package:http/http.dart' as http;
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/get_user.dart';
import 'domain/usecases/get_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(http.Client()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            getUsers: GetUsers(context.read<UserRepository>()),
            getUser: GetUser(context.read<UserRepository>()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(
          fontFamily: 'SF-Pro',
          primarySwatch: Colors.blue,
        ),
        home: UserListPage(),
      ),
    );
  }
}
