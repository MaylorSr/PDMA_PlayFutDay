import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/followers/followers.dart';
import '../../../models/user.dart';
import '../../bottom_loader.dart';
import '../follows_vertical/follow_v.dart';

class AllFollowerListVertical extends StatefulWidget {
  final User user;

  const AllFollowerListVertical({Key? key, required this.user})
      : super(key: key);

  @override
  State<AllFollowerListVertical> createState() =>
      _AllFollowerListVercialState();
}

class _AllFollowerListVercialState extends State<AllFollowerListVertical> {
  final _scrollController = ScrollController();
  // ignore: unused_field
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowerBloc, AllFollowerState>(
      builder: (context, state) {
        switch (state.status) {
          case AllFollowerStatus.failure:
            return const Center(
              child: Text('You not have followers'),
            );
          case AllFollowerStatus.success:
            if (state.allFollower.isEmpty) {
              return const Center(
                child: Text('You not have any followers'),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allFollower.length
                    ? const BottomLoader()
                    : FollowsScreen(
                        userFollow: state.allFollower[index],
                        user: widget.user,
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.allFollower.length
                  : state.allFollower.length + 1,
              controller: _scrollController,
            );
          case AllFollowerStatus.initial:
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
    if (_isBottom) context.read<FollowerBloc>().add(AllFollowerFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
