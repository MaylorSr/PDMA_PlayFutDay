// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithUserNameButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginInWithUserNameButtonPressed(
      {@required required this.username, @required required this.password});

  @override
  List<Object> get props => [username, password];
}
