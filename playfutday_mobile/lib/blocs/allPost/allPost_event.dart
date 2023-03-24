// ignore: file_names
import 'package:equatable/equatable.dart';

abstract class AllPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPostFetched extends AllPostEvent {}

class DeletePost extends AllPostEvent {
  @override
  DeletePost(int idPost, String idUser);

  late int idPost;
  late String idUser;
}
