import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/post_repository/post_repository.dart';
import '../../models/image_post_grid.dart';
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

  Future<PostResponse?> getAllPosts([int page = 0]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allPost(page);
      return response;
    }
    return null;
  }

  Future<List<ImagesPostGrid>?> getAllImageGridPost(String username) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      List<ImagesPostGrid> response =
          await _postRepository.getAllImagesPostGridOfUser(username);
      return response;
    }
    return null;
  }

  Future<PostResponse?> getAllPostsByTag([int page = 0, query]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allPostByTag(
          page, query.toString().toUpperCase());
      return response;
    }
    return null;
  }

  Future<dynamic> newPost(String tag, String description, file) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _postRepository.instanceNewPost(tag, description, file, token);
    }
  }

  Future<PostResponse?> getMyPosts([int page = 0]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.myAllPost(page);
      return response;
    }
    return null;
  }

  Future<PostResponse?> getPostsOfUser(int page, String username) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response =
          await _postRepository.getPostsOfUser(page, username);
      return response;
    }
    return null;
  }

  Future<PostResponse?> fetchPostsFav([int page = 0]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allFavPost(page);

      return response;
    }
    return null;
  }

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
      return p;
    }
    return null;
  }

  Future<Post?> sendCommentaries(String message, int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');

    if (token != null) {
      Post p = await _postRepository.sendComment(message, idPost);
      return p;
    }
    return null;
  }
}
