import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/pages/general_error/general_error.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

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

  final errorMessage = "Not found any post";
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
            return ErrorWidget(errorMessage: errorMessage);

          case AllPostStatus.success:
            if (state.allPost.isEmpty) {
              return const ErrorWidget(
                  errorMessage: "The list of post is empty");
            }
            return Expanded(
              child: RefreshIndicator(
                edgeOffset: 0,
                backgroundColor: AppTheme.grey,
                color: AppTheme.successEvent,
                strokeWidth: 3.5,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  BlocProvider.of<AllPostBloc>(context).add(
                    OnRefresh(),
                  );
                },
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.normal),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.allPost.length
                        ? const SizedBox()
                        : CardScreenPost(
                            post: state.allPost[index],
                            user: widget.user,
                            onDeletePressed: (id) {
                              context.read<AllPostBloc>().add(
                                  DeletePost(id, widget.user.id.toString()));
                            },
                            onLikePressed: (id) {
                              context.read<AllPostBloc>().add(GiveLike(id));
                            },
                            onCommentPressed: (id, message) {
                              context.read<AllPostBloc>().add(
                                    SendComment(id, message),
                                  );
                            },
                          );
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: state.hasReachedMax
                      ? state.allPost.length
                      : state.allPost.length + 1,
                  controller: _scrollController,
                ),
              ),
            );
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

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ErrorScreen(
              errorMessage: errorMessage,
              icon: Icons.sports_soccer_outlined,
              size: 100,
            ),
            SizedBox(
              height: AppTheme.minHeight,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AllPostBloc>().add(OnRefresh());
              },
              child: const Text('reload page'),
            ),
          ],
        ),
      ),
    );
  }
}
