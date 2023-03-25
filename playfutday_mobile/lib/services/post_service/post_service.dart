// ignore_for_file: override_on_non_overriding_member, avoid_print

import 'dart:convert';

import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/post_repository/post_repository.dart';
import '../localstorage_service.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Order(2)
@singleton
class PostService {
  // ignore: unused_field
  late LocalStorageService _localStorageService;
  late PostRepository _postRepository;
  // ignore: unused_field

  PostService() {
    _postRepository = GetIt.I.get<PostRepository>();

    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<PostResponse?> getAllPosts([int page = 0]) async {
    // ignore: avoid_print
    print("get all posts");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allPost(page);
      // ignore: avoid_print
      print(response.content);
      return response;
    }
    return null;
  }

  @override
  Future<PostResponse?> getAllPostsByTag([int page = 0, query]) async {
    // ignore: avoid_print
    print("get all posts by tag");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allPostByTag(
          page, query.toString().toUpperCase());
      // ignore: avoid_print
      print(response.content);
      return response;
    }
    return null;
  }

  @override
  Future<void> newPost(String tag, String description, file) async {
    print("New post now");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _postRepository.instanceNewPost(tag, description, file, token);
    }
  }

/*
  @override
  Future<void> newPost(String tag, String description, file) async {
    print("New post now");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _postRepository.instanceNewPost(tag, description, file, token);
    }
  }*/

  @override
  Future<PostResponse?> getMyPosts([int page = 0]) async {
    // ignore: avoid_print
    print("get my posts");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.myAllPost(page);
      // ignore: avoid_print
      print(response.content);
      return response;
    }
    return null;
  }

  @override
  Future<PostResponse?> getPostsOfUser(int page, String username) async {
    // ignore: avoid_print
    print("get posts of a user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response =
          await _postRepository.getPostsOfUser(page, username);
      // ignore: avoid_print
      print(response.content);
      return response;
    }
    return null;
  }

/*
  @override
  Future<PostFavResponse?> fetchPostsFav([int page = 0]) async {
    // ignore: avoid_print
    print("get fav posts");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostFavResponse response = await _postRepository.allFavPost(page);
      // ignore: avoid_print
      print(response.totalPages);
      print(response.content);
      return response;
    }
    return null;
  }
*/
  Future<void> deletePost(int idPost, String userId) async {
    String? token = _localStorageService.getFromDisk('user_token');
    if (token != null) {
      _postRepository.deletePost(idPost, userId);
    }
    // ignore: avoid_returning_null_for_void
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  Future<Post?> postLikeByMe(int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');
    if (token != null) {
      Post p = await _postRepository.postLike(idPost);
      print(p);
      return p;
    }
    return null;
  }

  /*

  Future<MyFavPost?> postLikeByMeFav(int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');
    if (token != null) {
      MyFavPost p = await _postRepository.postLikeFav(idPost);
      print(p);
      return p;
    }
    return null;
  }

  */
  
  Future<Post?> sendCommentaries(String message, int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');

    if (token != null) {
      Post p = await _postRepository.sendComment(message, idPost);
      print(p);
      return p;
    }
    return null;
  }
}
