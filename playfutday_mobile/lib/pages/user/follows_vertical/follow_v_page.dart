import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';
import '../../../blocs/follows/follow_event.dart';
import '../../../models/user.dart';
import '../../bottom_loader.dart';
import '../../general_error/general_error.dart';
import 'follow_v.dart';

class AllFollowListVertical extends StatefulWidget {
  final User user;

  const AllFollowListVertical({Key? key, required this.user}) : super(key: key);

  @override
  State<AllFollowListVertical> createState() => _AllFollowListVercialState();
}

class _AllFollowListVercialState extends State<AllFollowListVertical> {
  final _scrollController = ScrollController();
  final message = "You not follows any user...";

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorScreen(
                    errorMessage: message,
                    icon: Icons.mood_bad_outlined,
                    size: 50),
              ],
            );
          case AllFollowStatus.success:
            if (state.allFollow.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorScreen(
                      errorMessage: message,
                      icon: Icons.mood_bad_outlined,
                      size: 50),
                ],
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
