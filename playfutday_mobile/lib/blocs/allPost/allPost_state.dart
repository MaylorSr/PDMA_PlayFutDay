// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum AllPostStatus { initial, success, failure }

class AllPostState extends Equatable {
  const AllPostState({
    this.status = AllPostStatus.initial,
    this.allPost = const <Post>[],
    this.hasReachedMax = false,
  });

  final AllPostStatus status;
  final List<Post> allPost;
  final bool hasReachedMax;

  AllPostState copyWith({
    AllPostStatus? status,
    List<Post>? allPost,
    bool? hasReachedMax,
  }) {
    return AllPostState(
      status: status ?? this.status,
      allPost: allPost ?? this.allPost,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AllPostState { status: $status, hasReachedMax: $hasReachedMax, allPosts: ${allPost.length} }''';
  }

  @override
  List<Object> get props => [status, allPost, hasReachedMax];
}