import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/search/search_bloc.dart';
import 'package:playfutday_flutter/pages/general_error/general_error.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/blocs.dart';
import '../../models/user.dart';
import '../pages.dart';

class AllPostListBySearch extends StatefulWidget {
  const AllPostListBySearch({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AllPostListBySearch> createState() => _AllPostListState();
}

class _AllPostListState extends State<AllPostListBySearch> {
  final _scrollController = ScrollController();
  // ignore: unused_field
  final _postService = PostService();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, AllPostState>(
      builder: (context, state) {
        switch (state.status) {
          case AllPostStatus.failure:
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorScreen(
                      errorMessage: "Not found any post with that query",
                      icon: Icons.sports_soccer_rounded,
                      size: 100)
                ],
              ),
            );
          case AllPostStatus.success:
            if (state.allPost.isEmpty) {
              return const ErrorScreen(
                  errorMessage: "The list of post is empty",
                  icon: Icons.sports_soccer_rounded,
                  size: 100);
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.normal)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allPost.length
                    ? const SizedBox()
                    : CardScreenPost(
                        post: state.allPost[index],
                        user: widget.user,
                        onDeletePressed: (id) {
                          context
                              .read<SearchBloc>()
                              .add(DeletePost(id, widget.user.id.toString()));
                        },
                        onLikePressed: (id) {
                          context.read<SearchBloc>().add(GiveLike(id));
                        },
                        onCommentPressed: (int idPost, String message) {
                          context
                              .read<SearchBloc>()
                              .add(SendComment(idPost, message));
                        },
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.allPost.length
                  : state.allPost.length + 1,
              controller: _scrollController,
            );
          case AllPostStatus.initial:
            return LoadingAnimationWidget.twoRotatingArc(
                color: const Color.fromARGB(255, 6, 49, 122), size: 45);
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<SearchBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
