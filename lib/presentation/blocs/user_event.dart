part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends UserEvent {
  final int page;

  const GetUsersEvent(this.page);

  @override
  List<Object> get props => [page];
}

class GetUserEvent extends UserEvent {
  final int id;

  const GetUserEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FetchMoreUsers extends UserEvent {}
