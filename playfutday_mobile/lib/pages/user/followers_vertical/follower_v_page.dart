import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/pages/general_error/general_error.dart';
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
  final message = "You not have followers...";

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
          case AllFollowerStatus.success:
            if (state.allFollower.isEmpty) {
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
    if (_isBottom) context.read<FollowerBloc>().add(AllFollowerFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
