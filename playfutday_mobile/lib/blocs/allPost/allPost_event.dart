// ignore: file_names
import 'package:equatable/equatable.dart';

abstract class AllPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPostFetched extends AllPostEvent {}

class DeletePost extends AllPostEvent {
  @override
  DeletePost(this.idPost, this.idUser);

  final int idPost;
  final String idUser;
}

class GiveLike extends AllPostEvent {
  @override
  GiveLike(this.idPost);
  final int idPost;
}

class SendComment extends AllPostEvent {
  @override
  SendComment(this.idPost, this.message);
  final int idPost;
  final String message;
}

class OnRefresh extends AllPostEvent {}
