import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
                children: [
                  const Icon(Icons.sports_soccer, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    'Not found any posts',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AllPostBloc>().add(OnRefresh());
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
                      context.read<AllPostBloc>().add(OnRefresh());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<AllPostBloc>(context).add(OnRefresh());
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast)),
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.allPost.length
                      ?  LoadingAnimationWidget.twoRotatingArc(
                        color: const Color.fromARGB(255, 6, 49, 122), size: 45)
                      : CardScreenPost(
                          post: state.allPost[index],
                          user: widget.user,
                          onDeletePressed: (id) {
                            context
                                .read<AllPostBloc>()
                                .add(DeletePost(id, widget.user.id.toString()));
                          },
                          onLikePressed: (id) {
                            context.read<AllPostBloc>().add(GiveLike(id));
                          },
                          onCommentPressed: (id, message) {
                            context
                                .read<AllPostBloc>()
                                .add(SendComment(id, message));
                          });
                },
                scrollDirection: Axis.vertical,
                itemCount: state.hasReachedMax
                    ? state.allPost.length
                    : state.allPost.length + 1,
                controller: _scrollController,
              ),
            ));
          case AllPostStatus.initial:
            return Center(
              child: LoadingAnimationWidget.twoRotatingArc(
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
    if (_isBottom) context.read<AllPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
