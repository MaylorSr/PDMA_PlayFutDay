import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/postUser/post_user_bloc.dart';

import '../../blocs/blocs.dart';
import '../../models/user.dart';
import '../../services/services.dart';
import '../../theme/app_theme.dart';
import '../bottom_loader.dart';
import '../post/card_post.dart';

class MyPostList extends StatefulWidget {
  const MyPostList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<MyPostList> {
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
    return BlocBuilder<MyPostBloc, AllPostState>(
      builder: (context, state) {
        switch (state.status) {
          case AllPostStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_soccer, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    'Not found any posts',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MyPostBloc>().add(OnRefresh());
                    },
                    child: const Text('Try Again'),
                  )
                ],
              ),
            );
          case AllPostStatus.success:
            if (state.allPost.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MyPostBloc>().add(OnRefresh());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return RefreshIndicator(
              edgeOffset: 0,
              backgroundColor: AppTheme.grey,
              color: AppTheme.successEvent,
              strokeWidth: 3.5,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                BlocProvider.of<MyPostBloc>(context).add(OnRefresh());
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast)),
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.allPost.length
                      ? const SizedBox()
                      : CardScreenPost(
                          post: state.allPost[index],
                          user: widget.user,
                          onDeletePressed: (id) {
                            context
                                .read<MyPostBloc>()
                                .add(DeletePost(id, widget.user.id.toString()));
                          },
                          onLikePressed: (id) {
                            context.read<MyPostBloc>().add(GiveLike(id));
                          },
                          onCommentPressed: (id, message) {
                            context
                                .read<MyPostBloc>()
                                .add(SendComment(id, message));
                          });
                },
                scrollDirection: Axis.vertical,
                itemCount: state.hasReachedMax
                    ? state.allPost.length
                    : state.allPost.length + 1,
                controller: _scrollController,
              ),
            );
          case AllPostStatus.initial:
            return const Center(child: CircularProgressIndicator());
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
    if (_isBottom) context.read<MyPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
