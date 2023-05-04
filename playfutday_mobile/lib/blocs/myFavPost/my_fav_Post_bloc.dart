// ignore: file_names
import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/allPost/allPost_state.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:stream_transform/stream_transform.dart';
import '../allPost/allPost_event.dart';

const throttleDuration = Duration(milliseconds: 500);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MyFavPostBloc extends Bloc<AllPostEvent, AllPostState> {
  MyFavPostBloc(this._postService, this.username)
      : super(const AllPostState()) {
    on<AllPostFetched>(
      _onAllPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DeletePost>(_onDeletePost);
    on<GiveLike>(_onLikedPost);
    on<OnRefresh>(_onRefreshElements);
    on<SendComment>(_onSendComment);
  }

  // ignore: unused_field
  final PostService _postService;
  final String username;

  Future<void> _onAllPostFetched(
      AllPostFetched event, Emitter<AllPostState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllPostStatus.initial) {
        page = 0;
        final allPost = await _postService.fetchPostsFav(page);
        return emitter(state.copyWith(
          status: AllPostStatus.success,
          allPost: allPost!.content,
          hasReachedMax: allPost.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allPost = await _postService.fetchPostsFav(page);

      emitter(state.copyWith(
          status: AllPostStatus.success,
          allPost: List.of(state.allPost)..addAll(allPost!.content),
          hasReachedMax: allPost.totalPages - 1 <= page));
    } catch (_) {
      emitter(state.copyWith(status: AllPostStatus.failure));
    }
  }

  Future<void> _onDeletePost(
      DeletePost event, Emitter<AllPostState> emitter) async {
    // final deleteInProgress = state.allPost.map((post) {
    //   // ignore: unrelated_type_equality_checks
    //   return post.id == event.idPost ? state.copyWith() : post;
    // }).toList();

    // print(deleteInProgress);
    emitter(state.copyWith(
        status: AllPostStatus.success,
        allPost: state.allPost,
        hasReachedMax: false));

    unawaited(
      _postService.deletePost(event.idPost, event.idUser).then((_) {
        final deleteSuccess = List.of(state.allPost)
          ..removeWhere((post) => post.id == event.idPost);
        emitter(state.copyWith(allPost: deleteSuccess));
      }),
    );
  }

  Future _onLikedPost(GiveLike event, Emitter<AllPostState> emit) async {
    final updatedPost = await _postService.postLikeByMe(event.idPost);

    final likeInProgress = state.allPost.map((post) {
      return post.id == event.idPost
          ? post.copyWith(
              post.likesByAuthor = updatedPost?.likesByAuthor,
              post.countLikes = updatedPost?.countLikes,
              post.commentaries = updatedPost?.commentaries)
          : post;
    }).toList();

    emit(state.copyWith(
        status: AllPostStatus.success,
        allPost: likeInProgress,
        hasReachedMax: false));
  }

  FutureOr<void> _onRefreshElements(
      OnRefresh event, Emitter<AllPostState> emit) async {
    emit(state.copyWith(status: AllPostStatus.initial, allPost: null));
    add(AllPostFetched());
  }

  Future _onSendComment(SendComment event, Emitter<AllPostState> emit) async {
    final updatedPost =
        await _postService.sendCommentaries(event.message, event.idPost);

    final commentInProgress = state.allPost.map((post) {
      return post.id == event.idPost
          ? post.copyWith(
              post.likesByAuthor = post.likesByAuthor,
              post.countLikes = post.countLikes,
              post.commentaries = updatedPost?.commentaries)
          : post;
    }).toList();

    emit(state.copyWith(
        status: AllPostStatus.success,
        allPost: commentInProgress,
        hasReachedMax: false));
  }
}
