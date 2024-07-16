import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final GetUser getUser;
  List<User> usersData = [];
  int currentPage = 1;
  bool hasReachedMax = false;
  UserBloc({required this.getUsers, required this.getUser})
      : super(UserInitial()) {
    on<GetUserEvent>(_userEvent);
    on<GetUsersEvent>(_usersEvent);
    on<FetchMoreUsers>(_fetchMoreUsers);
  }

  FutureOr<void> _userEvent(GetUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await getUser.execute(event.id);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  FutureOr<void> _usersEvent(
      GetUsersEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await getUsers.execute(event.page);
      usersData.addAll(users);
      emit(UsersLoaded(users: usersData));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  FutureOr<void> _fetchMoreUsers(
      FetchMoreUsers event, Emitter<UserState> emit) async {
    if (hasReachedMax) return;

    try {
      final users = await getUsers.execute(currentPage);
      if (users.isEmpty) {
        hasReachedMax = true;
      } else {
        emit(UsersLoaded(
            users: (state as UsersLoaded).users + users, hasReachedMax: true));
        currentPage++;
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
