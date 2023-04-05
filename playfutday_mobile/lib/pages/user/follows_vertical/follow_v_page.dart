import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';
import '../../../blocs/follows/follow_event.dart';
import '../../../models/user.dart';
import '../../bottom_loader.dart';
import 'follow_v.dart';

class AllFollowListVertical extends StatefulWidget {
  final User user;

  const AllFollowListVertical({Key? key, required this.user}) : super(key: key);

  @override
  State<AllFollowListVertical> createState() => _AllFollowListVercialState();
}

class _AllFollowListVercialState extends State<AllFollowListVertical> {
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
            return const Center(
              child: Text('You not have any user to follow'),
            );
          case AllFollowStatus.success:
            if (state.allFollow.isEmpty) {
              return const Center(
                child: Text('You not have any user to follow'),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allFollow.length
                    ? const BottomLoader()
                    : FollowsScreen(
                        userFollow: state.allFollow[index],
                        user: widget.user,
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.allFollow.length
                  : state.allFollow.length + 1,
              controller: _scrollController,
            );
          case AllFollowStatus.initial:
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
    if (_isBottom) context.read<FollowBloc>().add(AllFollowFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
