part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  final bool? hasReachedMax;
  const UsersLoaded({required this.users,  this.hasReachedMax});

  @override
  List<Object> get props => [users];
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}
