import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/blocs.dart';
import '../../models/user.dart';
import '../pages.dart';

class AllPostList extends StatefulWidget {
  const AllPostList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AllPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<AllPostList> {
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
    return BlocBuilder<AllPostBloc, AllPostState>(
      builder: (context, state) {
        switch (state.status) {
          case AllPostStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.sports_soccer, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'Not found any posts',
                    style: TextStyle(fontSize: 20),
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
                      context.read<AllPostBloc>().add(AllPostFetched());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.allPost.length
                      ? const BottomLoader()
                      : CardScreenPost(
                          post: state.allPost[index],
                          user: widget.user,
                          onDeletePressed: (id) {
                            context
                                .read<AllPostBloc>()
                                .add(DeletePost(id, widget.user.id.toString()));
                          });
                },
                scrollDirection: Axis.horizontal,
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
    if (_isBottom) context.read<AllPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
