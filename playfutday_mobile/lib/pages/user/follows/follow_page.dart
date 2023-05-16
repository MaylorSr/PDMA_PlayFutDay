import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';

import '../../../blocs/follows/follow_event.dart';
import '../../../models/models.dart';
import 'follow_screen.dart';

class AllFollowList extends StatefulWidget {
  final User user;
  const AllFollowList({Key? key, required this.user}) : super(key: key);

  @override
  State<AllFollowList> createState() => _AllFollowListState();
}

class _AllFollowListState extends State<AllFollowList> {
  final _scrollController = ScrollController();

  // ignore: unused_field
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowBloc, AllFollowState>(
      builder: (context, state) {
        switch (state.status) {
          case AllFollowStatus.failure:
            return const SizedBox();
          case AllFollowStatus.success:
            if (state.allFollow.isEmpty) {
              return const SizedBox();
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allFollow.length
                    ? LoadingAnimationWidget.twoRotatingArc(
                        color: const Color.fromARGB(255, 6, 49, 122), size: 45)
                    : FollowScreen(
                        userFollow: state.allFollow[index],
                        user: widget.user,
                      );
              },
              scrollDirection: Axis.horizontal,
              itemCount: state.hasReachedMax
                  ? state.allFollow.length
                  : state.allFollow.length + 1,
              controller: _scrollController,
            );
          case AllFollowStatus.initial:
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
    if (_isBottom) context.read<FollowBloc>().add(AllFollowFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
