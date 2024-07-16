import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';
import '../blocs/user_bloc.dart';

class UserDetailPage extends StatelessWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        getUsers: GetUsers(context.read<UserRepository>()),
        getUser: GetUser(context.read<UserRepository>()),
      )..add(GetUserEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Detail'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(user.avatar),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(
                  child: Text('Failed to load user: ${state.message}'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
