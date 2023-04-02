import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/myFavPost/my_fav_Post_bloc.dart';
import '../../../models/user.dart';
import '../../../services/services.dart';
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
                      context.read<MyFavPostBloc>().add(OnRefresh());
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
                      context.read<MyFavPostBloc>().add(OnRefresh());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allPost.length
                    ? const BottomLoader()
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
    if (_isBottom) context.read<MyFavPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
