// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/myFavPost/my_fav_Post_bloc.dart';
import '../../../models/user.dart';
import '../../../services/services.dart';
import '../../../theme/app_theme.dart';
import '../../general_error/general_error.dart';
import '../../pages.dart';

class MyFavPostList extends StatefulWidget {
  const MyFavPostList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyFavPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<MyFavPostList> {
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
    return BlocBuilder<MyFavPostBloc, AllPostState>(
      builder: (context, state) {
        switch (state.status) {
          case AllPostStatus.failure:
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ErrorScreen(
                      errorMessage: "Not found any favorite post",
                      icon: Icons.favorite_rounded,
                      size: 100,
                    ),
                    SizedBox(
                      height: AppTheme.minHeight,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MyFavPostBloc>().add(OnRefresh());
                      },
                      child: const Text('Try Again'),
                    )
                  ],
                ),
              ),
            );
          case AllPostStatus.success:
            if (state.allPost.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ErrorScreen(
                        errorMessage: "Not found any favorite post",
                        icon: Icons.favorite_rounded,
                        size: 100,
                      ),
                      SizedBox(
                        height: AppTheme.minHeight,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MyFavPostBloc>().add(OnRefresh());
                        },
                        child: const Text('Try Again'),
                      )
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allPost.length
                    ? LoadingAnimationWidget.dotsTriangle(
                        color: const Color.fromARGB(255, 6, 49, 122), size: 45)
                    : CardScreenPost(
                        post: state.allPost[index],
                        user: widget.user,
                        onDeletePressed: (id) {
                          context
                              .read<MyFavPostBloc>()
                              .add(DeletePost(id, widget.user.id.toString()));
                        },
                        onLikePressed: (id) {
                          context.read<MyFavPostBloc>().add(GiveLike(id));
                        },
                        onCommentPressed: (id, message) {
                          context
                              .read<MyFavPostBloc>()
                              .add(SendComment(id, message));
                        });
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.allPost.length
                  : state.allPost.length + 1,
              controller: _scrollController,
            );
          case AllPostStatus.initial:
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                  color: const Color.fromARGB(255, 6, 49, 122), size: 45),
            );
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
    if (_isBottom) context.read<MyFavPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
